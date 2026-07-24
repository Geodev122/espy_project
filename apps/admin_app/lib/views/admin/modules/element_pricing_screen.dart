import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_core/espy_core.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/element_pricing_view_model.dart';
import '../../../widgets/common/premium_button.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';

class ElementPricingScreen extends StatelessWidget {
  const ElementPricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ElementPricingViewModel(context.read<EspyRepository>()),
      child: const _ElementPricingView(),
    );
  }
}

class _ElementPricingView extends StatefulWidget {
  const _ElementPricingView();

  @override
  State<_ElementPricingView> createState() => _ElementPricingViewState();
}

class _ElementPricingViewState extends State<_ElementPricingView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ElementPricingViewModel>(context, listen: false).listenToElementPricing();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ElementPricingViewModel>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("PROTOCOL ELEMENT GOVERNANCE", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("NETWORK ELEMENT PRICING", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 18)),
            Text("Adjust token costs and validity periods for critical protocol features", style: GoogleFonts.lora(fontSize: 12, color: Colors.black45)),
            const SizedBox(height: 32),
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildPricingList(vm),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingList(ElementPricingViewModel vm) {
    final defaultIds = ['PIN', 'SLOT', 'BROADCAST', 'RENEW_PIN', 'RENEW_SLOT'];
    final existingIds = vm.pricings.map((p) => p['id']).toSet();
    
    // Merge existing with defaults for UI completeness
    final List<String> allIds = {...defaultIds, ...existingIds}.toList();

    return ListView.builder(
      itemCount: allIds.length,
      itemBuilder: (context, index) {
        final id = allIds[index];
        final pricing = vm.pricings.firstWhere((p) => p['id'] == id, orElse: () => {'id': id, 'tokenCost': 0, 'validityDays': 30});
        return _buildPricingCard(pricing, vm);
      },
    );
  }

  Widget _buildPricingCard(Map<String, dynamic> p, ElementPricingViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: PremiumCard(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: EspyTheme.royalBlue.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(_getIconForId(p['id']), color: EspyTheme.royalBlue),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p['id'].toString().replaceAll('_', ' '), style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 14)),
                  Text("Validity: ${p['validityDays']} Days", style: const TextStyle(fontSize: 12, color: Colors.black38)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${p['tokenCost']} \$E", style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 18, color: EspyTheme.gold)),
                const SizedBox(height: 4),
                Text("TOKEN COST", style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black26)),
              ],
            ),
            const SizedBox(width: 32),
            PremiumButton(
              label: "ADJUST",
              variant: PremiumButtonVariant.outline,
              onPressed: () => _showPricingDialog(context, p, vm),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForId(String id) {
    if (id.contains('PIN')) return Icons.location_on;
    if (id.contains('SLOT')) return Icons.grid_view;
    if (id.contains('BROADCAST')) return Icons.podcasts;
    return Icons.settings_input_component;
  }

  void _showPricingDialog(BuildContext context, Map<String, dynamic> p, ElementPricingViewModel vm) {
    final cost = TextEditingController(text: p['tokenCost'].toString());
    final days = TextEditingController(text: p['validityDays'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ADJUST ${p['id']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: cost, decoration: const InputDecoration(labelText: "Token Cost"), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: days, decoration: const InputDecoration(labelText: "Validity (Days)"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () async {
              await vm.updatePricing(
                p['id'], 
                int.tryParse(cost.text) ?? 0, 
                validityDays: int.tryParse(days.text),
              );
              if (mounted) Navigator.pop(context);
            },
            child: const Text("SAVE"),
          ),
        ],
      ),
    );
  }
}
