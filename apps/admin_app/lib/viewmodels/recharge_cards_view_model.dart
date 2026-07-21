import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'espy_repository.dart';

class RechargeCardsViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<Map<String, dynamic>> _cards = [];
  bool _isLoading = true;
  bool _isGenerating = false;

  StreamSubscription? _cardsSub;

  RechargeCardsViewModel(this._repository) {
    _init();
  }

  List<Map<String, dynamic>> get cards => _cards;
  bool get isLoading => _isLoading;
  bool get isGenerating => _isGenerating;

  void _init() {
    _cardsSub = _repository.listRechargeCards().listen((data) {
      _cards = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> generateCard({required int value, int pins = 0, int slots = 0}) async {
    _isGenerating = true;
    notifyListeners();

    try {
      final String code = _generateRandomCode();
      await _repository.generateRechargeCard(code: code, value: value, pins: pins, slots: slots);
    } catch (e) {
      debugPrint("Card Gen Error: $e");
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  String _generateRandomCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(
      12, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))
    )).replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)}-").substring(0, 14);
  }

  @override
  void dispose() {
    _cardsSub?.cancel();
    super.dispose();
  }
}
