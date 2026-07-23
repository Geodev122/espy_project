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

  Future<void> approveService(String id) async {
    await _repository.moderateService(id, 'APPROVED');
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

  Future<void> updateTemplate(String categoryId, List<String> visibleFields) async {
    await _repository.upsertTemplate(categoryId, visibleFields);
  }
}
