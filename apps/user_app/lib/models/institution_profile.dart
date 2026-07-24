class InstitutionProfile {
  final String id;
  final String? nameAr;
  final String? bioEn;
  final String? bioAr;
  final String? registrationNumber;
  final bool isApproved;
  final bool isProfileValidated;
  final String? verificationDocUrl;
  final int serviceSlots;
  final DateTime? visibilityExpiresAt;

  InstitutionProfile({
    required this.id,
    this.nameAr,
    this.bioEn,
    this.bioAr,
    this.registrationNumber,
    this.isApproved = false,
    this.isProfileValidated = false,
    this.verificationDocUrl,
    this.serviceSlots = 5,
    this.visibilityExpiresAt,
  });

  factory InstitutionProfile.fromMap(Map<String, dynamic> data) {
    return InstitutionProfile(
      id: data['id'] ?? data['uid'] ?? '',
      nameAr: data['nameAr'],
      bioEn: data['bioEn'],
      bioAr: data['bioAr'],
      registrationNumber: data['registrationNumber'],
      isApproved: data['isApproved'] ?? false,
      isProfileValidated: data['isProfileValidated'] ?? false,
      verificationDocUrl: data['verificationDocUrl'],
      serviceSlots: data['serviceSlots'] ?? 5,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameAr': nameAr,
      'bioEn': bioEn,
      'bioAr': bioAr,
      'registrationNumber': registrationNumber,
      'isApproved': isApproved,
      'isProfileValidated': isProfileValidated,
      'verificationDocUrl': verificationDocUrl,
      'serviceSlots': serviceSlots,
    };
  }
}
