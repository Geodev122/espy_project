import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/espy_repository.dart';
import '../services/auth_service.dart';

class RequestsViewModel extends ChangeNotifier {
  final EspyRepository _repository;
  final AuthService _authService;

  List<Map<String, dynamic>> _requests = [];
  List<String> _favoriteIds = [];
  bool _isLoading = true;
  String _selectedSectionId = 'All';
  bool _newestFirst = true;

  StreamSubscription? _requestsSub;
  StreamSubscription? _favsSub;

  RequestsViewModel(this._repository, this._authService) {
    _init();
  }

  void _init() {
    if (_authService.user == null) return;
    
    _loadRequests();
    
    _favsSub = _repository.getFavoriteIds(_authService.user!.uid).listen((ids) {
      _favoriteIds = ids;
      notifyListeners();
    });
  }

  void _loadRequests() {
    _requestsSub?.cancel();
    _isLoading = true;
    notifyListeners();

    _requestsSub = _repository.getCommunityRequests(
      sectionId: _selectedSectionId,
      newestFirst: _newestFirst,
    ).listen((data) {
      _requests = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  List<Map<String, dynamic>> get requests => _requests;
  List<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;
  bool get newestFirst => _newestFirst;

  void toggleSortOrder() {
    _newestFirst = !_newestFirst;
    _loadRequests();
  }

  void setSection(String sectionId) {
    _selectedSectionId = sectionId;
    _loadRequests();
  }

  Future<void> favoriteRequest(String requestId, bool isFavorite) async {
    if (_authService.user == null) return;
    await _repository.favoriteRequest(_authService.user!.uid, requestId, isFavorite);
  }

  @override
  void dispose() {
    _requestsSub?.cancel();
    _favsSub?.cancel();
    super.dispose();
  }
}
