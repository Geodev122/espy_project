import 'dart:io';
import 'package:flutter/foundation.dart';
import 'espy_repository.dart';
import 'auth_service.dart';
import 'storage_service.dart';

class RegistrationViewModel extends ChangeNotifier {
  final EspyRepository _repository;
  final AuthService _authService;
  final StorageService _storage;

  bool _isSubmitting = false;
  int _currentPhase = 0;

  // Resource Counts
  int _pinsCount = 1;
  int _slotsCount = 2;
  int _broadcastsCount = 0;

  RegistrationViewModel(this._repository, this._authService, this._storage) {
    if (_authService.userData?.role.name == 'institution') {
      _slotsCount = 5;
    }
  }

  bool get isSubmitting => _isSubmitting;
  int get currentPhase => _currentPhase;
  int get pinsCount => _pinsCount;
  int get slotsCount => _slotsCount;
  int get broadcastsCount => _broadcastsCount;

  int get totalCost => (_pinsCount * 500) + (_slotsCount * 300) + (_broadcastsCount * 1000);

  void setPhase(int phase) {
    _currentPhase = phase;
    notifyListeners();
  }

  void updatePins(int count) { _pinsCount = count; notifyListeners(); }
  void updateSlots(int count) { _slotsCount = count; notifyListeners(); }
  void updateBroadcasts(int count) { _broadcastsCount = count; notifyListeners(); }

  Future<void> submitProfessionalRegistration({
    required String name,
    required String bio,
    required String bioAr,
    required String specialty,
    required String specialtyAr,
    required String sectorId,
    required String categoryId,
    required String whatsapp,
    File? profileImage,
    Uint8List? profileBytes,
    Map<String, dynamic>? mainLocation,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final uid = _authService.user!.uid;
      String? photoUrl;
      if (profileBytes != null) {
        photoUrl = await _storage.uploadProfileImageWeb(userId: uid, bytes: profileBytes);
      } else if (profileImage != null) {
        photoUrl = await _storage.uploadProfileImage(userId: uid, file: profileImage);
      }

      // 1. Update Core Profile
      await _repository.updateUser(uid, {
        'name': name,
        'photoUrl': photoUrl ?? _authService.user?.photoURL,
        'role': _authService.userData?.role.name == 'institution' ? 'institution' : 'professional',
        'hasProfile': true,
      });

      // 2. Update Role Profile
      if (_authService.userData?.role.name == 'institution') {
        await _repository.upsertInstitutionProfile(
          id: uid,
          nameAr: name,
          bioEn: bio,
          bioAr: bioAr,
          registrationNumber: specialty, 
        );
      } else {
        await _repository.upsertProfessionalProfile(
          id: uid,
          fullNameAr: name,
          specialty: specialty,
          specialtyAr: specialtyAr,
          bioEn: bio,
          bioAr: bioAr,
        );
      }

      // 3. Create main location node if provided
      if (mainLocation != null) {
        await _repository.createLocationNode({
          'userId': uid,
          'cityId': mainLocation['id'],
          'lat': mainLocation['lat'] ?? 0.0,
          'lng': mainLocation['lng'] ?? 0.0,
          'label': "Primary Hub",
          'isMain': true,
        });
      }

      // 4. Create Resource Order
      await _repository.createResourceOrder(
        userId: uid,
        pins: _pinsCount,
        slots: _slotsCount,
        broadcasts: _broadcastsCount,
        total: totalCost,
      );

      await _authService.fetchUserData();
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
