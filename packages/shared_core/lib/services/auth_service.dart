import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'platform/google_login_helper.dart';
import '../models/user_model.dart';
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

  User? get user => _user;
  UserModel? get userData => _userData;
  bool get isLoading => _isLoading;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  AuthService(this._repository) {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    _init(); 
  }

  Future<void> _init() async {
    if (kIsWeb) {
      try {
        final credential = await _auth.getRedirectResult();
        final user = credential.user;
        if (user != null) {
          final existing = await _repository.getUser(user.uid);
          if (existing == null) {
            final prefs = await SharedPreferences.getInstance();
            final initialRole = prefs.getString('pending_initial_role');
            await _createInitialUserDoc(user, initialRole: initialRole);
            await prefs.remove('pending_initial_role');
          }
          await fetchUserData();
        }
      } catch (e) {
        _debug.log('AUTH', 'Redirect Error', data: e);
      }
    }
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _debug.log('AUTH', 'State: ${user?.email ?? 'Logged Out'}');
    if (_user?.uid == user?.uid && _userData != null) return;
    
    _user = user;
    if (user != null) {
      await fetchUserData();
      await _repository.updateUser(user.uid, {
        'last_active': FieldValue.serverTimestamp(),
        'last_login': FieldValue.serverTimestamp(),
      });
      
      _recordAdminLog('USER_LOGIN', user.uid, 'user', 'Logged in');
    } else {
      _userData = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserData() async {
    final uid = _user?.uid;
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

    // Fallback to token claim if available
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
             await _functions.httpsCallable('redeemRechargeCode').call({
               'userId': user.uid,
               'code': redemptionCode,
             });
          } catch (e) {
            _debug.log('AUTH', 'Redemption failed', data: e);
          }
        }
      }
      return credential;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      _debug.log('AUTH', 'SignUp Error', data: e);
      rethrow;
    }
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      _debug.log('AUTH', 'SignIn Error', data: e);
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
        final userDoc = await _db.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _createInitialUserDoc(user, initialRole: initialRole);
        }
      }

      await fetchUserData();
      return userCredential;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      _debug.log('AUTH', 'Google Error', data: e);
      rethrow;
    }
  }

  Future<void> _createInitialUserDoc(User user, {String? initialRole, String? nameOverride}) async {
    final userData = {
      'uid': user.uid,
      'email': user.email,
      'name': nameOverride ?? user.displayName,
      'photoUrl': user.photoURL,
      'role': initialRole ?? 'pending',
      'source': kIsWeb ? 'pwa' : 'android',
      'isActive': true, 
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'hasProfile': false,
    };

    await _repository.updateUser(user.uid, userData);
    _debug.log('AUTH', 'Initial doc created via repo for ${user.uid}');

    // --- Phase 1 Migration: Dual-Write ---
    await _syncToDataConnect(user.uid, userData);
  }

  Future<void> _syncToDataConnect(String uid, Map<String, dynamic> data) async {
    try {
      _debug.log('MIGRATION', 'Shadow-writing to DataConnect: $uid');
      // Once DataConnect SDK is generated, call:
      // await db.createUser(CreateUserRequest(id: uid, email: data['email'], name: data['name'], role: data['role']));
    } catch (e) {
      _debug.log('MIGRATION', 'Shadow-write failed (non-blocking)', data: e);
    }
  }

  Future<void> _recordAdminLog(String action, String entityId, String entityType, String details) async {
    try {
      // Admin logs logic could also be in repo
    } catch (_) {}
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
