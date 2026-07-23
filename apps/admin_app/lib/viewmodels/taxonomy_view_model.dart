import 'dart:async';
import 'package:flutter/foundation.dart';
import 'espy_repository.dart';

class TaxonomyViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<Map<String, dynamic>> _sectors = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _countries = [];
  List<Map<String, dynamic>> _regions = [];
  List<Map<String, dynamic>> _cities = [];
  
  Map<String, List<Map<String, dynamic>>> _tags = {};

  bool _isLoading = true;
  StreamSubscription? _sectorSub;
  StreamSubscription? _countrySub;

  TaxonomyViewModel(this._repository) {
    _init();
  }

  List<Map<String, dynamic>> get sectors => _sectors;
  List<Map<String, dynamic>> get categories => _categories;
  List<Map<String, dynamic>> get countries => _countries;
  List<Map<String, dynamic>> get regions => _regions;
  List<Map<String, dynamic>> get cities => _cities;
  Map<String, List<Map<String, dynamic>>> get tags => _tags;
  bool get isLoading => _isLoading;

  void _init() {
    _sectorSub = _repository.listSectors().listen((data) {
      _sectors = data;
      _isLoading = false;
      notifyListeners();
    });

    _countrySub = _repository.listCountries().listen((data) {
      _countries = data;
      notifyListeners();
    });

    _loadTags();
  }

  Future<void> _loadTags() async {
    _tags = await _repository.listMetadataTags();
    notifyListeners();
  }

  // --- Geography Hierarchy ---

  Future<void> importCitiesCsv(String regionId, String csvContent) async {
    final lines = csvContent.split('\n');
    for (var line in lines) {
      if (line.isEmpty) continue;
      final parts = line.split(',');
      if (parts.length >= 2) {
        await upsertCity({
          'regionId': regionId,
          'nameEn': parts[0].trim(),
          'nameAr': parts[1].trim(),
          'lat': parts.length > 2 ? double.tryParse(parts[2]) : null,
          'lng': parts.length > 3 ? double.tryParse(parts[3]) : null,
        });
      }
    }
    loadCities(regionId);
  }

  final Map<String, List<Map<String, dynamic>>> _regionCache = {};
  final Map<String, List<Map<String, dynamic>>> _cityCache = {};

  Future<void> loadRegions(String countryId) async {
    if (_regionCache.containsKey(countryId)) {
      _regions = _regionCache[countryId]!;
      _cities = [];
      notifyListeners();
      return;
    }
    
    _repository.listRegions(countryId).first.then((data) {
      _regionCache[countryId] = data;
      _regions = data;
      _cities = [];
      notifyListeners();
    });
  }

  Future<void> loadCities(String regionId) async {
    if (_cityCache.containsKey(regionId)) {
      _cities = _cityCache[regionId]!;
      notifyListeners();
      return;
    }

    _repository.listCities(regionId).first.then((data) {
      _cityCache[regionId] = data;
      _cities = data;
      notifyListeners();
    });
  }

  Future<void> upsertCountry(Map<String, dynamic> data) async {
    await _repository.upsertCountry(data);
  }

  Future<void> upsertRegion(Map<String, dynamic> data) async {
    await _repository.upsertRegion(data);
    if (data['countryId'] != null) loadRegions(data['countryId']);
  }

  Future<void> upsertCity(Map<String, dynamic> data) async {
    await _repository.upsertCity(data);
    if (data['regionId'] != null) loadCities(data['regionId']);
  }

  // --- Taxonomy & Branding ---

  Future<void> updateSectorBranding(String id, Map<String, dynamic> data) async {
    await _repository.updateSectorBranding(id, data);
  }

  Future<void> upsertTag(String type, Map<String, dynamic> data) async {
    switch (type) {
      case 'service': await _repository.upsertServiceTag(data); break;
      case 'price': await _repository.upsertPriceTag(data); break;
      case 'pin': await _repository.upsertPinCategory(data); break;
      case 'presence': await _repository.upsertPresenceTag(data); break;
    }
    _loadTags();
  }

  @override
  void dispose() {
    _sectorSub?.cancel();
    _countrySub?.cancel();
    super.dispose();
  }
}
