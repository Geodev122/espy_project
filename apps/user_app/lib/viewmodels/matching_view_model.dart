import 'dart:async';
import 'package:flutter/foundation.dart';
import './espy_repository.dart';
import './auth_service.dart';

class MatchingViewModel extends ChangeNotifier {
  final EspyRepository _repository;
  final AuthService _authService;

  List<Map<String, dynamic>> _allServices = [];
  List<Map<String, dynamic>> _filteredServices = [];
  List<String> _favoriteIds = [];
  List<String> _contactedIds = [];
  bool _isLoading = true;

  String? _filterSectorId;
  String _filterCountry = 'ALL';
  bool _newestFirst = true;

  StreamSubscription? _servicesSub;
  StreamSubscription? _favsSub;
  StreamSubscription? _contactedSub;

  MatchingViewModel(this._repository, this._authService) {
    _init();
  }

  void _init() {
    if (_authService.user == null) return;
    final userId = _authService.user!.uid;

    _servicesSub = _repository.listActiveServices().listen((services) {
      _allServices = services;
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    });

    _favsSub = _repository.listFavoriteIds(userId).listen((ids) {
      _favoriteIds = ids;
      notifyListeners();
    });

    _contactedSub = _repository.listContactedIds(userId).listen((ids) {
      _contactedIds = ids;
      notifyListeners();
    });
  }

  List<Map<String, dynamic>> get services => _filteredServices;
  List<String> get favoriteIds => _favoriteIds;
  List<String> get contactedIds => _contactedIds;
  bool get isLoading => _isLoading;
  bool get newestFirst => _newestFirst;
  String get filterCountry => _filterCountry;
  String? get filterSectorId => _filterSectorId;

  void toggleSortOrder() {
    _newestFirst = !_newestFirst;
    _applyFilters();
    notifyListeners();
  }

  void setFilters({String? sectorId, String? country}) {
    if (sectorId != null) _filterSectorId = sectorId == 'ALL' ? null : sectorId;
    if (country != null) _filterCountry = country;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredServices = _allServices.where((s) {
      if (_filterSectorId != null && s['sectorId'] != _filterSectorId) return false;
      if (_filterCountry != 'ALL' && (s['countryId'] ?? s['country'] ?? 'LEBANON').toString().toUpperCase() != _filterCountry.toUpperCase()) return false;
      return true;
    }).toList();

    _filteredServices.sort((a, b) {
      final dynamic da = a['createdAt'];
      final dynamic db = b['createdAt'];
      if (da == null || db == null) return 0;
      return _newestFirst ? db.compareTo(da) : da.compareTo(db);
    });
  }

  Future<void> recordInteraction(String targetId, String type) async {
    if (_authService.user == null) return;
    await _repository.recordInteraction(userId: _authService.user!.uid, targetId: targetId, type: type);
  }

  Future<void> toggleFavorite(String targetId, bool isFavorite) async {
    if (_authService.user == null) return;
    await _repository.toggleFavorite(_authService.user!.uid, targetId, isFavorite);
  }

  @override
  void dispose() {
    _servicesSub?.cancel();
    _favsSub?.cancel();
    _contactedSub?.cancel();
    super.dispose();
  }
}
