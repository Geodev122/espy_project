import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './auth_service.dart';
import './espy_repository.dart';
import '../models/enums.dart';

class DashboardViewModel extends ChangeNotifier {
  final AuthService _authService;
  final EspyRepository _repository;

  bool _isRenewing = false;
  bool get isRenewing => _isRenewing;

  DashboardViewModel(this._authService, this._repository);

  Map<String, dynamic>? get profile => _authService.userData?.rawData;

  int get activePins => (profile?['secondaryLocations'] as List? ?? []).length + 1;
  int get serviceSlots => profile?['serviceSlots'] ?? 0;
  int get broadcastsBought => profile?['broadcastsBought'] ?? 0;

  int get visibilityDaysRemaining {
    final expiry = profile?['visibilityExpiresAt'] != null
        ? (profile?['visibilityExpiresAt'] is Timestamp
            ? (profile?['visibilityExpiresAt'] as Timestamp).toDate()
            : DateTime.tryParse(profile?['visibilityExpiresAt']?.toString() ?? ''))
        : null;

    if (expiry == null) return 0;
    final diff = expiry.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  bool get isVisibilityExpired => visibilityDaysRemaining <= 0;

  Future<bool> quickRenew() async {
    if (_authService.user == null) return false;
    
    _isRenewing = true;
    notifyListeners();

    try {
      final result = await _repository.spendTokens(
        userId: _authService.user!.uid,
        itemId: 'renew_visibility',
        cost: 500, // Default cost, could be fetched from settings repo later
        role: _authService.userData?.role ?? UserRole.professional,
      );

      if (result['success'] == true) {
        await _authService.fetchUserData();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Renewal Error: $e');
      return false;
    } finally {
      _isRenewing = false;
      notifyListeners();
    }
  }
}
