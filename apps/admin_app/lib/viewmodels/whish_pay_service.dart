import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class WhishPayService {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'us-central1');

  Future<Map<String, dynamic>> initializePayment({
    String? packageId,
    required String userId,
    required double amount,
    required String userType,
    String? packageName,
    String? customerEmail,
    String? customerName,
    int? visibilityNodes,
    int? serviceSlots,
    int? practicePins,
    int? broadcasts,
    String? sectorId,
    String? categoryId,
    String? returnUrl,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final result = await _functions.httpsCallable('initiateMembershipPayment').call({
        'packageId': packageId ?? 'custom_topup',
        'packageName': packageName ?? 'Custom Protocol Top-up',
        'userId': userId,
        'membershipId': userId, 
        'amount': amount,
        'userType': userType,
        'membershipType': userType, 
        'customerEmail': customerEmail,
        'customerName': customerName,
        'visibilityNodes': visibilityNodes,
        'serviceSlots': serviceSlots,
        'practicePins': practicePins,
        'broadcasts': broadcasts,
        'sectorId': sectorId,
        'categoryId': categoryId,
        'returnUrl': returnUrl,
        'metadata': metadata,
      });

      if (result.data != null && result.data['success'] == true) {
        return Map<String, dynamic>.from(result.data);
      } else {
        throw Exception(result.data['error'] ?? 'Failed to initialize payment');
      }
    } catch (e) {
      debugPrint('WhishPay Error: $e');
      rethrow;
    }
  }

  Future<bool> verifyPayment(String transactionId) async {
    try {
      final result = await _functions.httpsCallable('verifyWhishPayment').call({
        'transactionId': transactionId,
      });

      if (result.data != null && result.data['success'] == true) {
        return result.data['status'] == 'completed';
      }
      return false;
    } catch (e) {
      debugPrint('Payment Verification Error: $e');
      return false;
    }
  }
}
