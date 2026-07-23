import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/viewmodels/whish_pay_service.dart';
import 'package:espy_app/viewmodels/wallet_view_model.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import 'package:espy_app/l10n/app_localizations.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:pay/pay.dart';
import 'package:cloud_functions/cloud_functions.dart';

class TokenShopScreen extends StatefulWidget {
  final int initialTab;
  const TokenShopScreen({super.key, this.initialTab = 0});

  @override
  State<TokenShopScreen> createState() => _TokenShopScreenState();
}

class _TokenShopScreenState extends State<TokenShopScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _codeController = TextEditingController();

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
    final walletVM = Provider.of<WalletViewModel>(context);
    final l10n = AppLocalizations.of(context)!;

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text(l10n.espyStore.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1),
          tabs: [
            Tab(text: 'RECHARGE WALLET'),
            Tab(text: l10n.espyStore.toUpperCase()),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRechargeTab(context, walletVM, l10n),
          _buildStoreTab(context, walletVM, l10n),
        ],
      ),
    );
  }

  Widget _buildRechargeTab(BuildContext context, WalletViewModel vm, AppLocalizations l10n) {
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
        ...bundles.map((b) => _buildBundleCard(b, vm, l10n)).toList(),
        const SizedBox(height: 32),
        _buildSectionHeader('REDEMPTION CODE'),
        const SizedBox(height: 16),
        _buildCodeInput(vm, l10n),
      ],
    );
  }

  Widget _buildStoreTab(BuildContext context, WalletViewModel vm, AppLocalizations l10n) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('directory_settings').doc('token_pricing').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final pricing = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        final auth = Provider.of<AuthService>(context, listen: false);
        final role = auth.userData?.role.name ?? 'professional';
        
        final newItems = [
          {
            'id': 'extra_pin',
            'title': l10n.locationSettings.toUpperCase(),
            'desc': 'Unlock 1 additional map node.',
            'cost': pricing['new_pin'] ?? pricing['${role}_new_pin'] ?? 500,
            'icon': LucideIcons.mapPin,
          },
          {
            'id': 'extra_slot',
            'title': l10n.serviceSlots.toUpperCase(),
            'desc': 'Add 1 permanent slot.',
            'cost': pricing['new_slot'] ?? pricing['${role}_new_slot'] ?? 300,
            'icon': LucideIcons.layoutGrid,
          },
          {
            'id': 'broadcast',
            'title': l10n.broadcast.toUpperCase(),
            'desc': 'Send priority signal.',
            'cost': pricing['broadcast'] ?? pricing['${role}_broadcast'] ?? 1000,
            'icon': LucideIcons.radio,
          },
        ];

        final renewItems = [
          {
            'id': 'renew_pin',
            'title': 'RENEW PIN',
            'desc': 'Extend node visibility (30D).',
            'cost': pricing['renew_pin'] ?? pricing['${role}_renew_pin'] ?? 400,
            'icon': LucideIcons.rotateCcw,
          },
          {
            'id': 'renew_slot',
            'title': 'RENEW SLOT',
            'desc': 'Extend slot visibility (30D).',
            'cost': pricing['renew_slot'] ?? 250,
            'icon': LucideIcons.refreshCcw,
          },
        ];

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildSectionHeader('ACTIVATE NEW PROTOCOLS'),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: newItems.length,
              itemBuilder: (context, index) => _buildCompactStoreItem(newItems[index], vm, l10n, isRenew: false),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('RENEW CURRENT PROTOCOLS'),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: renewItems.length,
              itemBuilder: (context, index) => _buildCompactStoreItem(renewItems[index], vm, l10n, isRenew: true),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCompactStoreItem(Map<String, dynamic> item, WalletViewModel vm, AppLocalizations l10n, {bool isRenew = false}) {
    final bool canAfford = vm.balance >= (item['cost'] as int);
    final int remaining = vm.daysUntilExpiry;

    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isRenew ? EspyTheme.royalBlue.withValues(alpha: 0.1) : EspyTheme.gold.withValues(alpha: 0.1)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(item['icon'] as IconData, color: isRenew ? EspyTheme.royalBlue : EspyTheme.gold, size: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${item['cost']} \$E',
                      style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep),
                    ),
                    if (isRenew)
                      Text(
                        '$remaining DAYS LEFT',
                        style: GoogleFonts.montserrat(fontSize: 7, fontWeight: FontWeight.w800, color: remaining < 5 ? Colors.red : EspyTheme.gold),
                      ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Text(item['title'] as String, style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep, letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Text(item['desc'] as String, style: GoogleFonts.lora(fontSize: 8, color: Colors.black38, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: (canAfford && !vm.isProcessing) ? () => _handleSpend(item, vm, l10n) : null,
                style: TextButton.styleFrom(
                  backgroundColor: canAfford ? (isRenew ? EspyTheme.royalBlue : EspyTheme.gold) : Colors.black12,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: vm.isProcessing 
                  ? const SizedBox(height: 10, width: 10, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(
                      isRenew ? l10n.upgrade.toUpperCase() : l10n.continueText.toUpperCase(),
                      style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep.withValues(alpha: 0.5), letterSpacing: 2));
  }

  Widget _buildBundleCard(Map<String, dynamic> bundle, WalletViewModel vm, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: PremiumCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: EspyTheme.royalBlue.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(bundle['icon'] as IconData, color: EspyTheme.royalBlue, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bundle['label'] as String, style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w900)),
                  Text(l10n.espyTokens.replaceAll('{amount}', bundle['tokens'].toString()), style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold, color: EspyTheme.gold)),
                ],
              ),
            ),
            PremiumButton(
              label: '\$${bundle['price']}',
              size: PremiumButtonSize.small,
              onPressed: () => _handleWhishRecharge(bundle, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeInput(WalletViewModel vm, AppLocalizations l10n) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _codeController,
              decoration: InputDecoration(
                hintText: l10n.rechargeCard.toUpperCase(),
                border: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          PremiumButton(
            label: vm.isProcessing ? '...' : l10n.continueText.toUpperCase(),
            size: PremiumButtonSize.small,
            onPressed: vm.isProcessing ? null : () => _handleRedeem(vm, l10n),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRedeem(WalletViewModel vm, AppLocalizations l10n) async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    final result = await vm.redeemCode(code);
    if (mounted) {
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.successAddedTokens(result['added'].toString())), backgroundColor: EspyTheme.success),
        );
        _codeController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${result['error']}')));
      }
    }
  }

  Future<void> _handleWhishRecharge(Map<String, dynamic> bundle, AppLocalizations l10n) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final method = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EspyTheme.platinum,
        title: Text(l10n.selectPaymentMethod.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
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
              icon: Icons.payment_rounded,
              label: 'G-PAY',
              onTap: () => Navigator.pop(context, 'gpay'),
            ),
          ],
        ),
      ),
    );

    if (method == null) return;

    if (method == 'whish') {
      await _executeWhishPayment(bundle, auth, l10n);
    } else {
      await _executeGPayPayment(bundle, auth, l10n);
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
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
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

  Future<void> _executeWhishPayment(Map<String, dynamic> bundle, AuthService auth, AppLocalizations l10n) async {
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
                appBar: AppBar(title: Text(l10n.whishPaySecure.toUpperCase())),
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

  Future<void> _executeGPayPayment(Map<String, dynamic> bundle, AuthService auth, AppLocalizations l10n) async {
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

      final callable = FirebaseFunctions.instanceFor(region: 'us-central1').httpsCallable('processGooglePayPayment');
      await callable.call({
        'paymentResult': result,
        'userId': auth.user!.uid,
        'bundle': bundle,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.paymentCompleted.toUpperCase())));
        await auth.fetchUserData();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('G-Pay Error: $e')));
    }
  }

  Future<void> _handleSpend(Map<String, dynamic> item, WalletViewModel vm, AppLocalizations l10n) async {
    final result = await vm.spendTokens(itemId: item['id'], cost: item['cost']);
    if (mounted) {
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.successfullyActivated(item['title'])), backgroundColor: EspyTheme.success),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Purchase Error: ${result['error']}')));
      }
    }
  }
}
