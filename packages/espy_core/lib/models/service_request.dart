import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

class ServiceRequestModel {
  final String id;
  final String userId;
  final String sectorId;
  final String descriptionEn;
  final String? descriptionAr;
  final UrgencyLevel urgency;
  final DeliveryMode preferredMode;
  final CommunityRequestStatus status;
  final ModerationStatus moderationStatus;
  final String? flagReason;
  final DateTime createdAt;
  final String? userName;
  final String? sectorName;

  ServiceRequestModel({
    required this.id,
    required this.userId,
    required this.sectorId,
    required this.descriptionEn,
    this.descriptionAr,
    this.urgency = UrgencyLevel.medium,
    this.preferredMode = DeliveryMode.face_to_face,
    this.status = CommunityRequestStatus.active,
    this.moderationStatus = ModerationStatus.approved,
    this.flagReason,
    required this.createdAt,
    this.userName,
    this.sectorName,
  });

  factory ServiceRequestModel.fromMap(Map<String, dynamic> data) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is DateTime) return val;
      return DateTime.tryParse(val.toString()) ?? DateTime.now();
    }

    return ServiceRequestModel(
      id: data['id']?.toString() ?? '',
      userId: data['userId'] ?? data['user']?['id'] ?? '',
      sectorId: data['sectorId'] ?? data['sector']?['id'] ?? '',
      descriptionEn: data['descriptionEn'] ?? '',
      descriptionAr: data['descriptionAr'],
      urgency: UrgencyLevel.parse(data['urgency']),
      preferredMode: DeliveryMode.parse(data['preferredMode']),
      status: CommunityRequestStatus.parse(data['status']),
      moderationStatus: ModerationStatus.parse(data['moderationStatus']),
      flagReason: data['flagReason'],
      createdAt: parseDate(data['createdAt']),
      userName: data['userName'] ?? data['user']?['name'],
      sectorName: data['sectorName'] ?? data['sector']?['nameEn'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'sectorId': sectorId,
      'descriptionEn': descriptionEn,
      'descriptionAr': descriptionAr,
      'urgency': urgency.name,
      'preferredMode': preferredMode.name,
      'status': status.name,
      'moderationStatus': moderationStatus.name,
      'flagReason': flagReason,
      'createdAt': createdAt,
    };
  }
}
