import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

class WalletTransactionModel {
  final String id;
  final String userId;
  final int amount;
  final TransactionType type;
  final String? referenceId;
  final String? description;
  final DateTime createdAt;

  WalletTransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    this.referenceId,
    this.description,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromMap(Map<String, dynamic> data) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is DateTime) return val;
      return DateTime.tryParse(val.toString()) ?? DateTime.now();
    }

    return WalletTransactionModel(
      id: data['id']?.toString() ?? '',
      userId: data['userId'] ?? data['user_id'] ?? '',
      amount: data['amount'] ?? 0,
      type: TransactionType.parse(data['type']),
      referenceId: data['referenceId'],
      description: data['description'],
      createdAt: parseDate(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type.name,
      'referenceId': referenceId,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
