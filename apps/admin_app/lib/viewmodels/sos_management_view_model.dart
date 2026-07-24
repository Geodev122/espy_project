import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:espy_core/espy_core.dart';

class SosManagementViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<Map<String, dynamic>> _sosNumbers = [];
  bool _isLoading = false;
  StreamSubscription? _sosSub;

  SosManagementViewModel(this._repository);

  List<Map<String, dynamic>> get sosNumbers => _sosNumbers;
  bool get isLoading => _isLoading;

  void listenToSosNumbers({String? countryId, String? sectorId, String? categoryId}) {
    _isLoading = true;
    notifyListeners();
    
    _sosSub?.cancel();
    _sosSub = _repository.listSosNumbers(
      countryId: countryId,
      sectorId: sectorId,
      categoryId: categoryId,
    ).listen((data) {
      _sosNumbers = data;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint("Error listening to SOS numbers: $e");
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> upsertSosNumber(Map<String, dynamic> sosData) async {
    try {
      await _repository.upsertSosNumber(sosData);
    } catch (e) {
      debugPrint("Error upserting SOS number: $e");
      rethrow;
    }
  }

  Future<void> toggleSosStatus(String id, Map<String, dynamic> currentData, bool isActive) async {
    try {
      await _repository.upsertSosNumber({
        ...currentData,
        'isActive': isActive,
      });
    } catch (e) {
      debugPrint("Error toggling SOS status: $e");
    }
  }

  @override
  void dispose() {
    _sosSub?.cancel();
    super.dispose();
  }
}
