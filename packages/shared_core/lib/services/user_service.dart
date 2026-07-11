import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'espy_repository.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EspyRepository _repository;

  Map<String, dynamic>? _profile;
  bool _loading = false;
  StreamSubscription? _profileSubscription;

  Map<String, dynamic>? get profile => _profile;
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
      if (snap.exists) {
        _profile = snap.data();
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

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _repository.updateUser(user.uid, data);
  }

  // Refactored to separate logic into repo if possible, but keep simple for now
  Future<void> syncVisitorData({String? name, String? whatsapp}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _repository.updateUser(user.uid, {
      if (name != null) 'name': name,
      if (whatsapp != null) 'whatsapp': whatsapp,
      'role': 'visitor',
      'source': 'android',
    });
  }
}
