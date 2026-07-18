import 'package:cloud_firestore/cloud_firestore.dart';

class ProfessionalProfile {
  final String id;
  final String? fullNameAr;
  final String? specialty;
  final String? specialtyAr;
  final String? bioEn;
  final String? bioAr;
  final bool isApproved;
  final bool isHonorVerified;
  final String membershipTier;
  final int serviceSlots;
  final int practicePins;
  final DateTime? visibilityExpiresAt;

  ProfessionalProfile({
    required this.id,
    this.fullNameAr,
    this.specialty,
    this.specialtyAr,
    this.bioEn,
    this.bioAr,
    this.isApproved = false,
    this.isHonorVerified = false,
    this.membershipTier = 'basic',
    this.serviceSlots = 2,
    this.practicePins = 0,
    this.visibilityExpiresAt,
  });

  factory ProfessionalProfile.fromMap(Map<String, dynamic> data) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      if (val is Timestamp) return val.toDate();
      if (val is DateTime) return val;
      return DateTime.tryParse(val.toString());
    }

    return ProfessionalProfile(
      id: data['id'] ?? data['uid'] ?? '',
      fullNameAr: data['fullNameAr'],
      specialty: data['specialty'],
      specialtyAr: data['specialtyAr'],
      bioEn: data['bioEn'],
      bioAr: data['bioAr'],
      isApproved: data['isApproved'] ?? false,
      isHonorVerified: data['isHonorVerified'] ?? false,
      membershipTier: data['membershipTier'] ?? 'basic',
      serviceSlots: data['serviceSlots'] ?? 2,
      practicePins: data['practicePins'] ?? 0,
      visibilityExpiresAt: parseDate(data['visibilityExpiresAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullNameAr': fullNameAr,
      'specialty': specialty,
      'specialtyAr': specialtyAr,
      'bioEn': bioEn,
      'bioAr': bioAr,
      'isApproved': isApproved,
      'isHonorVerified': isHonorVerified,
      'membershipTier': membershipTier,
      'serviceSlots': serviceSlots,
      'practicePins': practicePins,
      'visibilityExpiresAt': visibilityExpiresAt,
    };
  }
}
