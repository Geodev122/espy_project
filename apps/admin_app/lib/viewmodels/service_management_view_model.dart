import 'dart:async';
import 'package:flutter/foundation.dart';
import 'espy_repository.dart';
import '../models/service_model.dart';
import '../models/service_request.dart';
import '../models/enums.dart';

class ServiceManagementViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<ServiceModel> _listingQueue = [];
  List<ServiceRequestModel> _requestQueue = [];
  List<Map<String, dynamic>> _templates = [];
  bool _isLoading = false;
  bool _disposed = false;

  StreamSubscription? _listingsSub;
  StreamSubscription? _requestsSub;
  StreamSubscription? _templatesSub;

  ServiceManagementViewModel(this._repository) {
    _loadAll();
  }

  List<ServiceModel> get listingQueue => _listingQueue;
  List<ServiceRequestModel> get requestQueue => _requestQueue;
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

  Future<void> approveService(String id, {String? broadcastScope, ServiceModel? service}) async {
    try {
      await _repository.moderateService(id, ModerationStatus.approved);
      if (broadcastScope != null && service != null && broadcastScope != 'NONE') {
        await _dispatchLocalizedBroadcast(service, broadcastScope);
      }
    } catch (e) {
      debugPrint("Approve Service Error: $e");
    }
  }

  Future<void> _dispatchLocalizedBroadcast(ServiceModel service, String scope) async {
    final title = "NEW SERVICE: ${service.titleEn}";
    final message = "A new protocol is now active in your area.";
    
    String? country;
    String? region;
    String? city;

    if (scope == 'COUNTRY') country = 'LEBANON';
    if (scope == 'REGION') region = service.sectorId; // Fallback
    if (scope == 'CITY') city = service.categoryId; // Fallback

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
      await _repository.moderateService(id, ModerationStatus.flagged, reason: reason);
    } catch (e) {
      debugPrint("Reject Service Error: $e");
    }
  }

  Future<void> approveRequest(String id) async {
    try {
      await _repository.moderateRequest(id, ModerationStatus.approved);
    } catch (e) {
      debugPrint("Approve Request Error: $e");
    }
  }

  Future<void> rejectRequest(String id, String reason) async {
    try {
      await _repository.moderateRequest(id, ModerationStatus.flagged, reason: reason);
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
