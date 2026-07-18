import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'espy_repository.dart';

class DirectoryViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<Map<String, dynamic>> _providers = [];
  List<Map<String, dynamic>> _filteredProviders = [];
  bool _isLoading = true;

  // Filters
  String? _selectedSectorId;
  String? _selectedCountryId;
  String? _selectedRole;
  double _searchRadiusKm = 10.0;
  bool _radiusFilterActive = false;
  LatLng? _userLocation;

  // Subscriptions
  StreamSubscription? _providersSubscription;

  DirectoryViewModel(this._repository) {
    _init();
  }

  void _init() {
    _providersSubscription = _repository.getAllProviders().listen((providers) {
      _providers = providers;
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    });
  }

  // Getters
  List<Map<String, dynamic>> get providers => _filteredProviders;
  bool get isLoading => _isLoading;
  String? get selectedSectorId => _selectedSectorId;
  String? get selectedCountryId => _selectedCountryId;
  String? get selectedRole => _selectedRole;
  double get searchRadiusKm => _searchRadiusKm;
  bool get radiusFilterActive => _radiusFilterActive;

  // Setters & Logic
  void setFilters({
    String? sectorId,
    String? countryId,
    String? role,
    double? radius,
    bool? radiusActive,
    LatLng? userLocation,
  }) {
    if (sectorId != null) _selectedSectorId = sectorId == 'ALL' ? null : sectorId;
    if (countryId != null) _selectedCountryId = countryId == 'ALL' ? null : countryId;
    if (role != null) _selectedRole = role == 'ALL' ? null : role;
    if (radius != null) _searchRadiusKm = radius;
    if (radiusActive != null) _radiusFilterActive = radiusActive;
    if (userLocation != null) _userLocation = userLocation;

    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProviders = _providers.where((p) {
      // Role Filter
      if (_selectedRole != null && p['role'] != _selectedRole) return false;

      // Sector Filter
      if (_selectedSectorId != null && p['sectorId'] != _selectedSectorId) return false;

      // Country Filter
      if (_selectedCountryId != null && 
          (p['countryId'] ?? p['country'] ?? 'LEBANON').toString().toUpperCase() != _selectedCountryId!.toUpperCase()) {
        return false;
      }

      // Radius Filter (Simple Haversine or approximation logic can be added here)
      // For now, mirroring the logic from MapExploreScreen
      if (_radiusFilterActive && _userLocation != null && _searchRadiusKm < 100) {
        final mainLoc = p['mainLocation'] as Map<String, dynamic>?;
        if (mainLoc != null && mainLoc['lat'] != null) {
          final pos = LatLng(mainLoc['lat'], mainLoc['lng']);
          final distance = const Distance().as(LengthUnit.Kilometer, _userLocation!, pos);
          if (distance > _searchRadiusKm) return false;
        } else {
          return false; // No location for radius filter
        }
      }

      return true;
    }).toList();
  }

  @override
  void dispose() {
    _providersSubscription?.cancel();
    super.dispose();
  }
}
