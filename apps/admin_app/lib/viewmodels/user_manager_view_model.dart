import 'dart:async';
import 'package:flutter/foundation.dart';
import 'espy_repository.dart';

class UserManagerViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  StreamSubscription? _subscription;

  UserManagerViewModel(this._repository) {
    _init();
  }

  List<Map<String, dynamic>> get users => _users;
  bool get isLoading => _isLoading;

  void _init() {
    _subscription = _repository.listAllUsers().listen((data) {
      _users = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> suspendUser(String id, bool suspend) async {
    await _repository.toggleUserActiveStatus(id, !suspend);
  }

  Future<void> verifyUser(String id, String role, bool approve) async {
    await _repository.verifyUserDocs(id, role, approve);
  }

  Future<Map<String, dynamic>> getUserDetails(String id) async {
    return await _repository.getUserDetails(id);
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _repository.adminUpdateUser(id, data);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
