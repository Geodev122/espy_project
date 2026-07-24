import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

class SupportTicketModel {
  final String id;
  final String userId;
  final String subject;
  final String message;
  final SupportTicketStatus status;
  final String? adminNote;
  final DateTime createdAt;
  final String? userEmail;

  SupportTicketModel({
    required this.id,
    required this.userId,
    required this.subject,
    required this.message,
    this.status = SupportTicketStatus.open,
    this.adminNote,
    required this.createdAt,
    this.userEmail,
  });

  factory SupportTicketModel.fromMap(Map<String, dynamic> data) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is DateTime) return val;
      return DateTime.tryParse(val.toString()) ?? DateTime.now();
    }

    return SupportTicketModel(
      id: data['id']?.toString() ?? '',
      userId: data['userId'] ?? data['user']?['id'] ?? '',
      subject: data['subject'] ?? '',
      message: data['message'] ?? '',
      status: SupportTicketStatus.parse(data['status']),
      adminNote: data['adminNote'],
      createdAt: parseDate(data['createdAt']),
      userEmail: data['userEmail'] ?? data['user']?['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'subject': subject,
      'message': message,
      'status': status.name,
      'adminNote': adminNote,
      'createdAt': createdAt,
    };
  }
}
