import 'dart:async';
import 'package:flutter/foundation.dart';
import 'espy_repository.dart';
import '../models/enums.dart';

class VerificationsViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<Map<String, dynamic>> _pendingProviders = [];
  bool _isLoading = true;
  StreamSubscription? _subscription;

  VerificationsViewModel(this._repository) {
    _init();
  }

  List<Map<String, dynamic>> get pendingProviders => _pendingProviders;
  bool get isLoading => _isLoading;

  void _init() {
    _subscription = _repository.listAllProviders().listen((providers) {
      _pendingProviders = providers.where((p) => 
        p['isProfileValidated'] == false || p['isApproved'] == false
      ).toList();
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> validateProfile(String id, String role) async {
    await _repository.validateProfile(id, UserRole.parse(role));
  }

  Future<void> approveSearch(String id, String role) async {
    await _repository.approveProfessional(id, true, UserRole.parse(role));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
