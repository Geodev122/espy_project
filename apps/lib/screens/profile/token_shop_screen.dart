import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:espy_pro/core/theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/whish_pay_service.dart';
import 'package:espy_pro/widgets/common/premium_card.dart';
import 'package:espy_pro/widgets/common/premium_button.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:pay/pay.dart';

class TokenShopScreen extends StatefulWidget {
  final int initialTab;
  const TokenShopScreen({super.key, this.initialTab = 0});

  @override
  State<TokenShopScreen> createState() => _TokenShopScreenState();
}

class _TokenShopScreenState extends State<TokenShopScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _codeController = TextEditingController();
  bool _isRedeeming = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: EspyTheme.platinum,
      appBar: AppBar(
        title: Text('ESPY STORE', style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1),
          tabs: const [
            Tab(text: 'RECHARGE WALLET'),
            Tab(text: 'ESPY STORE'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRechargeTab(context, auth),
          _buildStoreTab(context, auth),
        ],
      ),
    );
  }

  Widget _buildRechargeTab(BuildContext context, AuthService auth) {
    final bundles = [
      {'tokens': 1000, 'price': 10, 'label': 'SILVER BUNDLE', 'icon': LucideIcons.gem},
      {'tokens': 5000, 'price': 45, 'label': 'GOLD BUNDLE', 'icon': LucideIcons.coins},
      {'tokens': 12000, 'price': 100, 'label': 'PLATINUM BUNDLE', 'icon': LucideIcons.crown},
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSectionHeader('SELECT TOKEN BUNDLE'),
        const SizedBox(height: 16),
        ...bundles.map((b) => _buildBundleCard(b, auth)).toList(),
        const SizedBox(height: 32),
        _buildSectionHeader('REDEMPTION CODE'),
        const SizedBox(height: 16),
        _buildCodeInput(auth),
      ],
    );
  }

  Widget _buildStoreTab(BuildContext context, AuthService auth) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('directory_settings').doc('token_pricing').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final pricing = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        final role = auth.userData?.role.name ?? 'professional';
        
        final items = [
          {
            'id': 'extra_pin',
            'title': 'NEW PIN',
            'desc': 'Unlock 1 additional location PIN on the public map.',
            'cost': pricing['new_pin'] ?? pricing['${role}_new_pin'] ?? 500,
            'icon': LucideIcons.mapPin,
          },
          {
            'id': 'renew_pin',
            'title': 'RENEW PIN (30D)',
            'desc': 'Extend 1 existing location PIN for another 30 days.',
            'cost': pricing['renew_pin'] ?? pricing['${role}_renew_pin'] ?? 400,
            'icon': LucideIcons.rotateCcw,
          },
          {
            'id': 'extra_slot',
            'title': 'NEW SLOT',
            'desc': 'Add 1 permanent slot to your service directory.',
            'cost': pricing['new_slot'] ?? pricing['${role}_new_slot'] ?? 300,
            'icon': LucideIcons.layoutGrid,
          },
          {
            'id': 'renew_slot',
            'title': 'RENEW SLOT (30D)',
            'desc': 'Extend 1 service slot visibility for another 30 days.',
            'cost': pricing['renew_slot'] ?? 250,
            'icon': LucideIcons.refreshCcw,
          },
          {
            'id': 'broadcast',
            'title': 'NEW BROADCAST',
            'desc': 'Send a priority signal to all visitors in the network.',
            'cost': pricing['broadcast'] ?? pricing['${role}_broadcast'] ?? 1000,
            'icon': LucideIcons.radio,
          },
        ];

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: items.length,
          itemBuilder: (context, index) => _buildStoreItem(items[index], auth),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep.withOpacity(0.5), letterSpacing: 2));
  }

  Widget _buildBundleCard(Map<String, dynamic> bundle, AuthService auth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: PremiumCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: EspyTheme.royalBlue.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(bundle['icon'] as IconData, color: EspyTheme.royalBlue, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bundle['label'] as String, style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w900)),
                  Text('${bundle['tokens']} ESPY TOKENS', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold, color: EspyTheme.gold)),
                ],
              ),
            ),
            PremiumButton(
              label: '\$${bundle['price']}',
              size: PremiumButtonSize.small,
              onPressed: () => _handleWhishRecharge(bundle, auth),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreItem(Map<String, dynamic> item, AuthService auth) {
    final balance = auth.userData?.walletBalance ?? 0;
    final bool canAfford = balance >= (item['cost'] as int);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: PremiumCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(item['icon'] as IconData, color: EspyTheme.navyDeep, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(item['title'] as String, style: GoogleFonts.cinzel(fontSize: 11, fontWeight: FontWeight.w900))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: EspyTheme.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('${item['cost']} \$E', style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w900, color: EspyTheme.gold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(item['desc'] as String, style: GoogleFonts.lora(fontSize: 11, color: Colors.black54)),
            const SizedBox(height: 20),
            PremiumButton(
              label: 'ACTIVATE ITEM',
              fullWidth: true,
              variant: canAfford ? PremiumButtonVariant.gold : PremiumButtonVariant.platinum,
              onPressed: canAfford ? () => _handleSpend(item, auth) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeInput(AuthService auth) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                hintText: 'ENTER RECHARGE CODE',
                border: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          PremiumButton(
            label: _isRedeeming ? '...' : 'REDEEM',
            size: PremiumButtonSize.small,
            onPressed: _isRedeeming ? null : () => _handleRedeem(auth),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRedeem(AuthService auth) async {
    if (_codeController.text.trim().isEmpty) return;

    setState(() => _isRedeeming = true);
    try {
      final result = await FirebaseFunctions.instanceFor(region: 'us-central1').httpsCallable('redeemRechargeCode').call({
        'userId': auth.user!.uid,
        'code': _codeController.text.trim(),
      });

      if (mounted) {
        if (result.data != null && result.data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('SUCCESS! ADDED ${result.data['added']} TOKENS'), backgroundColor: EspyTheme.success),
          );
          _codeController.clear();
          await auth.fetchUserData();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isRedeeming = false);
    }
  }

  Future<void> _handleWhishRecharge(Map<String, dynamic> bundle, AuthService auth) async {
    final method = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EspyTheme.platinum,
        title: Text('SELECT PAYMENT METHOD', style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPaymentMethodOption(
              icon: Icons.account_balance_wallet_rounded,
              label: 'WHISH PAY',
              onTap: () => Navigator.pop(context, 'whish'),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodOption(
              icon: Icons.google,
              label: 'G-PAY',
              onTap: () => Navigator.pop(context, 'gpay'),
            ),
          ],
        ),
      ),
    );

    if (method == null) return;

    if (method == 'whish') {
      await _executeWhishPayment(bundle, auth);
    } else {
      await _executeGPayPayment(bundle, auth);
    }
  }

  Widget _buildPaymentMethodOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: EspyTheme.royalBlue, size: 20),
            const SizedBox(width: 16),
            Text(label, style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 11)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: Colors.black26),
          ],
        ),
      ),
    );
  }

  Future<void> _executeWhishPayment(Map<String, dynamic> bundle, AuthService auth) async {
    final whish = WhishPayService();
    try {
      final result = await whish.initializePayment(
        userId: auth.user!.uid,
        amount: (bundle['price'] as int).toDouble(),
        userType: auth.userData?.role.name ?? 'professional',
        packageName: bundle['label'] as String,
        customerEmail: auth.user!.email,
        metadata: {
          'type': 'token_recharge',
          'tokens': bundle['tokens'],
        }
      );
      
      if (result['success'] == true && result['collectUrl'] != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('WHISH PAY SECURE')),
                body: WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..loadRequest(Uri.parse(result['collectUrl'])),
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _executeGPayPayment(Map<String, dynamic> bundle, AuthService auth) async {
    // Logic for G-Pay using pay package
    final _payClient = Pay({
      PayProvider.google_pay: PaymentConfiguration.fromJsonString(
        '''{
          "provider": "google_pay",
          "data": {
            "environment": "PRODUCTION",
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
        }'''
      ),
    });

    try {
      final result = await _payClient.showPaymentSelector(
        PayProvider.google_pay,
        [
          PaymentItem(
            label: bundle['label'],
            amount: bundle['price'].toString(),
            status: PaymentItemStatus.final_price,
          )
        ],
      );

      // Process the result with backend
      final callable = FirebaseFunctions.instanceFor(region: 'us-central1').httpsCallable('processGooglePayPayment');
      await callable.call({
        'paymentResult': result,
        'userId': auth.user!.uid,
        'bundle': bundle,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PAYMENT COMPLETED')));
        await auth.fetchUserData();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('G-Pay Error: $e')));
    }
  }

  Future<void> _handleSpend(Map<String, dynamic> item, AuthService auth) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator(color: EspyTheme.gold)),
      );

      final result = await FirebaseFunctions.instanceFor(region: 'us-central1').httpsCallable('spendTokens').call({
        'userId': auth.user!.uid,
        'itemId': item['id'],
        'cost': item['cost'],
        'role': auth.userData?.role.name ?? 'professional',
      });

      if (mounted) Navigator.pop(context);

      if (result.data != null && result.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('SUCCESSFULLY ACTIVATED ${item['title']}'),
            backgroundColor: EspyTheme.success,
          ),
        );
        await auth.fetchUserData();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Purchase Error: $e')));
      }
    }
  }
}
