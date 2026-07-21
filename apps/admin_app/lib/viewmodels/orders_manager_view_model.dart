import 'dart:async';
import 'package:flutter/foundation.dart';
import 'espy_repository.dart';

class OrdersManagerViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<Map<String, dynamic>> _pendingOrders = [];
  bool _isLoading = true;
  StreamSubscription? _subscription;

  OrdersManagerViewModel(this._repository) {
    _init();
  }

  List<Map<String, dynamic>> get pendingOrders => _pendingOrders;
  bool get isLoading => _isLoading;

  void _init() {
    _subscription = _repository.listPendingOrders().listen((orders) {
      _pendingOrders = orders;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> approveOrder(String orderId) async {
    await _repository.approveResourceOrder(orderId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
