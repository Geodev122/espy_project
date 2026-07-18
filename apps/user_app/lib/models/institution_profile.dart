class InstitutionProfile {
  final String id;
  final String? nameAr;
  final String? registrationNumber;
  final bool isApproved;
  final int serviceSlots;
  final DateTime? visibilityExpiresAt;

  InstitutionProfile({
    required this.id,
    this.nameAr,
    this.registrationNumber,
    this.isApproved = false,
    this.serviceSlots = 5,
    this.visibilityExpiresAt,
  });

  factory InstitutionProfile.fromMap(Map<String, dynamic> data) {
    return InstitutionProfile(
      id: data['id'] ?? data['uid'] ?? '',
      nameAr: data['nameAr'],
      registrationNumber: data['registrationNumber'],
      isApproved: data['isApproved'] ?? false,
      serviceSlots: data['serviceSlots'] ?? 5,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameAr': nameAr,
      'registrationNumber': registrationNumber,
      'isApproved': isApproved,
      'serviceSlots': serviceSlots,
    };
  }
}
