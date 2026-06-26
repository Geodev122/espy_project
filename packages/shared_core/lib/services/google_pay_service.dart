import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:pay/pay.dart';

class GooglePayService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // The 'pay' package version 3.x uses Map<PayProvider, PaymentConfiguration>
  late final Pay _payClient;

  GooglePayService() {
    _payClient = Pay({
      PayProvider.google_pay: PaymentConfiguration.fromJsonString(_defaultGooglePayConfig)
    });
  }

  static const String _defaultGooglePayConfig = '''{
    "provider": "google_pay",
    "data": {
      "environment": "TEST",
      "apiVersion": 2,
      "apiVersionMinor": 0,
      "allowedPaymentMethods": [
        {
          "type": "CARD",
          "tokenizationSpecification": {
            "type": "PAYMENT_GATEWAY",
            "parameters": {
              "gateway": "example",
              "gatewayMerchantId": "exampleGatewayMerchantId"
            }
          },
          "parameters": {
            "allowedCardNetworks": ["VISA", "MASTERCARD"],
            "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
            "billingAddressRequired": true,
            "billingAddressParameters": {
              "format": "FULL",
              "phoneNumberRequired": true
            }
          }
        }
      ],
      "merchantInfo": {
        "merchantId": "01234567890123456789",
        "merchantName": "Espy Protocol"
      },
      "transactionInfo": {
        "defaultCountryCode": "LB",
        "currencyCode": "USD"
      }
    }
  }''';

  Future<Map<String, dynamic>> processPayment({
    required String userId,
    required double amount,
    required String userType,
    required Map<String, dynamic> paymentData,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final result = await _functions.httpsCallable('processGooglePayPayment').call({
        'userId': userId,
        'amount': amount,
        'userType': userType,
        'paymentToken': paymentData['paymentMethodData']['tokenizationData']['token'],
        'metadata': metadata,
        'paymentDetails': paymentData,
      });

      if (result.data != null && result.data['success'] == true) {
        return Map<String, dynamic>.from(result.data);
      } else {
        throw Exception(result.data['error'] ?? 'Failed to process Google Pay payment');
      }
    } catch (e) {
      debugPrint('Google Pay Error: $e');
      rethrow;
    }
  }

  Future<bool> isAvailable() async {
     try {
       return await _payClient.userCanPay(PayProvider.google_pay);
     } catch (e) {
       return false;
     }
  }
}
