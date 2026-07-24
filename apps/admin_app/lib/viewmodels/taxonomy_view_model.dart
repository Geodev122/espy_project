import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'espy_repository.dart';
import '../models/sector_model.dart';
import '../models/category_model.dart';
import '../models/country_model.dart';
import '../models/region_model.dart';
import '../models/city_model.dart';

class TaxonomyViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<SectorModel> _sectors = [];
  List<CategoryModel> _categories = [];
  List<CountryModel> _countries = [];
  List<RegionModel> _regions = [];
  List<CityModel> _cities = [];
  
  Map<String, List<Map<String, dynamic>>> _tags = {};

  bool _isLoading = true;
  StreamSubscription? _sectorSub;
  StreamSubscription? _countrySub;

  TaxonomyViewModel(this._repository) {
    _init();
  }

  List<SectorModel> get sectors => _sectors;
  List<CategoryModel> get categories => _categories;
  List<CountryModel> get countries => _countries;
  List<RegionModel> get regions => _regions;
  List<CityModel> get cities => _cities;
  Map<String, List<Map<String, dynamic>>> get tags => _tags;
  bool get isLoading => _isLoading;

  void _init() {
    _sectorSub = _repository.listSectors().listen((data) {
      _sectors = data;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint("Error listening to sectors: $e");
      _isLoading = false;
      notifyListeners();
    });

    _countrySub = _repository.listCountries().listen((data) {
      _countries = data;
      notifyListeners();
    }, onError: (e) {
      debugPrint("Error listening to countries: $e");
    });

    _loadTags();
  }

  Future<void> _loadTags() async {
    _tags = await _repository.listMetadataTags();
    notifyListeners();
  }

  // --- Geography Hierarchy ---

  String slugify(String text) {
    return text.toLowerCase().trim()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  String getGeographyCsvTemplate() {
    return "Type,ParentName,NameEn,NameAr,Extra1,Extra2\n"
           "COUNTRY,,Lebanon,لبنان,LB,🇱🇧\n"
           "REGION,Lebanon,Beirut,بيروت,BE,\n"
           "CITY,Beirut,Ashrafieh,الأشرفية,33.88,35.51";
  }

  Future<void> importHierarchicalXlsx(List<int> bytes) async {
    try {
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel.tables.values.first;
      
      final List<List<dynamic>> rows = [];
      for (var row in sheet.rows) {
        rows.add(row.map((cell) => cell?.value?.toString() ?? '').toList());
      }
      
      if (rows.isEmpty) return;
      
      final content = rows.skip(1).map((r) => r.join(',')).join('\n');
      await importHierarchicalCsv(content);
    } catch (e) {
      debugPrint("XLSX Import Error: $e");
      rethrow;
    }
  }

  Future<void> importHierarchicalCsv(String csvContent) async {
    final lines = csvContent.split('\n');
    final Map<String, String> nameToId = {};
    int count = 0;
    
    try {
      // 1. Countries
      for (var line in lines) {
        final parts = line.split(',');
        if (parts.length < 4 || parts[0].toUpperCase() != 'COUNTRY') continue;
        
        final nameEn = parts[2].trim();
        final id = slugify(nameEn);
        if (id.isEmpty) continue;

        await upsertCountry(CountryModel(
          id: id,
          nameEn: nameEn,
          nameAr: parts[3].trim(),
          isoCode: parts.length > 4 ? parts[4].trim() : id.toUpperCase(),
          flagEmoji: parts.length > 5 ? parts[5].trim() : null,
        ));
        nameToId[nameEn.toLowerCase()] = id;
        count++;
      }

      // 2. Regions
      for (var line in lines) {
        final parts = line.split(',');
        if (parts.length < 4 || parts[0].toUpperCase() != 'REGION') continue;

        final parentName = parts[1].trim().toLowerCase();
        final nameEn = parts[2].trim();
        final parentId = nameToId[parentName];
        if (parentId == null) continue;

        final id = "$parentId-${slugify(nameEn)}";
        await upsertRegion(RegionModel(
          id: id,
          countryId: parentId,
          nameEn: nameEn,
          nameAr: parts[3].trim(),
          regionCode: parts.length > 4 ? parts[4].trim() : null,
        ));
        nameToId[nameEn.toLowerCase()] = id;
        count++;
      }

      // 3. Cities
      for (var line in lines) {
        final parts = line.split(',');
        if (parts.length < 4 || parts[0].toUpperCase() != 'CITY') continue;

        final parentName = parts[1].trim().toLowerCase();
        final nameEn = parts[2].trim();
        final parentId = nameToId[parentName];
        if (parentId == null) continue;

        final id = "$parentId-${slugify(nameEn)}";
        await upsertCity(CityModel(
          id: id,
          regionId: parentId,
          nameEn: nameEn,
          nameAr: parts[3].trim(),
          lat: parts.length > 4 ? double.tryParse(parts[4].trim()) : null,
          lng: parts.length > 5 ? double.tryParse(parts[5].trim()) : null,
        ));
        count++;
      }
      
      debugPrint("Imported $count entities from protocol");
      _init(); 
    } catch (e) {
      debugPrint("Hierarchical Import Error: $e");
      rethrow;
    }
  }

  Future<void> importFullTaxonomyJson(String jsonContent) async {
    try {
      final List<dynamic> data = jsonDecode(jsonContent);
      for (var countryMap in data) {
        // 1. Country
        final String countryId = countryMap['id'];
        await upsertCountry(CountryModel(
          id: countryId,
          nameEn: countryMap['nameEn'],
          nameAr: countryMap['nameAr'],
          isoCode: countryMap['isoCode'] ?? countryId,
          flagEmoji: countryMap['flagEmoji'],
          currency: countryMap['currency'],
        ));

        // 2. Regions
        final List<dynamic>? regions = countryMap['regions'];
        if (regions != null) {
          for (var regionMap in regions) {
            final String regionId = regionMap['id'];
            await upsertRegion(RegionModel(
              id: regionId,
              countryId: countryId,
              nameEn: regionMap['nameEn'],
              nameAr: regionMap['nameAr'],
              regionCode: regionMap['regionCode'],
            ));

            // 3. Cities
            final List<dynamic>? cities = regionMap['cities'];
            if (cities != null) {
              for (var cityMap in cities) {
                await upsertCity(CityModel(
                  id: cityMap['id'],
                  regionId: regionId,
                  nameEn: cityMap['nameEn'],
                  nameAr: cityMap['nameAr'],
                  lat: cityMap['lat'] != null ? double.tryParse(cityMap['lat'].toString()) : null,
                  lng: cityMap['lng'] != null ? double.tryParse(cityMap['lng'].toString()) : null,
                ));
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
        
        await upsertRegion(RegionModel(
          id: id,
          countryId: countryId,
          nameEn: parts[1].trim(),
          nameAr: parts.length > 2 ? parts[2].trim() : parts[1].trim(),
          regionCode: parts.length > 3 ? parts[3].trim().toUpperCase() : null,
        ));
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

        await upsertCity(CityModel(
          id: id,
          regionId: regionId,
          nameEn: parts[1].trim(),
          nameAr: parts.length > 2 ? parts[2].trim() : parts[1].trim(),
          lat: parts.length > 3 ? double.tryParse(parts[3]) : null,
          lng: parts.length > 4 ? double.tryParse(parts[4]) : null,
        ));
      }
    }
    loadCities(regionId);
  }

  final Map<String, List<RegionModel>> _regionCache = {};
  final Map<String, List<CityModel>> _cityCache = {};

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

  Future<void> upsertCountry(CountryModel country) async {
    await _repository.upsertCountry(country);
  }

  Future<void> upsertRegion(RegionModel region) async {
    await _repository.upsertRegion(region);
    loadRegions(region.countryId);
  }

  Future<void> upsertCity(CityModel city) async {
    await _repository.upsertCity(city);
    loadCities(city.regionId);
  }

  // --- Taxonomy & Branding ---

  Future<void> updateSectorBranding(String id, SectorModel sector) async {
    await _repository.updateSectorBranding(id, sector);
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _repository.updateCategory(category);
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
