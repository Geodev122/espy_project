import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final String? phone;
  final String? whatsapp;
  final String? adminNotes;
  final UserRole role;
  final bool isActive;
  final bool hasProfile;
  final int walletBalance;
  final int tokensUsed;
  final DateTime? lastActiveAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> rawData;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.phone,
    this.whatsapp,
    this.adminNotes,
    required this.role,
    this.isActive = true,
    this.hasProfile = false,
    this.walletBalance = 0,
    this.tokensUsed = 0,
    this.lastActiveAt,
    required this.createdAt,
    required this.updatedAt,
    this.rawData = const {},
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is DateTime) return val;
      return DateTime.tryParse(val.toString()) ?? DateTime.now();
    }

    return UserModel(
      id: data['id'] ?? data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? data['fullNameEn'] ?? '',
      photoUrl: data['photoUrl'],
      phone: data['phone'],
      whatsapp: data['whatsapp'],
      adminNotes: data['adminNotes'] ?? data['admin_notes'],
      role: UserRole.parse(data['role']),
      isActive: data['isActive'] ?? data['is_active'] ?? true,
      hasProfile: data['hasProfile'] ?? false,
      walletBalance: data['walletBalance'] ?? 0,
      tokensUsed: data['tokensUsed'] ?? 0,
      lastActiveAt: data['lastActiveAt'] != null ? parseDate(data['lastActiveAt']) : null,
      createdAt: parseDate(data['createdAt'] ?? data['created_at']),
      updatedAt: parseDate(data['updatedAt'] ?? data['updated_at'] ?? data['createdAt']),
      rawData: data,
    );
  }

  dynamic operator [](String key) => rawData[key];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'phone': phone,
      'whatsapp': whatsapp,
      'adminNotes': adminNotes,
      'role': role.name,
      'isActive': isActive,
      'hasProfile': hasProfile,
      'walletBalance': walletBalance,
      'tokensUsed': tokensUsed,
      'lastActiveAt': lastActiveAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
