import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

class ServiceModel {
  final String id;
  final String providerId;
  final String categoryId;
  final String sectorId;
  final String? priceTagId;
  final String titleEn;
  final String? titleAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final int price;
  final DeliveryMode deliveryMode;
  final bool isActive;
  final bool isAllocated;
  final ModerationStatus moderationStatus;
  final String? flagReason;
  final String? imageUrl;
  final DateTime? visibilityExpiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceModel({
    required this.id,
    required this.providerId,
    required this.categoryId,
    required this.sectorId,
    this.priceTagId,
    required this.titleEn,
    this.titleAr,
    this.descriptionEn,
    this.descriptionAr,
    this.price = 0,
    this.deliveryMode = DeliveryMode.face_to_face,
    this.isActive = true,
    this.isAllocated = false,
    this.moderationStatus = ModerationStatus.pending,
    this.flagReason,
    this.imageUrl,
    this.visibilityExpiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> data) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is DateTime) return val;
      return DateTime.tryParse(val.toString()) ?? DateTime.now();
    }

    return ServiceModel(
      id: data['id'] ?? '',
      providerId: data['providerId'] ?? data['provider']?['id'] ?? '',
      categoryId: data['categoryId'] ?? data['category']?['id'] ?? '',
      sectorId: data['sectorId'] ?? data['sector']?['id'] ?? '',
      priceTagId: data['priceTagId'] ?? data['priceTag']?['id'],
      titleEn: data['titleEn'] ?? data['title'] ?? 'Untitled',
      titleAr: data['titleAr'],
      descriptionEn: data['descriptionEn'] ?? data['description'],
      descriptionAr: data['descriptionAr'],
      price: data['price'] ?? 0,
      deliveryMode: DeliveryMode.parse(data['deliveryMode']),
      isActive: data['isActive'] ?? true,
      isAllocated: data['isAllocated'] ?? false,
      moderationStatus: ModerationStatus.parse(data['moderationStatus']),
      flagReason: data['flagReason'],
      imageUrl: data['imageUrl'] ?? data['photoUrl'],
      visibilityExpiresAt: data['visibilityExpiresAt'] != null ? parseDate(data['visibilityExpiresAt']) : null,
      createdAt: parseDate(data['createdAt']),
      updatedAt: parseDate(data['updatedAt'] ?? data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'providerId': providerId,
      'categoryId': categoryId,
      'sectorId': sectorId,
      'priceTagId': priceTagId,
      'titleEn': titleEn,
      'titleAr': titleAr,
      'descriptionEn': descriptionEn,
      'descriptionAr': descriptionAr,
      'price': price,
      'deliveryMode': deliveryMode.name,
      'isActive': isActive,
      'isAllocated': isAllocated,
      'moderationStatus': moderationStatus.name,
      'flagReason': flagReason,
      'imageUrl': imageUrl,
      'visibilityExpiresAt': visibilityExpiresAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
