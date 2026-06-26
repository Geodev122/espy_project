import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../l10n/app_localizations.dart';
import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/services/whish_pay_service.dart';
import 'package:shared_core/services/google_pay_service.dart';
import 'package:shared_core/services/user_service.dart';
import 'package:shared_core/models/user_model.dart';

import '../../widgets/common/premium_card.dart';
import '../../widgets/common/premium_button.dart';

class SubscriptionHubScreen extends StatefulWidget {
  const SubscriptionHubScreen({super.key});

  @override
  State<SubscriptionHubScreen> createState() => _SubscriptionHubScreenState();
}

class _SubscriptionHubScreenState extends State<SubscriptionHubScreen> {
  final FirestoreService _firestore = FirestoreService();

  int _extraVisibilityMonths = 1;
  int _extraSlots = 0;
  int _extraPins = 0;
  int _extraBroadcasts = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final String? userId = auth.user?.uid;
    final l10n = AppLocalizations.of(context)!;
    final user = auth.userData;

    return Scaffold(
      backgroundColor: EspyTheme.platinum,
      appBar: AppBar(
        title: Text(l10n.vaultSubscriptions.toUpperCase()),
      ),
      body: userId == null || user == null
          ? const Center(child: Text('Sign in to view your vault'))
          : Container(
              decoration: const BoxDecoration(gradient: EspyTheme.lightBlueFlame),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('directory_settings').doc('unit_pricing').snapshots(),
                builder: (context, pricingSnap) {
                  if (pricingSnap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: EspyTheme.gold));
                  }
                  
                  final pricing = pricingSnap.data?.data() as Map<String, dynamic>? ?? {};
                  final role = user.role.name;
                  final prefix = role == 'institution' ? 'inst_' : 'pro_';

                  final double visPrice = (pricing['${prefix}visibility_30d'] ?? 10.0).toDouble();
                  final double slotPrice = (pricing['${prefix}slot_unit'] ?? 5.0).toDouble();
                  final double pinPrice = (pricing['${prefix}pin_unit'] ?? 15.0).toDouble();
                  final double bcPrice = (pricing['${prefix}broadcast_unit'] ?? 20.0).toDouble();

                  final double total = (_extraVisibilityMonths * visPrice) +
                                       (_extraSlots * slotPrice) +
                                       (_extraPins * pinPrice) +
                                       (_extraBroadcasts * bcPrice);

                  return CustomScrollView(
                    slivers: [
                      _buildVaultStatusGears(l10n, user),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('RENEW OR EXPAND CAPABILITIES', style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 2)),
                              const SizedBox(height: 16),
                              PremiumCard(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    _buildSelectionRow(
                                      label: 'EXTEND VISIBILITY (30D BLOCKS)',
                                      price: visPrice,
                                      count: _extraVisibilityMonths,
                                      min: 0,
                                      onChanged: (v) => setState(() => _extraVisibilityMonths = v),
                                    ),
                                    const Divider(height: 32, color: Colors.black12),
                                    _buildSelectionRow(
                                      label: 'ADD SERVICE SLOTS (LIFETIME)',
                                      price: slotPrice,
                                      count: _extraSlots,
                                      onChanged: (v) => setState(() => _extraSlots = v),
                                    ),
                                    const Divider(height: 32, color: Colors.black12),
                                    _buildSelectionRow(
                                      label: 'ADD MAP NODES / PINS (LIFETIME)',
                                      price: pinPrice,
                                      count: _extraPins,
                                      onChanged: (v) => setState(() => _extraPins = v),
                                    ),
                                    const Divider(height: 32, color: Colors.black12),
                                    _buildSelectionRow(
                                      label: 'BROADCAST CREDITS',
                                      price: bcPrice,
                                      count: _extraBroadcasts,
                                      onChanged: (v) => setState(() => _extraBroadcasts = v),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              _buildCheckoutSummary(total, l10n, auth, {
                                'vis_price': visPrice,
                                'slot_price': slotPrice,
                                'pin_price': pinPrice,
                                'bc_price': bcPrice,
                              }),
                            ],
                          ),
                        ),
                      ),
                      _buildTransactionHistory(l10n, userId),
                      const SliverToBoxAdapter(child: SizedBox(height: 48)),
                    ],
                  );
                }
              ),
            ),
    );
  }

  Widget _buildSelectionRow({required String label, required double price, required int count, int min = 0, required Function(int) onChanged}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep.withValues(alpha: 0.5))),
              Text('\$${price.toStringAsFixed(0)} / UNIT', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.bold, color: EspyTheme.navyDeep)),
            ],
          ),
        ),
        Row(
          children: [
            _countBtn(Icons.remove, () { if (count > min) onChanged(count - 1); }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(count.toString(), style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w900)),
            ),
            _countBtn(Icons.add, () => onChanged(count + 1)),
          ],
        ),
      ],
    );
  }

  Widget _countBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: EspyTheme.navyDeep.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 14, color: EspyTheme.navyDeep),
      ),
    );
  }

  Widget _buildCheckoutSummary(double total, AppLocalizations l10n, AuthService auth, Map<String, double> unitPrices) {
    return PremiumCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL PROTOCOL COST', style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep.withValues(alpha: 0.4))),
              Text('\$${total.toStringAsFixed(2)}', style: GoogleFonts.cinzel(fontSize: 24, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep)),
            ],
          ),
          const SizedBox(height: 24),
          PremiumButton(
            label: 'PAY WITH WHISHPAY',
            fullWidth: true,
            onPressed: total <= 0 ? null : () => _handlePayment(total, auth, unitPrices),
          ),
          const SizedBox(height: 12),
          GooglePayButton(
            paymentConfiguration: PaymentConfiguration.fromJsonString('''{
              "provider": "google_pay",
              "data": {
                "environment": "TEST",
                "apiVersion": 2,
                "apiVersionMinor": 0,
                "allowedPaymentMethods": [{
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
                    "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"]
                  }
                }],
                "merchantInfo": {
                  "merchantId": "01234567890123456789",
                  "merchantName": "Espy Protocol"
                },
                "transactionInfo": {
                  "defaultCountryCode": "LB",
                  "currencyCode": "USD"
                }
              }
            }'''),
            paymentItems: [
              PaymentItem(
                label: 'Protocol Extension',
                amount: total.toStringAsFixed(2),
                status: PaymentItemStatus.final_price,
              )
            ],
            type: GooglePayButtonType.buy,
            margin: const EdgeInsets.only(top: 0),
            onPaymentResult: (data) => _handleGooglePayResult(data, total, auth, unitPrices),
            loadingIndicator: const Center(child: CircularProgressIndicator()),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Future<void> _handleGooglePayResult(Map<String, dynamic> paymentData, double total, AuthService auth, Map<String, double> unitPrices) async {
    final googlePay = GooglePayService();
    try {
      final items = [
        if (_extraVisibilityMonths > 0) {'type': 'Visibility Extension', 'qty': _extraVisibilityMonths, 'price': unitPrices['vis_price']! * _extraVisibilityMonths},
        if (_extraSlots > 0) {'type': 'Extra Service Slots', 'qty': _extraSlots, 'price': unitPrices['slot_price']! * _extraSlots},
        if (_extraPins > 0) {'type': 'Extra Map Nodes', 'qty': _extraPins, 'price': unitPrices['pin_price']! * _extraPins},
        if (_extraBroadcasts > 0) {'type': 'Broadcast Credits', 'qty': _extraBroadcasts, 'price': unitPrices['bc_price']! * _extraBroadcasts},
      ];

      final result = await googlePay.processPayment(
        userId: auth.user!.uid,
        amount: total,
        userType: auth.userData?.role.name ?? 'professional',
        paymentData: paymentData,
        metadata: {
          'items': items,
          'source': 'google_pay',
          'vis_months': _extraVisibilityMonths,
          'serviceSlots': _extraSlots,
          'practicePins': _extraPins,
          'broadcasts': _extraBroadcasts,
        }
      );

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Google Pay Protocol Verified Successfully')));
        await auth.fetchUserData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Pay Error: $e')));
    }
  }

  Future<void> _handlePayment(double amount, AuthService auth, Map<String, double> unitPrices) async {
    final whish = WhishPayService();
    try {
      final items = [
        if (_extraVisibilityMonths > 0) {'type': 'Visibility Extension', 'qty': _extraVisibilityMonths, 'price': unitPrices['vis_price']! * _extraVisibilityMonths},
        if (_extraSlots > 0) {'type': 'Extra Service Slots', 'qty': _extraSlots, 'price': unitPrices['slot_price']! * _extraSlots},
        if (_extraPins > 0) {'type': 'Extra Map Nodes', 'qty': _extraPins, 'price': unitPrices['pin_price']! * _extraPins},
        if (_extraBroadcasts > 0) {'type': 'Broadcast Credits', 'qty': _extraBroadcasts, 'price': unitPrices['bc_price']! * _extraBroadcasts},
      ];

      final result = await whish.initializePayment(
        userId: auth.user!.uid,
        amount: amount,
        userType: auth.userData?.role.name ?? 'professional',
        customerEmail: auth.user!.email,
        customerName: auth.userData?.name,
        packageName: 'Protocol Extension',
        visibilityNodes: 1, 
        serviceSlots: _extraSlots,
        practicePins: _extraPins,
        broadcasts: _extraBroadcasts, 
        returnUrl: kIsWeb ? Uri.base.origin : null,
        metadata: {
          'items': items,
          'vis_months': _extraVisibilityMonths,
          'serviceSlots': _extraSlots,
          'practicePins': _extraPins,
          'broadcasts': _extraBroadcasts,
        }
      );

      if (result['success'] == true && result['collectUrl'] != null) {
        if (!mounted) return;
        if (kIsWeb) {
          if (await canLaunchUrl(Uri.parse(result['collectUrl']))) {
            await launchUrl(Uri.parse(result['collectUrl']), mode: LaunchMode.externalApplication);
          }
        } else {
          _showPaymentPopup(result['collectUrl']);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Error: $e')));
      }
    }
  }

  void _showPaymentPopup(String url) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.contains('payment/return') || request.url.contains('payment/success')) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Protocol Finalized. Identity Synching...')));
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("SECURE PAYMENT TERMINAL", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep)),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(child: WebViewWidget(controller: controller)),
              Container(
                padding: const EdgeInsets.all(12),
                color: EspyTheme.platinum,
                child: Text(
                  "ENCRYPTED PROTOCOL INTERFACE",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(fontSize: 8, color: Colors.black26, letterSpacing: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVaultStatusGears(AppLocalizations l10n, UserModel userData) {
    return SliverToBoxAdapter(
      child: FadeInDown(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("PROTOCOL IDENTITY STATUS", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 2)),
              const SizedBox(height: 16),
              Consumer<UserService>(
                builder: (context, userService, child) {
                  final realData = userService.profile ?? userData.rawData;
                  
                  final bool isSuspended = realData['isActive'] == false;
                  
                  final dynamic visibilityExp = realData['visibilityExpiresAt'];
                  DateTime? expiryDate;
                  if (visibilityExp is Timestamp) {
                    expiryDate = visibilityExp.toDate();
                  } else if (visibilityExp is int) {
                    expiryDate = DateTime.fromMillisecondsSinceEpoch(visibilityExp);
                  } else if (visibilityExp is String) {
                    expiryDate = DateTime.tryParse(visibilityExp);
                  }
                  
                  final int daysLeft = expiryDate != null ? expiryDate.difference(DateTime.now()).inDays : 0;
                  final bool isVisible = daysLeft > 0;
                  
                  final int slots = realData['serviceSlots'] ?? (realData['role'] == 'institution' ? 5 : 2);
                  final int extraPins = realData['practicePins'] ?? 0;

                  return Column(
                    children: [
                      PremiumCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _buildGearRow(
                              icon: Icons.shield_rounded,
                              label: 'ACCOUNT STATUS',
                              value: isSuspended ? 'SUSPENDED' : 'ACTIVE',
                              statusColor: isSuspended ? EspyTheme.error : EspyTheme.success,
                              subtitle: isSuspended ? 'Access restricted by board' : 'Identity synchronized',
                            ),
                            const Divider(height: 32, color: Colors.black12),
                            _buildGearRow(
                              icon: Icons.visibility_rounded,
                              label: 'PROFILE VISIBILITY',
                              value: isVisible ? '${daysLeft + 1} DAYS REMAINING' : 'HIDDEN',
                              statusColor: isVisible ? EspyTheme.royalBlue : EspyTheme.error,
                              subtitle: isVisible ? 'Profile live in protocol search' : 'No active visibility units',
                            ),
                            const Divider(height: 32, color: Colors.black12),
                            _buildGearRow(
                              icon: Icons.medical_services_rounded,
                              label: 'SERVICE SLOTS',
                              value: '$slots UNITS',
                              statusColor: slots > 0 ? EspyTheme.navyDeep : Colors.black26,
                              subtitle: 'Active protocols capacity',
                            ),
                            const Divider(height: 32, color: Colors.black12),
                            _buildGearRow(
                              icon: Icons.push_pin_rounded,
                              label: 'MAP NODES',
                              value: '1 MAIN + $extraPins SECONDARY',
                              statusColor: extraPins >= 0 ? EspyTheme.navyDeep : Colors.black26,
                              subtitle: 'Active practice coordinates',
                            ),
                            const Divider(height: 32, color: Colors.black12),
                            _buildGearRow(
                              icon: Icons.broadcast_on_personal_rounded,
                              label: 'BROADCAST CREDITS',
                              value: '${(realData['broadcastsBought'] ?? 0) - (realData['broadcastsUsed'] ?? 0)} AVAILABLE',
                              statusColor: EspyTheme.gold,
                              subtitle: 'Global community outreach units',
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGearRow({required IconData icon, required String label, required String value, required Color statusColor, String? subtitle}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: statusColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.cinzel(fontSize: 8, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep.withValues(alpha: 0.4), letterSpacing: 1.5)),
              Text(value, style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w800, color: statusColor)),
              if (subtitle != null)
                Text(subtitle, style: GoogleFonts.lora(fontSize: 10, color: Colors.black38, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionHistory(AppLocalizations l10n, String userId) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestore.getUserTransactions(userId),
      builder: (context, snapshot) {
        final txs = snapshot.data ?? [];
        if (txs.isEmpty) return const SliverToBoxAdapter(child: SizedBox());

        return SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text('TRANSACTION HISTORY',
                        style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 2)),
                  );
                }
                final tx = txs[index - 1];
                return _buildTransactionRow(tx);
              },
              childCount: txs.length + 1,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionRow(Map<String, dynamic> tx) {
    final bool isFailed = tx['status'] == 'failed' || tx['status'] == 'rejected';
    final bool isCompleted = tx['status'] == 'completed';
    final date = tx['createdAt'] != null ? (tx['createdAt'] is Timestamp ? (tx['createdAt'] as Timestamp).toDate() : DateTime.tryParse(tx['createdAt'].toString())) : null;
    final dateStr = date != null ? DateFormat('dd MMM yyyy').format(date) : 'N/A';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isFailed ? EspyTheme.error.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isFailed ? EspyTheme.error.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(isFailed ? Icons.error_outline_rounded : (isCompleted ? Icons.verified_rounded : Icons.pending_actions_rounded),
              color: isFailed ? EspyTheme.error : (isCompleted ? EspyTheme.success : EspyTheme.gold), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (tx['packageName'] ?? 'Protocol Unit Top-up').toString().toUpperCase(),
                  style: GoogleFonts.cinzel(
                      fontWeight: FontWeight.bold, fontSize: 12, color: isFailed ? EspyTheme.error : EspyTheme.noir),
                ),
                const SizedBox(height: 4),
                Text(
                  "$dateStr • ${tx['status']?.toString().toUpperCase() ?? 'PENDING'}",
                  style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.black38),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${tx['amount'] ?? '0'}',
                style:
                    GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 16, color: isFailed ? EspyTheme.error : EspyTheme.noir),
              ),
              if (isCompleted)
                 Text('VERIFIED', style: GoogleFonts.cinzel(fontSize: 8, fontWeight: FontWeight.w900, color: EspyTheme.success)),
            ],
          ),
        ],
      ),
    );
  }
}
