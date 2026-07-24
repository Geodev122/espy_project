import 'dart:async';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:espy_core/espy_core.dart';
import '../utils/download_helper.dart';

class FinanceViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<WalletTransactionModel> _transactions = [];
  bool _isLoading = false;
  double _operationalCostPercentage = 0.20; // Default 20%

  FinanceViewModel(this._repository) {
    _loadOpCost();
  }

  List<WalletTransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  double get operationalCostPercentage => _operationalCostPercentage;

  double get totalRevenue => _transactions
      .where((t) => t.type == TransactionType.recharge)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalTokensSpent => _transactions
      .where((t) => t.type == TransactionType.purchase)
      .fold(0.0, (sum, t) => sum + t.amount.abs());

  double get netProfit => totalRevenue * (1 - _operationalCostPercentage);

  Future<void> _loadOpCost() async {
    final val = await _repository.getAppConfig('operational_cost_percentage');
    if (val != null) {
      _operationalCostPercentage = double.tryParse(val) ?? 0.20;
      notifyListeners();
    }
  }

  Future<void> updateOpCost(double value) async {
    _operationalCostPercentage = value;
    await _repository.updateAppConfig('operational_cost_percentage', value.toString());
    notifyListeners();
  }

  Future<void> loadStats({DateTime? start, DateTime? end}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await _repository.getFinanceStats(start: start, end: end);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading finance stats: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refundTransaction(String id, String reason) async {
    try {
      await _repository.refundTransaction(id, reason);
      await loadStats(); // Refresh
    } catch (e) {
      debugPrint("Refund Error: $e");
      rethrow;
    }
  }

  Future<void> downloadInvoice(WalletTransactionModel t) async {
     await InvoiceService.generateAndDownloadA5Invoice(t.toMap());
  }

  Future<void> exportToExcel() async {
    if (_transactions.isEmpty) return;
    
    final excel = Excel.createExcel();
    final Sheet sheet = excel['Finance Report'];

    sheet.appendRow(['ID', 'User ID', 'Amount', 'Type', 'Description', 'Date', 'Invoice', 'Refunded']);
    for (var t in _transactions) {
      final map = t.toMap();
      sheet.appendRow([
        t.id, 
        t.userId, 
        t.amount, 
        t.type.name.toUpperCase(), 
        t.description ?? '', 
        t.createdAt.toIso8601String(),
        map['invoiceNumber'] ?? '',
        map['isRefunded'] == true ? 'YES' : 'NO',
      ]);
    }
    
    final bytes = excel.encode();
    if (bytes != null) {
      DownloadHelper.downloadBytes(bytes, "espy_finance_report_${DateTime.now().millisecondsSinceEpoch}.xlsx");
    }
  }

  // --- Chart Data Helpers ---

  List<Map<String, dynamic>> getDailyRevenueData() {
    final Map<String, double> daily = {};
    for (var t in _transactions.where((tx) => tx.type == TransactionType.recharge)) {
      final day = "${t.createdAt.year}-${t.createdAt.month}-${t.createdAt.day}";
      daily[day] = (daily[day] ?? 0) + t.amount;
    }
    return daily.entries.map((e) => {'date': e.key, 'value': e.value}).toList();
  }

  List<Map<String, dynamic>> getRoleDistributionData() {
    // This would ideally come from more granular data, but we can approximate from transactions
    // if we had the user role in the transaction model.
    return [];
  }
}
