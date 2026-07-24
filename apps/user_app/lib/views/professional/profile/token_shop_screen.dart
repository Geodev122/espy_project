import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

import 'package:espy_core/espy_core.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import 'package:espy_app/l10n/app_localizations.dart';

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
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
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
          isScrollable: true,
          labelStyle: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1),
          tabs: [
            Tab(text: 'RECHARGE'),
            Tab(text: 'PROTOCOLS'),
            Tab(text: 'HISTORY'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRechargeTab(context, walletVM, l10n),
          _buildStoreTab(context, walletVM, l10n),
          _buildHistoryTab(context, walletVM, l10n),
        ],
      ),
    );
  }

  Widget _buildRechargeTab(BuildContext context, WalletViewModel vm, AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSectionHeader('SELECT TOKEN BUNDLE'),
        const SizedBox(height: 16),
        if (vm.tokenPackages.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
        else
          ...vm.tokenPackages.map((b) => _buildBundleCard({
            'tokens': b['tokenCount'],
            'price': b['price'],
            'label': b['nameEn'],
            'icon': _getIconForTokens(b['tokenCount'] as int),
            'discount': b['discountRate'],
          }, vm, l10n)),
        const SizedBox(height: 32),
        _buildSectionHeader('REDEMPTION CODE'),
        const SizedBox(height: 16),
        _buildCodeInput(vm, l10n),
      ],
    );
  }

  IconData _getIconForTokens(int tokens) {
    if (tokens >= 10000) return LucideIcons.crown;
    if (tokens >= 5000) return LucideIcons.coins;
    return LucideIcons.gem;
  }

  Widget _buildBundleCard(Map<String, dynamic> bundle, WalletViewModel vm, AppLocalizations l10n) {
    final double discount = (bundle['discount'] ?? 0.0) * 100;
    final int tokens = bundle['tokens'] as int;
    
    // Tiered Styling
    Color tierColor = EspyTheme.royalBlue;
    String tierLabel = "STANDARD";
    if (tokens >= 10000) {
      tierColor = EspyTheme.gold;
      tierLabel = "PREMIUM";
    } else if (tokens >= 5000) {
      tierColor = Colors.grey;
      tierLabel = "SILVER";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 120,
        borderRadius: 24,
        blur: 10,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tierColor.withValues(alpha: 0.1), tierColor.withValues(alpha: 0.05)],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tierColor.withValues(alpha: 0.3), tierColor.withValues(alpha: 0.05)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: tierColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(bundle['icon'] as IconData, color: tierColor, size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tierLabel, style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w900, color: tierColor, letterSpacing: 2)),
                    Text(bundle['label'] as String, style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep)),
                    Text("${bundle['tokens']} \$E", style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w900, color: tierColor)),
                    if (discount > 0)
                      Text("${discount.toInt()}% BONUS INCLUDED", style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w900, color: Colors.green)),
                  ],
                ),
              ),
              PremiumButton(
                label: '\$${bundle['price']}',
                onPressed: () {}, 
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreTab(BuildContext context, WalletViewModel vm, AppLocalizations l10n) {
    final pricing = { for (var e in vm.elementPricing) e['id'] : e['tokenCost'] };
    
    final newItems = [
      {
        'id': 'extra_pin',
        'title': l10n.locationSettings.toUpperCase(),
        'desc': 'Unlock 1 additional map node.',
        'cost': pricing['PIN'] ?? 500,
        'icon': LucideIcons.mapPin,
      },
      {
        'id': 'extra_slot',
        'title': l10n.serviceSlots.toUpperCase(),
        'desc': 'Add 1 permanent slot.',
        'cost': pricing['SLOT'] ?? 300,
        'icon': LucideIcons.layoutGrid,
      },
      {
        'id': 'broadcast',
        'title': l10n.broadcast.toUpperCase(),
        'desc': 'Send priority signal.',
        'cost': pricing['BROADCAST'] ?? 1000,
        'icon': LucideIcons.radio,
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
          itemBuilder: (context, index) => _buildCompactStoreItem(newItems[index], vm, l10n),
        ),
      ],
    );
  }

  Widget _buildCompactStoreItem(Map<String, dynamic> item, WalletViewModel vm, AppLocalizations l10n) {
    final bool canAfford = vm.balance >= (item['cost'] as int);

    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: EspyTheme.gold.withValues(alpha: 0.1)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(item['icon'] as IconData, color: EspyTheme.gold, size: 20),
                Text(
                  '${item['cost']} \$E',
                  style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep),
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
                onPressed: (canAfford && !vm.isProcessing) ? () => {} : null,
                style: TextButton.styleFrom(
                  backgroundColor: canAfford ? EspyTheme.gold : Colors.black12,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: vm.isProcessing 
                  ? const SizedBox(height: 10, width: 10, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(
                      l10n.continueText.toUpperCase(),
                      style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab(BuildContext context, WalletViewModel vm, AppLocalizations l10n) {
    if (vm.isLoadingTransactions) return const Center(child: CircularProgressIndicator());
    if (vm.transactions.isEmpty) return Center(child: Text("NO TRANSACTION HISTORY", style: GoogleFonts.cinzel(color: Colors.black26, fontSize: 10)));

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: vm.transactions.length,
      itemBuilder: (context, index) {
        final t = vm.transactions[index];
        final bool isRecharge = t.type.name.toLowerCase() == 'recharge';
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PremiumCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(isRecharge ? Icons.add_circle : Icons.remove_circle, color: isRecharge ? Colors.green : Colors.orange, size: 16),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.description ?? 'PROTOCOL TRANSACTION', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 11)),
                      Text(DateFormat('dd MMM yyyy').format(t.createdAt), style: const TextStyle(fontSize: 9, color: Colors.black38)),
                    ],
                  ),
                ),
                Text("${t.amount} \$E", style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 14)),
                if (isRecharge) ...[
                   const SizedBox(width: 12),
                   IconButton(
                     icon: const Icon(Icons.picture_as_pdf, size: 18, color: Colors.red),
                     onPressed: () => {}, // Generate PDF
                   ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep.withValues(alpha: 0.5), letterSpacing: 2));
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
}
