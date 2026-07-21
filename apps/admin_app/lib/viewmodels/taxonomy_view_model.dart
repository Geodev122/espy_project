import 'dart:async';
import 'package:flutter/foundation.dart';
import 'espy_repository.dart';

class TaxonomyViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<Map<String, dynamic>> _sectors = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  TaxonomyViewModel(this._repository) {
    _init();
  }

  List<Map<String, dynamic>> get sectors => _sectors;
  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;

  void _init() {
    _repository.listSectors().listen((data) {
      _sectors = data;
      _isLoading = false;
      notifyListeners();
    });
    _repository.listCategories().listen((data) {
      _categories = data;
      notifyListeners();
    });
  }

  Future<void> saveSector(String id, Map<String, dynamic> data) async {
    await _repository.updateSector(id, data);
  }

  Future<void> saveCategory(String id, Map<String, dynamic> data) async {
    await _repository.updateCategory(id, data);
  }
}
