import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { visitor, professional, institution, admin, pending }

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final UserRole role;
  final bool isActive;
  final bool hasProfile;
  final int walletBalance;
  final int tokensUsed;
  final DateTime createdAt;
  final Map<String, dynamic> rawData;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.role,
    this.isActive = true,
    this.hasProfile = false,
    this.walletBalance = 0,
    this.tokensUsed = 0,
    required this.createdAt,
    this.rawData = const {},
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? data['fullNameEn'] ?? '',
      photoUrl: data['photoUrl'],
      role: _parseRole(data['role']),
      isActive: data['isActive'] ?? data['is_active'] ?? true,
      hasProfile: data['hasProfile'] ?? false,
      walletBalance: data['walletBalance'] ?? 0,
      tokensUsed: data['tokensUsed'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      rawData: data,
    );
  }

  dynamic operator [](String key) => rawData[key];

  static UserRole _parseRole(String? role) {
    switch (role) {
      case 'visitor': return UserRole.visitor;
      case 'professional': return UserRole.professional;
      case 'institution': return UserRole.institution;
      case 'admin': return UserRole.admin;
      default: return UserRole.pending;
    }
  }
}
