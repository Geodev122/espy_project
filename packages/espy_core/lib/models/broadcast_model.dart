import 'enums.dart';

class BroadcastModel {
  final String id;
  final String senderId;
  final String title;
  final String message;
  final String targetCountry;
  final String? targetRegion;
  final String? targetCity;
  final String status;
  final ModerationStatus moderationStatus;
  final String? flagReason;
  final UserRole? targetRole;
  final String? targetSectorId;
  final String? targetCategoryId;
  final String? senderName;
  final String? senderEmail;
  final DateTime createdAt;

  BroadcastModel({
    required this.id,
    required this.senderId,
    required this.title,
    required this.message,
    required this.targetCountry,
    this.targetRegion,
    this.targetCity,
    required this.status,
    required this.moderationStatus,
    this.flagReason,
    this.targetRole,
    this.targetSectorId,
    this.targetCategoryId,
    this.senderName,
    this.senderEmail,
    required this.createdAt,
  });

  factory BroadcastModel.fromMap(Map<String, dynamic> map) {
    return BroadcastModel(
      id: map['id'],
      senderId: map['senderId'] ?? '',
      title: map['title'],
      message: map['message'],
      targetCountry: map['targetCountry'] ?? 'GLOBAL',
      targetRegion: map['targetRegion'],
      targetCity: map['targetCity'],
      status: map['status'] ?? 'queued',
      moderationStatus: ModerationStatus.parse(map['moderationStatus']),
      flagReason: map['flagReason'],
      targetRole: map['targetRole'] != null ? UserRole.parse(map['targetRole']) : null,
      targetSectorId: map['targetSectorId'],
      targetCategoryId: map['targetCategoryId'],
      senderName: map['senderName'],
      senderEmail: map['senderEmail'],
      createdAt: map['createdAt'] is DateTime ? map['createdAt'] : DateTime.parse(map['createdAt'].toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'title': title,
      'message': message,
      'targetCountry': targetCountry,
      'targetRegion': targetRegion,
      'targetCity': targetCity,
      'status': status,
      'moderationStatus': moderationStatus.name,
      'flagReason': flagReason,
      'targetRole': targetRole?.name,
      'targetSectorId': targetSectorId,
      'targetCategoryId': targetCategoryId,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
