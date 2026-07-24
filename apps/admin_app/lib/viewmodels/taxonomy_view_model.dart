import 'dart:async';
import 'dart:convert';
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
    }, onError: (e) {
      print("Error listening to sectors: $e");
      _isLoading = false;
      notifyListeners();
    });

    _countrySub = _repository.listCountries().listen((data) {
      _countries = data;
      notifyListeners();
    }, onError: (e) {
      print("Error listening to countries: $e");
    });

    _loadTags();
  }

  Future<void> _loadTags() async {
    _tags = await _repository.listMetadataTags();
    notifyListeners();
  }

  // --- Geography Hierarchy ---

  Future<void> importHierarchicalCsv(String csvContent) async {
    final lines = csvContent.split('\n');
    int count = 0;
    try {
      // 1. First Pass: Countries
      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split(',');
        if (parts[0].toUpperCase() == 'COUNTRY' && parts.length >= 5) {
          await upsertCountry({
            'id': parts[1].trim(),
            'nameEn': parts[3].trim(),
            'nameAr': parts[4].trim(),
            'isoCode': parts.length > 5 ? parts[5].trim() : parts[1].trim(),
            'flagEmoji': parts.length > 6 ? parts[6].trim() : null,
          });
          count++;
        }
      }

      // 2. Second Pass: Regions
      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split(',');
        if (parts[0].toUpperCase() == 'REGION' && parts.length >= 5) {
          await upsertRegion({
            'id': parts[1].trim(),
            'countryId': parts[2].trim(),
            'nameEn': parts[3].trim(),
            'nameAr': parts[4].trim(),
            'regionCode': parts.length > 5 ? parts[5].trim() : null,
          });
          count++;
        }
      }

      // 3. Third Pass: Cities
      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        final parts = line.split(',');
        if (parts[0].toUpperCase() == 'CITY' && parts.length >= 5) {
          await upsertCity({
            'id': parts[1].trim(),
            'regionId': parts[2].trim(),
            'nameEn': parts[3].trim(),
            'nameAr': parts[4].trim(),
            'lat': parts.length > 5 ? double.tryParse(parts[5].trim()) : null,
            'lng': parts.length > 6 ? double.tryParse(parts[6].trim()) : null,
          });
          count++;
        }
      }
      
      debugPrint("Imported $count entities from CSV");
      _init(); 
    } catch (e) {
      debugPrint("Hierarchical CSV Import Error: $e");
      rethrow;
    }
  }

  Future<void> importFullTaxonomyJson(String jsonContent) async {
    try {
      final List<dynamic> data = jsonDecode(jsonContent);
      for (var countryMap in data) {
        // 1. Country
        final String countryId = countryMap['id'];
        await upsertCountry({
          'id': countryId,
          'nameEn': countryMap['nameEn'],
          'nameAr': countryMap['nameAr'],
          'isoCode': countryMap['isoCode'] ?? countryId,
          'flagEmoji': countryMap['flagEmoji'],
          'currency': countryMap['currency'],
        });

        // 2. Regions
        final List<dynamic>? regions = countryMap['regions'];
        if (regions != null) {
          for (var regionMap in regions) {
            final String regionId = regionMap['id'];
            await upsertRegion({
              'id': regionId,
              'countryId': countryId,
              'nameEn': regionMap['nameEn'],
              'nameAr': regionMap['nameAr'],
              'regionCode': regionMap['regionCode'],
            });

            // 3. Cities
            final List<dynamic>? cities = regionMap['cities'];
            if (cities != null) {
              for (var cityMap in cities) {
                await upsertCity({
                  'id': cityMap['id'],
                  'regionId': regionId,
                  'nameEn': cityMap['nameEn'],
                  'nameAr': cityMap['nameAr'],
                  'lat': cityMap['lat'] != null ? double.tryParse(cityMap['lat'].toString()) : null,
                  'lng': cityMap['lng'] != null ? double.tryParse(cityMap['lng'].toString()) : null,
                });
              }
            }
          }
        }
      }
      _init(); // Reload top level
    } catch (e) {
      debugPrint("Import Full Taxonomy Error: $e");
      rethrow;
    }
  }

  Future<void> importRegionsCsv(String countryId, String csvContent) async {
    final lines = csvContent.split('\n');
    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      final parts = line.split(',');
      if (parts.length >= 2) {
        final id = parts[0].trim().toLowerCase().replaceAll(' ', '-');
        if (id.isEmpty) continue;
        
        await upsertRegion({
          'id': id,
          'countryId': countryId,
          'nameEn': parts[1].trim(),
          'nameAr': parts.length > 2 ? parts[2].trim() : parts[1].trim(),
          'regionCode': parts.length > 3 ? parts[3].trim().toUpperCase() : null,
        });
      }
    }
    loadRegions(countryId);
  }

  Future<void> importCitiesCsv(String regionId, String csvContent) async {
    final lines = csvContent.split('\n');
    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      final parts = line.split(',');
      if (parts.length >= 2) {
        final id = parts[0].trim().toLowerCase().replaceAll(' ', '-');
        if (id.isEmpty) continue;

        await upsertCity({
          'id': id,
          'regionId': regionId,
          'nameEn': parts[1].trim(),
          'nameAr': parts.length > 2 ? parts[2].trim() : parts[1].trim(),
          'lat': parts.length > 3 ? double.tryParse(parts[3]) : null,
          'lng': parts.length > 4 ? double.tryParse(parts[4]) : null,
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
