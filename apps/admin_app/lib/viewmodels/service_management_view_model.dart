import 'dart:async';
import 'package:flutter/foundation.dart';
import 'espy_repository.dart';

class ServiceManagementViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<Map<String, dynamic>> _listingQueue = [];
  List<Map<String, dynamic>> _requestQueue = [];
  List<Map<String, dynamic>> _templates = [];
  bool _isLoading = false;

  ServiceManagementViewModel(this._repository) {
    _loadAll();
  }

  List<Map<String, dynamic>> get listingQueue => _listingQueue;
  List<Map<String, dynamic>> get requestQueue => _requestQueue;
  List<Map<String, dynamic>> get templates => _templates;
  bool get isLoading => _isLoading;

  void _loadAll() {
    _isLoading = true;
    notifyListeners();

    _repository.listServiceModerationQueue().listen((data) {
      _listingQueue = data;
      notifyListeners();
    });

    _repository.listRequestModerationQueue().listen((data) {
      _requestQueue = data;
      notifyListeners();
    });

    _repository.listTemplates().listen((data) {
      _templates = data;
      notifyListeners();
    });

    _isLoading = false;
    notifyListeners();
  }

  Future<void> approveService(String id, {String? broadcastScope, Map<String, dynamic>? serviceData}) async {
    await _repository.moderateService(id, 'APPROVED');
    
    if (broadcastScope != null && serviceData != null && broadcastScope != 'NONE') {
      await _dispatchLocalizedBroadcast(serviceData, broadcastScope);
    }
  }

  Future<void> _dispatchLocalizedBroadcast(Map<String, dynamic> service, String scope) async {
    final title = "NEW SERVICE: ${service['titleEn']}";
    final message = "A new ${service['categoryName']} protocol is now active in your area.";
    
    // Geographical filters
    String? country;
    String? region;
    String? city;

    // Extraction logic... for now passing GLOBAL if scope is COUNTRY and country is null
    // Ideally serviceData should include its location IDs
    if (scope == 'COUNTRY') country = service['countryId'] ?? 'LEBANON';
    if (scope == 'REGION') region = service['regionId'];
    if (scope == 'CITY') city = service['cityId'];

    await _repository.createLocalizedBroadcast(
      title: title,
      message: message,
      country: country,
      region: region,
      city: city,
    );
  }

  Future<void> rejectService(String id, String reason) async {
    await _repository.moderateService(id, 'FLAGGED', reason: reason);
  }

  Future<void> approveRequest(String id) async {
    await _repository.moderateRequest(id, 'APPROVED');
  }

  Future<void> rejectRequest(String id, String reason) async {
    await _repository.moderateRequest(id, 'FLAGGED', reason: reason);
  }

  Future<void> updateTemplate({
    required String categoryId, 
    required List<String> visibleFields,
    String? accentColor,
    String? iconName,
  }) async {
    await _repository.upsertTemplate(categoryId, visibleFields, accentColor: accentColor, iconName: iconName);
  }
}
