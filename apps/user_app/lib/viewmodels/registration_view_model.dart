import 'package:flutter/foundation.dart';
import './auth_service.dart';
import './espy_repository.dart';
import './storage_service.dart';
import '../models/user_model.dart';
import '../models/city_model.dart';
import '../models/enums.dart';

class RegistrationViewModel extends ChangeNotifier {
  final AuthService _authService;
  final EspyRepository _repository;
  final StorageService _storage;

  int _currentPhase = 0;
  bool _isSubmitting = false;

  int _pinsCount = 1;
  int _slotsCount = 2;
  int _broadcastsCount = 0;

  RegistrationViewModel(this._repository, this._authService, this._storage);

  int get currentPhase => _currentPhase;
  bool get isSubmitting => _isSubmitting;
  int get pinsCount => _pinsCount;
  int get slotsCount => _slotsCount;
  int get broadcastsCount => _broadcastsCount;

  void setPhase(int phase) {
    _currentPhase = phase;
    notifyListeners();
  }

  void updatePins(int val) { _pinsCount = val; notifyListeners(); }
  void updateSlots(int val) { _slotsCount = val; notifyListeners(); }
  void updateBroadcasts(int val) { _broadcastsCount = val; notifyListeners(); }

  Future<bool> submitProfessionalRegistration({
    required String name,
    required String bio,
    required String bioAr,
    required String specialty,
    required String specialtyAr,
    required String sectorId,
    required String categoryId,
    required String whatsapp,
    dynamic profileImage,
    dynamic docFile,
    CityModel? mainLocation,
  }) async {
    final user = _authService.user;
    if (user == null) return false;

    _isSubmitting = true;
    notifyListeners();

    try {
      // 1. Upload Docs
      // String? photoUrl;
      // String? docUrl;
      // if (profileImage != null) photoUrl = await _storage.uploadProfileImage(userId: user.uid, file: profileImage);
      
      final userData = UserModel(
        id: user.uid,
        email: user.email!,
        name: name,
        role: UserRole.professional,
        isActive: true,
        hasProfile: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rawData: {
          'mainLocation': mainLocation?.toMap(),
          'sectorId': sectorId,
          'categoryId': categoryId,
          'bio': bio,
          'bioAr': bioAr,
          'specialty': specialty,
          'specialtyAr': specialtyAr,
          'whatsapp': whatsapp,
          'practicePins': _pinsCount,
          'serviceSlots': _slotsCount,
        }
      );

      await _repository.upsertUser(userData);
      await _authService.fetchUserData();
      return true;
    } catch (e) {
      debugPrint("Registration Error: $e");
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> completeOnboarding({
    required String role,
    String? fullNameAr,
    String? specialty,
    String? specialtyAr,
    String? bioEn,
    String? bioAr,
    String? registrationNumber,
    CityModel? mainLocation,
    List<String>? interests,
  }) async {
    // Legacy support or simplified version
    return await submitProfessionalRegistration(
      name: _authService.user?.displayName ?? '',
      bio: bioEn ?? '',
      bioAr: bioAr ?? '',
      specialty: specialty ?? '',
      specialtyAr: specialtyAr ?? '',
      sectorId: 'health', // Fallback
      categoryId: 'doctors',
      whatsapp: '',
      mainLocation: mainLocation,
    );
  }
}
