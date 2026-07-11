import '../services/espy_repository.dart';

class WalletViewModel extends ChangeNotifier {
  final AuthService _authService;
  final EspyRepository _repository;

  List<Map<String, dynamic>> _transactions = [];
  bool _isLoadingTransactions = false;
  bool _isProcessing = false;

  WalletViewModel(this._authService, this._repository) {
    if (_authService.user != null) {
      _loadTransactions();
    }
  }

  int get balance => _authService.userData?.walletBalance ?? 0;
  List<Map<String, dynamic>> get transactions => _transactions;
  bool get isLoadingTransactions => _isLoadingTransactions;
  bool get isProcessing => _isProcessing;

  void _loadTransactions() {
    _isLoadingTransactions = true;
    notifyListeners();

    _repository.getUserTransactions(_authService.user!.uid).listen((data) {
      _transactions = data;
      _isLoadingTransactions = false;
      notifyListeners();
    });
  }

  Future<void> refreshBalance() async {
    await _authService.fetchUserData();
    notifyListeners();
  }

  Future<Map<String, dynamic>> redeemCode(String code) async {
    _isProcessing = true;
    notifyListeners();
    try {
      final result = await _functions.httpsCallable('redeemRechargeCode').call({
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
        role: _authService.userData?.role.name ?? 'professional',
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
