import 'package:cloud_firestore/cloud_firestore.dart';

class ProfessionalModel {
  final String id;
  final String? firebaseUid;
  final String? fullNameEn;
  final String? fullNameAr;
  final String? name;
  final String? email;
  final String? phone;
  final String? whatsapp;
  final String? specialty;
  final String? specialtyAr;
  final String? bioEn;
  final String? bioAr;
  final String? photoUrl;
  final String? sectorId;
  final String? categoryId;
  final String? countryId;
  final String? governorateId;
  final String? cityId;
  final bool isActive;
  final bool isApproved;
  final bool isHonorVerified;
  final String? authMethod;
  final bool hasProfile;
  final DateTime? lastPurchaseDate;
  final int activeServices;
  final int activeSlots;
  final String membershipTier;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastActive;
  final int profileViews;
  final int whatsappClicks;
  final int totalMatches;
  final int favoriteCount;
  final String? proofUrl;
  final int walletBalance;
  final int tokensUsed;

  ProfessionalModel({
    required this.id,
    this.firebaseUid,
    this.fullNameEn,
    this.fullNameAr,
    this.name,
    this.email,
    this.phone,
    this.whatsapp,
    this.specialty,
    this.specialtyAr,
    this.bioEn,
    this.bioAr,
    this.photoUrl,
    this.sectorId,
    this.categoryId,
    this.countryId,
    this.governorateId,
    this.cityId,
    this.isActive = true,
    this.isApproved = false,
    this.isHonorVerified = false,
    this.authMethod,
    this.hasProfile = false,
    this.lastPurchaseDate,
    this.activeServices = 0,
    this.activeSlots = 0,
    this.membershipTier = 'none',
    this.role = 'visitor',
    this.createdAt,
    this.updatedAt,
    this.lastActive,
    this.profileViews = 0,
    this.whatsappClicks = 0,
    this.totalMatches = 0,
    this.favoriteCount = 0,
    this.proofUrl,
    this.walletBalance = 0,
    this.tokensUsed = 0,
  });

  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      if (val is Timestamp) return val.toDate();
      if (val is DateTime) return val;
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      if (val is double) return DateTime.fromMillisecondsSinceEpoch(val.toInt());
      return DateTime.tryParse(val.toString());
    }

    return ProfessionalModel(
      id: json['id'] as String? ?? json['uid'] as String? ?? '',
      firebaseUid: json['firebaseUid'] as String? ?? json['uid'] as String?,
      fullNameEn: json['fullNameEn'] as String?,
      fullNameAr: json['fullNameAr'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: (json['phone'] ?? json['number']) as String?,
      whatsapp: json['whatsapp'] as String?,
      specialty: (json['specialty'] ?? json['specialization']) as String?,
      specialtyAr: (json['specialtyAr'] ?? json['specialization_ar']) as String?,
      bioEn: (json['bioEn'] ?? json['bio']) as String?,
      bioAr: (json['bioAr'] ?? json['bio']) as String?,
      photoUrl: json['photoUrl'] as String?,
      sectorId: json['sectorId'] as String?,
      categoryId: json['categoryId'] as String?,
      countryId: (json['countryId'] ?? json['country']) as String?,
      governorateId: json['governorateId'] as String?,
      cityId: json['cityId'] as String?,
      isActive: json['isActive'] ?? json['is_active'] ?? true,
      isApproved: json['isApproved'] ?? json['is_approved'] ?? false,
      isHonorVerified: json['isHonorVerified'] ?? json['isHonorVerified'] ?? false,
      authMethod: json['authMethod'] as String?,
      hasProfile: json['hasProfile'] as bool? ?? false,
      lastPurchaseDate: parseDate(json['last_purchase_date']),
      activeServices: json['active_services'] as int? ?? 0,
      activeSlots: json['active_slots'] as int? ?? 0,
      membershipTier: json['membershipTier']?.toString() ?? 'none',
      role: json['role'] as String? ?? 'visitor',
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      lastActive: parseDate(json['last_active']),
      profileViews: json['profileViews'] ?? json['view_count'] ?? 0,
      whatsappClicks: json['whatsappClicks'] ?? json['message_count'] ?? 0,
      totalMatches: json['totalMatches'] as int? ?? 0,
      favoriteCount: json['favoriteCount'] ?? 0,
      proofUrl: (json['proofUrl'] ?? json['proof_url'] ?? json['license_url']) as String?,
      walletBalance: json['walletBalance'] as int? ?? 0,
      tokensUsed: json['tokensUsed'] as int? ?? 0,
    );
  }
}
