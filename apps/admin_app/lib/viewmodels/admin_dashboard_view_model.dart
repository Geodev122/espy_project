import 'dart:async';
import 'package:flutter/foundation.dart';
import 'espy_repository.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  final Map<String, String> _stats = {
    'users': '0',
    'services': '0',
    'communityRequests': '0',
    'pendingOrders': '0',
  };
  bool _isLoading = true;
  bool _disposed = false;

  StreamSubscription? _statsSub;
  StreamSubscription? _ordersSub;

  AdminDashboardViewModel(this._repository) {
    _init();
  }

  Map<String, String> get stats => _stats;
  bool get isLoading => _isLoading;

  void _init() {
    try {
      _statsSub = _repository.getSystemStats().listen((data) {
        if (_disposed) return;
        _stats['users'] = data['users']?.toString() ?? _stats['users']!;
        _stats['services'] = data['services']?.toString() ?? _stats['services']!;
        _stats['communityRequests'] = data['communityRequests']?.toString() ?? _stats['communityRequests']!;
        _isLoading = false;
        notifyListeners();
      }, onError: (e) {
        debugPrint("Stats Subscription Error: $e");
        if (!_disposed) {
          _isLoading = false;
          notifyListeners();
        }
      });

      _ordersSub = _repository.listPendingOrders().listen((data) {
        if (_disposed) return;
        _stats['pendingOrders'] = data.length.toString();
        notifyListeners();
      }, onError: (e) {
        debugPrint("Orders Subscription Error: $e");
      });
    } catch (e) {
      debugPrint("Stats Init Error: $e");
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _statsSub?.cancel();
    _ordersSub?.cancel();
    super.dispose();
  }
}
