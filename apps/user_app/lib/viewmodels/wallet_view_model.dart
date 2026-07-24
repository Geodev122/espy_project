import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import './auth_service.dart';
import './espy_repository.dart';
import '../models/wallet_transaction.dart';
import '../models/resource_order.dart';
import '../models/enums.dart';

class WalletViewModel extends ChangeNotifier {
  final AuthService _authService;
  final EspyRepository _repository;

  List<WalletTransactionModel> _transactions = [];
  ResourceOrderModel? _activeOrder;
  bool _isLoadingTransactions = false;
  bool _isProcessing = false;

  WalletViewModel(this._authService, this._repository) {
    if (_authService.user != null) {
      _loadData();
    }
  }

  int get balance => _authService.userData?.walletBalance ?? 0;
  List<WalletTransactionModel> get transactions => _transactions;
  ResourceOrderModel? get activeOrder => _activeOrder;
  bool get isLoadingTransactions => _isLoadingTransactions;
  bool get isProcessing => _isProcessing;

  void _loadData() {
    _isLoadingTransactions = true;
    notifyListeners();

    _repository.listWalletTransactions(_authService.user!.uid).listen((data) {
      _transactions = data;
      _isLoadingTransactions = false;
      notifyListeners();
    });

    _repository.getActiveResourceOrder(_authService.user!.uid).listen((order) {
      _activeOrder = order;
      notifyListeners();
    });
  }

  int get daysUntilExpiry {
    final DateTime? expiry = _authService.userData?.rawData['visibilityExpiresAt'];
    if (expiry == null) return 0;
    final diff = expiry.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  Future<void> refreshBalance() async {
    await _authService.fetchUserData();
    notifyListeners();
  }

  Future<Map<String, dynamic>> redeemCode(String code) async {
    _isProcessing = true;
    notifyListeners();
    try {
      final result = await FirebaseFunctions.instanceFor(region: 'us-central1').httpsCallable('redeemRechargeCode').call({
        'userId': _authService.user!.uid,
        'code': code.trim(),
      });
      if (result.data != null && result.data['success'] == true) {
        await _authService.fetchUserData();
        return {'success': true, 'added': result.data['added']};
      }
      return {'success': false, 'error': 'Invalid code'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> spendTokens({required String itemId, required int cost}) async {
    _isProcessing = true;
    notifyListeners();
    try {
      final result = await _repository.spendTokens(
        userId: _authService.user!.uid,
        itemId: itemId,
        cost: cost,
        role: _authService.userData?.role ?? UserRole.professional,
      );
      if (result['success'] == true) {
        await _authService.fetchUserData();
        return {'success': true};
      }
      return {'success': false, 'error': 'Transaction failed'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
