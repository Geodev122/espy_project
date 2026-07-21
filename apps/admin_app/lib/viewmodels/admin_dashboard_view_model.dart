import 'dart:async';
import 'package:flutter/foundation.dart';
import 'espy_repository.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  Map<String, dynamic> _stats = {
    'users': '0',
    'services': '0',
    'communityRequests': '0',
  };
  bool _isLoading = true;

  StreamSubscription? _statsSub;

  AdminDashboardViewModel(this._repository) {
    _init();
  }

  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;

  void _init() {
    _statsSub = _repository.getSystemStats().listen((data) {
      _stats = {
        'users': data['users']?.toString() ?? '0',
        'services': data['services']?.toString() ?? '0',
        'communityRequests': data['communityRequests']?.toString() ?? '0',
      };
      _isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _statsSub?.cancel();
    super.dispose();
  }
}
