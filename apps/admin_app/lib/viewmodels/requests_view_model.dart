import 'dart:async';
import 'package:flutter/foundation.dart';
import './espy_repository.dart';
import './auth_service.dart';

class RequestsViewModel extends ChangeNotifier {
  final EspyRepository _repository;
  final AuthService _authService;

  List<Map<String, dynamic>> _requests = [];
  List<String> _favoriteIds = [];
  bool _isLoading = true;
  String _selectedSectorId = 'All';
  bool _newestFirst = true;

  StreamSubscription? _requestsSub;
  StreamSubscription? _favsSub;

  RequestsViewModel(this._repository, this._authService) {
    _init();
  }

  void _init() {
    if (_authService.user == null) return;
    
    _loadRequests();
    
    _favsSub = _repository.listFavoriteIds(_authService.user!.uid).listen((ids) {
      _favoriteIds = ids;
      notifyListeners();
    });
  }

  void _loadRequests() {
    _requestsSub?.cancel();
    _isLoading = true;
    notifyListeners();

    _requestsSub = _repository.listCommunityRequests(
      sectorId: _selectedSectorId,
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

  void setSection(String sectorId) {
    _selectedSectorId = sectorId;
    _loadRequests();
  }

  Future<void> favoriteRequest(String requestId, bool isFavorite) async {
    if (_authService.user == null) return;
    await _repository.toggleFavorite(_authService.user!.uid, requestId, isFavorite);
  }

  @override
  void dispose() {
    _requestsSub?.cancel();
    _favsSub?.cancel();
    super.dispose();
  }
}
