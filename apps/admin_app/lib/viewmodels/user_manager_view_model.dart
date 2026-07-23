import 'dart:async';
import 'package:flutter/foundation.dart';
import 'espy_repository.dart';

class UserManagerViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<Map<String, dynamic>> _filteredUsers = [];
  bool _isLoading = true;
  StreamSubscription? _subscription;

  // Filter State
  String _searchQuery = "";
  String? _filterRole;
  String? _filterStatus;

  UserManagerViewModel(this._repository) {
    _init();
  }

  List<Map<String, dynamic>> get users => _filteredUsers;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get filterRole => _filterRole;
  String? get filterStatus => _filterStatus;

  void _init() {
    _refreshStream();
  }

  void _refreshStream() {
    _subscription?.cancel();
    
    // Map status string to flags for server-side filter if needed
    bool? hasProfile;
    bool? isActive;
    
    if (_filterStatus == 'PENDING') hasProfile = false;
    if (_filterStatus == 'ACTIVE') { hasProfile = true; } // isApproved handled client side or specialized query
    if (_filterStatus == 'SUSPENDED') isActive = false;

    _subscription = _repository.searchUsersAdmin(
      query: _searchQuery,
      role: _filterRole,
      hasProfile: hasProfile,
      isActive: isActive,
    ).listen((data) {
      _filteredUsers = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _refreshStream();
  }

  void updateFilters({String? role, String? status}) {
    _filterRole = role;
    _filterStatus = status;
    _isLoading = true;
    notifyListeners();
    _refreshStream();
  }

  Future<void> suspendUser(String id, bool suspend) async {
    await _repository.toggleUserActiveStatus(id, !suspend);
  }

  Future<void> verifyUser(String id, String role, bool approve) async {
    await _repository.verifyUserDocs(id, role, approve);
  }

  Future<Map<String, dynamic>> getAuditDetails(String id) async {
    return await _repository.getAuditDetails(id);
  }

  Future<void> adminUpdateUser(String id, Map<String, dynamic> data) async {
    await _repository.adminUpdateUser(id, data);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
