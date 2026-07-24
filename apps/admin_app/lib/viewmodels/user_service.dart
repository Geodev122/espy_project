import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'espy_repository.dart';
import '../models/user_model.dart';
import '../models/enums.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EspyRepository _repository;

  UserModel? _profile;
  bool _loading = false;
  StreamSubscription? _profileSubscription;

  UserModel? get profile => _profile;
  bool get isLoading => _loading;
  String get userId => _auth.currentUser?.uid ?? '';

  UserService(this._repository) {
    _auth.authStateChanges().listen((user) {
      _profileSubscription?.cancel();
      if (user != null) {
        _subscribeToProfile(user.uid);
      } else {
        _profile = null;
        notifyListeners();
      }
    });
  }

  void _subscribeToProfile(String uid) {
    _loading = true;
    notifyListeners();

    _profileSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((snap) {
      if (snap.exists && snap.data() != null) {
        _profile = UserModel.fromMap(snap.data()!);
      } else {
        _profile = null;
      }
      _loading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint('Profile Subscription Error: $e');
      _loading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }

  Future<void> updateProfile(UserModel data) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _repository.updateUser(user.uid, data);
  }

  Future<void> syncVisitorData({String? name, String? whatsapp}) async {
    final user = _auth.currentUser;
    if (user == null || _profile == null) return;

    final updatedUser = UserModel(
      id: _profile!.id,
      email: _profile!.email,
      name: name ?? _profile!.name,
      whatsapp: whatsapp ?? _profile!.whatsapp,
      role: UserRole.visitor,
      photoUrl: _profile!.photoUrl,
      isActive: _profile!.isActive,
      hasProfile: _profile!.hasProfile,
      createdAt: _profile!.createdAt,
      updatedAt: DateTime.now(),
    );

    await _repository.updateUser(user.uid, updatedUser);
  }
}
