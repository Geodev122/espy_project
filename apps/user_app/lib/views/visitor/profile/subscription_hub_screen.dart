import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_core/espy_core.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';

class SubscriptionHubScreen extends StatefulWidget {
  const SubscriptionHubScreen({super.key});

  @override
  State<SubscriptionHubScreen> createState() => _SubscriptionHubScreenState();
}

class _SubscriptionHubScreenState extends State<SubscriptionHubScreen> {
  @override
  Widget build(BuildContext context) {
    final walletVM = Provider.of<WalletViewModel>(context);
    final l10n = AppLocalizations.of(context)!;

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text(l10n.vaultSubscriptions.toUpperCase()),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildBalanceHeader(walletVM),
                   const SizedBox(height: 32),
                   _buildExpansionStore(walletVM),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceHeader(WalletViewModel vm) {
    return PremiumCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Text('CURRENT BALANCE', style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('${vm.balance} \$E', style: GoogleFonts.montserrat(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildExpansionStore(WalletViewModel vm) {
    // This could be populated from a settings repository
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AVAILABLE EXPANSIONS', style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 2)),
        const SizedBox(height: 16),
        _buildStoreItem('30-DAY VISIBILITY', 500, vm),
        const SizedBox(height: 12),
        _buildStoreItem('EXTRA SERVICE SLOT', 300, vm),
        const SizedBox(height: 12),
        _buildStoreItem('ADDITIONAL MAP NODE', 400, vm),
      ],
    );
  }

  Widget _buildStoreItem(String label, int cost, WalletViewModel vm) {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 12)),
          PremiumButton(
            label: '$cost \$E',
            size: PremiumButtonSize.small,
            onPressed: vm.balance >= cost ? () {} : null,
          ),
        ],
      ),
    );
  }
}
