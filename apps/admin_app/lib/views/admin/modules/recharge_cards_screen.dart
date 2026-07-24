import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_core/espy_core.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/recharge_cards_view_model.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';
import '../../../widgets/common/premium_button.dart';

class RechargeCardsScreen extends StatelessWidget {
  const RechargeCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RechargeCardsViewModel(context.read<EspyRepository>()),
      child: const _RechargeCardsView(),
    );
  }
}

class _RechargeCardsView extends StatelessWidget {
  const _RechargeCardsView();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RechargeCardsViewModel>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("RECHARGE CARD GEN", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: Column(
        children: [
          _buildGeneratorAction(context, viewModel),
          const Divider(height: 1),
          Expanded(child: _buildCardsList(viewModel)),
        ],
      ),
    );
  }

  Widget _buildGeneratorAction(BuildContext context, RechargeCardsViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: PremiumButton(
        label: vm.isGenerating ? "GENERATING..." : "GENERATE NEW BATCH",
        fullWidth: true,
        variant: PremiumButtonVariant.gold,
        onPressed: vm.isGenerating ? null : () => _showGenDialog(context, vm),
      ),
    );
  }

  Widget _buildCardsList(RechargeCardsViewModel vm) {
    if (vm.isLoading) return const Center(child: CircularProgressIndicator());
    if (vm.cards.isEmpty) return const Center(child: Text("NO CARDS GENERATED"));

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: vm.cards.length,
      itemBuilder: (context, index) {
        final card = vm.cards[index];
        final bool isUsed = card['status'] == 'used';

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PremiumCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(LucideIcons.qrCode, color: isUsed ? Colors.black26 : EspyTheme.royalBlue),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card['id'], style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
                      Text("${card['tokenValue']} \$E", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: EspyTheme.gold)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: isUsed ? Colors.red.withValues(alpha: 0.1) : EspyTheme.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(isUsed ? "USED" : "ACTIVE", style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: isUsed ? Colors.red : EspyTheme.success)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGenDialog(BuildContext context, RechargeCardsViewModel vm) {
    int value = 1000;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("GENERATE PROTOCOL CARD"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Token Value (\$E)"),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (v) => value = int.tryParse(v) ?? 1000,
              decoration: const InputDecoration(hintText: "1000"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () {
              vm.generateCard(value: value);
              Navigator.pop(context);
            },
            child: const Text("GENERATE"),
          ),
        ],
      ),
    );
  }
}
