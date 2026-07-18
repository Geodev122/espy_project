import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String id;
  final String providerId;
  final String categoryId;
  final String titleEn;
  final String? titleAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final int price;
  final bool isActive;
  final bool isAllocated;
  final String? imageUrl;
  final DateTime? visibilityExpiresAt;

  ServiceModel({
    required this.id,
    required this.providerId,
    required this.categoryId,
    required this.titleEn,
    this.titleAr,
    this.descriptionEn,
    this.descriptionAr,
    this.price = 0,
    this.isActive = true,
    this.isAllocated = false,
    this.imageUrl,
    this.visibilityExpiresAt,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> data) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      if (val is Timestamp) return val.toDate();
      if (val is DateTime) return val;
      return DateTime.tryParse(val.toString());
    }

    return ServiceModel(
      id: data['id'] ?? '',
      providerId: data['providerId'] ?? data['professionalId'] ?? '',
      categoryId: data['categoryId'] ?? '',
      titleEn: data['titleEn'] ?? data['title'] ?? 'Untitled',
      titleAr: data['titleAr'],
      descriptionEn: data['descriptionEn'] ?? data['description'],
      descriptionAr: data['descriptionAr'],
      price: data['price'] ?? 0,
      isActive: data['isActive'] ?? true,
      isAllocated: data['isAllocated'] ?? false,
      imageUrl: data['imageUrl'] ?? data['photoUrl'],
      visibilityExpiresAt: parseDate(data['visibilityExpiresAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'providerId': providerId,
      'categoryId': categoryId,
      'titleEn': titleEn,
      'titleAr': titleAr,
      'descriptionEn': descriptionEn,
      'descriptionAr': descriptionAr,
      'price': price,
      'isActive': isActive,
      'isAllocated': isAllocated,
      'imageUrl': imageUrl,
      'visibilityExpiresAt': visibilityExpiresAt,
    };
  }
}
