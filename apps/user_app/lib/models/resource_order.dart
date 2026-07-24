import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

class ResourceOrderModel {
  final String id;
  final String userId;
  final int pinsCount;
  final int slotsCount;
  final int broadcastsCount;
  final int totalCost;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userEmail;

  ResourceOrderModel({
    required this.id,
    required this.userId,
    this.pinsCount = 0,
    this.slotsCount = 0,
    this.broadcastsCount = 0,
    this.totalCost = 0,
    this.status = OrderStatus.pending,
    required this.createdAt,
    required this.updatedAt,
    this.userEmail,
  });

  factory ResourceOrderModel.fromMap(Map<String, dynamic> data) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is DateTime) return val;
      return DateTime.tryParse(val.toString()) ?? DateTime.now();
    }

    return ResourceOrderModel(
      id: data['id']?.toString() ?? '',
      userId: data['userId'] ?? data['user']?['id'] ?? '',
      pinsCount: data['pinsCount'] ?? 0,
      slotsCount: data['slotsCount'] ?? 0,
      broadcastsCount: data['broadcastsCount'] ?? 0,
      totalCost: data['totalCost'] ?? 0,
      status: OrderStatus.parse(data['status']),
      createdAt: parseDate(data['createdAt']),
      updatedAt: parseDate(data['updatedAt'] ?? data['createdAt']),
      userEmail: data['userEmail'] ?? data['user']?['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'pinsCount': pinsCount,
      'slotsCount': slotsCount,
      'broadcastsCount': broadcastsCount,
      'totalCost': totalCost,
      'status': status.name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
