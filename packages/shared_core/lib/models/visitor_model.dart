import 'package:cloud_firestore/cloud_firestore.dart';

class VisitorModel {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String source;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? countryId;
  final bool isVerified;

  VisitorModel({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.source = 'pwa',
    this.createdAt,
    this.updatedAt,
    this.countryId,
    this.isVerified = false,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      if (val is Timestamp) return val.toDate();
      if (val is DateTime) return val;
      return DateTime.tryParse(val.toString());
    }

    return VisitorModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      source: json['source'] as String? ?? 'pwa',
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      countryId: (json['countryId'] ?? json['country']) as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
}
