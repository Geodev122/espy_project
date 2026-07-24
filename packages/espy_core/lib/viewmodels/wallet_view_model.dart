import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../services/auth_service.dart';
import 'espy_repository.dart';
import '../models/wallet_transaction.dart';
import '../models/resource_order.dart';
import '../models/enums.dart';

class WalletViewModel extends ChangeNotifier {
  final AuthService _authService;
  final EspyRepository _repository;

  List<WalletTransactionModel> _transactions = [];
  List<Map<String, dynamic>> _tokenPackages = [];
  List<Map<String, dynamic>> _elementPricing = [];
  ResourceOrderModel? _activeOrder;
  bool _isLoadingTransactions = false;
  bool _isProcessing = false;
  int? _optimisticBalance;

  WalletViewModel(this._authService, this._repository) {
    if (_authService.user != null) {
      _loadData();
      _loadPackages();
      _loadPricing();
    }
  }

  int get balance => _optimisticBalance ?? _authService.userData?.walletBalance ?? 0;
  List<WalletTransactionModel> get transactions => _transactions;
  List<Map<String, dynamic>> get tokenPackages => _tokenPackages;
  List<Map<String, dynamic>> get elementPricing => _elementPricing;
  ResourceOrderModel? get activeOrder => _activeOrder;
  bool get isLoadingTransactions => _isLoadingTransactions;
  bool get isProcessing => _isProcessing;

  void _loadData() {
    _isLoadingTransactions = true;
    notifyListeners();

    _repository.listWalletTransactions(_authService.user!.uid).listen((data) {
      _transactions = data;
      _isLoadingTransactions = false;
      _optimisticBalance = null; // Sync with real data
      notifyListeners();
    });

    _repository.getActiveResourceOrder(_authService.user!.uid).listen((order) {
      _activeOrder = order;
      notifyListeners();
    });
  }

  void _loadPackages() {
    _repository.listTokenPackages(targetRole: _authService.userData?.role).listen((data) {
      _tokenPackages = data;
      notifyListeners();
    });
  }

  void _loadPricing() {
    _repository.listElementPricing().listen((data) {
      _elementPricing = data;
      notifyListeners();
    });
  }

  int get daysUntilExpiry {
    final expiryData = _authService.userData?.rawData['visibilityExpiresAt'];
    if (expiryData == null) return 0;
    
    DateTime? expiry;
    if (expiryData is DateTime) {
      expiry = expiryData;
    } else {
      expiry = DateTime.tryParse(expiryData.toString());
    }

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
    _optimisticBalance = balance - cost;
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
      _optimisticBalance = null;
      return {'success': false, 'error': 'Transaction failed'};
    } catch (e) {
      _optimisticBalance = null;
      return {'success': false, 'error': e.toString()};
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
