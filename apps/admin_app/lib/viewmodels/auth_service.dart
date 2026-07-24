import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'platform/google_login_helper.dart';
import '../models/user_model.dart';
import '../models/enums.dart';
import 'espy_repository.dart';
import 'debug_service.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'us-central1');
  final EspyRepository _repository;
  final GoogleLoginHelper _googleSignIn = getGoogleLoginHelper();
  final DebugService _debug = DebugService();

  User? _user;
  UserModel? _userData;
  bool _isLoading = true;
  bool _isProvisioning = false;
  bool _isInitializing = false;

  User? get user => _user;
  UserModel? get userData => _userData;
  bool get isLoading => _isLoading;
  bool get isProvisioning => _isProvisioning;
  bool get isInitializing => _isInitializing;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  AuthService(this._repository) {
    _auth.authStateChanges().listen((u) {
      if (!_isInitializing) _onAuthStateChanged(u);
    });
    _init(); 
  }

  Future<void> _init() async {
    _isInitializing = true;
    _isLoading = true;
    notifyListeners();

    try {
      if (kIsWeb) {
        final credential = await _auth.getRedirectResult();
        final user = credential.user;
        if (user != null) {
          await _handleUserSync(user);
        }
      }
      
      if (_auth.currentUser != null) {
        await _handleUserSync(_auth.currentUser!);
      }
    } catch (e) {
      _debug.log('AUTH', 'Init Error', data: e);
    } finally {
      _isInitializing = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _debug.log('AUTH', 'State Change: ${user?.email ?? 'Logged Out'}');
    if (_user?.uid == user?.uid && _userData != null) return;
    
    _user = user;
    if (user != null) {
      await _handleUserSync(user);
    } else {
      _userData = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _handleUserSync(User user) async {
    try {
      await fetchUserData();
      
      final bool isSuperAdmin = ['geo.elnajjar@gmail.com', 'admin@espy.com'].contains(user.email);
      if (_userData == null && isSuperAdmin) {
        _debug.log('AUTH', 'Super Admin missing profile. Bootstrapping...');
        await _createInitialUserDoc(user);
        await fetchUserData();
      }

      if (_userData != null) {
        await _repository.updateLastActive(user.uid);
      }
    } catch (e) {
      _debug.log('AUTH', 'Sync Error', data: e);
    }
  }

  Future<void> fetchUserData() async {
    final uid = _user?.uid ?? _auth.currentUser?.uid;
    if (uid == null) return;
    try {
      _isLoading = true;
      notifyListeners();
      _debug.log('AUTH', 'Fetching User Data for $uid');

      _userData = await _repository.getUser(uid);
      if (_userData != null) {
        _debug.log('AUTH', 'Profile Loaded: ${_userData!.role}');
      } else {
        _debug.log('AUTH', 'Profile missing in repository');
      }
    } catch (e) {
      _debug.log('AUTH', 'Fetch Error', data: e);
      _userData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkIsAdmin() async {
    if (_userData?.role == UserRole.admin) return true;
    final user = _auth.currentUser;
    if (user == null) return false;
    const superAdmins = ['admin@espy.com', 'committee@hope-bearer.org', 'geo.elnajjar@gmail.com', 'geodev122@gmail.com'];
    if (superAdmins.contains(user.email)) return true;
    try {
      final idToken = await user.getIdTokenResult();
      return idToken.claims?['admin'] == true || idToken.claims?['role'] == 'admin';
    } catch (e) {
      return false;
    }
  }

  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? initialRole,
    String? redemptionCode,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await _createInitialUserDoc(user, initialRole: initialRole, nameOverride: name);
        if (redemptionCode != null && redemptionCode.isNotEmpty) {
          try {
             await _functions.httpsCallable('redeemRechargeCode').call({'userId': user.uid, 'code': redemptionCode});
          } catch (e) {
            _debug.log('AUTH', 'Redemption failed', data: e);
          }
        }
      }
      return credential;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      try {
        final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
        await _handleUserSync(cred.user!);
        return cred;
      } on FirebaseAuthException catch (e) {
        if (email == 'geo.elnajjar@gmail.com' && (e.code == 'user-not-found' || e.code == 'invalid-credential' || e.code == 'invalid-login-credentials')) {
          _debug.log('AUTH', 'Attempting Super Admin Bootstrap (Auth + Profile)...');
          return await signUpWithEmail(
            email: email,
            password: password,
            name: 'Super Admin',
            initialRole: 'admin',
          );
        }
        rethrow;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<UserCredential?> signInWithGoogle({String? initialRole}) async {
    try {
      _isLoading = true;
      notifyListeners();
      UserCredential? userCredential;
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'prompt': 'select_account'});
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final dynamic googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          _isLoading = false;
          notifyListeners();
          return null;
        }
        final dynamic googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        userCredential = await _auth.signInWithCredential(credential);
      }
      final user = userCredential.user;
      if (user != null) {
        final existing = await _repository.getUser(user.uid);
        if (existing == null) {
          await _createInitialUserDoc(user, initialRole: initialRole);
        }
      }
      await fetchUserData();
      return userCredential;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _createInitialUserDoc(User user, {String? initialRole, String? nameOverride}) async {
    final bool isSuperAdmin = ['geo.elnajjar@gmail.com', 'admin@espy.com'].contains(user.email);
    final userModel = UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: nameOverride ?? user.displayName ?? 'New User',
      photoUrl: user.photoURL,
      role: isSuperAdmin ? UserRole.admin : UserRole.parse(initialRole),
      isActive: true,
      hasProfile: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _repository.upsertUser(userModel);
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      if (!kIsWeb) await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
      _userData = null;
    } catch (e) {
      _debug.log('AUTH', 'SignOut Error', data: e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
