import 'dart:async';
import 'package:flutter/foundation.dart';
import 'espy_repository.dart';

class ServiceManagementViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<Map<String, dynamic>> _listingQueue = [];
  List<Map<String, dynamic>> _requestQueue = [];
  List<Map<String, dynamic>> _templates = [];
  bool _isLoading = false;
  bool _disposed = false;

  StreamSubscription? _listingsSub;
  StreamSubscription? _requestsSub;
  StreamSubscription? _templatesSub;

  ServiceManagementViewModel(this._repository) {
    _loadAll();
  }

  List<Map<String, dynamic>> get listingQueue => _listingQueue;
  List<Map<String, dynamic>> get requestQueue => _requestQueue;
  List<Map<String, dynamic>> get templates => _templates;
  bool get isLoading => _isLoading;

  void _loadAll() {
    _isLoading = true;
    _safeNotify();

    _listingsSub = _repository.listServiceModerationQueue().listen((data) {
      _listingQueue = data;
      _safeNotify();
    }, onError: (e) => debugPrint("Listings Queue Error: $e"));

    _requestsSub = _repository.listRequestModerationQueue().listen((data) {
      _requestQueue = data;
      _safeNotify();
    }, onError: (e) => debugPrint("Requests Queue Error: $e"));

    _templatesSub = _repository.listTemplates().listen((data) {
      _templates = data;
      _safeNotify();
    }, onError: (e) => debugPrint("Templates Load Error: $e"));

    _isLoading = false;
    _safeNotify();
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> approveService(String id, {String? broadcastScope, Map<String, dynamic>? serviceData}) async {
    try {
      await _repository.moderateService(id, 'APPROVED');
      if (broadcastScope != null && serviceData != null && broadcastScope != 'NONE') {
        await _dispatchLocalizedBroadcast(serviceData, broadcastScope);
      }
    } catch (e) {
      debugPrint("Approve Service Error: $e");
    }
  }

  Future<void> _dispatchLocalizedBroadcast(Map<String, dynamic> service, String scope) async {
    final title = "NEW SERVICE: ${service['titleEn']}";
    final message = "A new ${service['categoryName'] ?? 'Care'} protocol is now active in your area.";
    
    String? country;
    String? region;
    String? city;

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
    try {
      await _repository.moderateService(id, 'FLAGGED', reason: reason);
    } catch (e) {
      debugPrint("Reject Service Error: $e");
    }
  }

  Future<void> approveRequest(String id) async {
    try {
      await _repository.moderateRequest(id, 'APPROVED');
    } catch (e) {
      debugPrint("Approve Request Error: $e");
    }
  }

  Future<void> rejectRequest(String id, String reason) async {
    try {
      await _repository.moderateRequest(id, 'FLAGGED', reason: reason);
    } catch (e) {
      debugPrint("Reject Request Error: $e");
    }
  }

  Future<void> updateTemplate({
    required String categoryId, 
    required List<String> visibleFields,
    String? accentColor,
    String? iconName,
  }) async {
    try {
      await _repository.upsertTemplate(
        categoryId, 
        visibleFields, 
        accentColor: accentColor, 
        iconName: iconName
      );
    } catch (e) {
      debugPrint("Update Template Error: $e");
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _listingsSub?.cancel();
    _requestsSub?.cancel();
    _templatesSub?.cancel();
    super.dispose();
  }
}
