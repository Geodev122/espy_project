import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:espy_core/espy_core.dart';

class ElementPricingViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<Map<String, dynamic>> _pricings = [];
  bool _isLoading = false;
  StreamSubscription? _pricingSub;

  ElementPricingViewModel(this._repository);

  List<Map<String, dynamic>> get pricings => _pricings;
  bool get isLoading => _isLoading;

  void listenToElementPricing() {
    _isLoading = true;
    notifyListeners();

    _pricingSub?.cancel();
    _pricingSub = _repository.listElementPricing().listen((data) {
      _pricings = data;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint("Error listening to element pricing: $e");
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> updatePricing(String id, int tokenCost, {int? validityDays}) async {
    try {
      await _repository.updateElementPricing(id, tokenCost, validityDays: validityDays);
    } catch (e) {
      debugPrint("Error updating element pricing: $e");
      rethrow;
    }
  }

  @override
  void dispose() {
    _pricingSub?.cancel();
    super.dispose();
  }
}
