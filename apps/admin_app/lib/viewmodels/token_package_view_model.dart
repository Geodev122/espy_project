import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:espy_core/espy_core.dart';

class TokenPackageViewModel extends ChangeNotifier {
  final EspyRepository _repository;

  List<Map<String, dynamic>> _packages = [];
  bool _isLoading = false;
  StreamSubscription? _packageSub;

  TokenPackageViewModel(this._repository);

  List<Map<String, dynamic>> get packages => _packages;
  bool get isLoading => _isLoading;

  void listenToTokenPackages({UserRole? targetRole, bool? isActive}) {
    _isLoading = true;
    notifyListeners();

    _packageSub?.cancel();
    _packageSub = _repository.listTokenPackages(targetRole: targetRole, isActive: isActive).listen((data) {
      _packages = data;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint("Error listening to token packages: $e");
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> upsertTokenPackage(Map<String, dynamic> data) async {
    try {
      await _repository.upsertTokenPackage(data);
    } catch (e) {
      debugPrint("Error upserting token package: $e");
      rethrow;
    }
  }

  Future<void> togglePackageStatus(String id, Map<String, dynamic> currentData, bool isActive) async {
    try {
      await _repository.upsertTokenPackage({
        ...currentData,
        'isActive': isActive,
      });
    } catch (e) {
      debugPrint("Error toggling package status: $e");
    }
  }

  @override
  void dispose() {
    _packageSub?.cancel();
    super.dispose();
  }
}
