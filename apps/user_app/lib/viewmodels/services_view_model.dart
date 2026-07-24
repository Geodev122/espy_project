import 'dart:async';
import 'package:flutter/foundation.dart';
import './espy_repository.dart';
import './auth_service.dart';
import '../models/service_model.dart';

class ServicesViewModel extends ChangeNotifier {
  final EspyRepository _repository;
  final AuthService _authService;

  List<ServiceModel> _professionalServices = [];
  bool _isLoading = true;
  StreamSubscription? _servicesSub;

  ServicesViewModel(this._repository, this._authService) {
    if (_authService.user != null) {
      _loadServices();
    }
  }

  List<ServiceModel> get professionalServices => _professionalServices;
  bool get isLoading => _isLoading;

  void _loadServices() {
    _isLoading = true;
    notifyListeners();
    _servicesSub = _repository.listProfessionalServices(_authService.user!.uid).listen((data) {
      _professionalServices = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> toggleServiceSlot(String serviceId, bool allocate) async {
    await _repository.toggleServiceSlot(serviceId, allocate);
  }

  @override
  void dispose() {
    _servicesSub?.cancel();
    super.dispose();
  }
}
