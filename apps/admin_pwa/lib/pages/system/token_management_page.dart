import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../services/firestore_service.dart';
import '../../providers/system_providers.dart';

class TokenManagementPage extends ConsumerStatefulWidget {
  const TokenManagementPage({super.key});

  @override
  ConsumerState<TokenManagementPage> createState() => _TokenManagementPageState();
}

class _TokenManagementPageState extends ConsumerState<TokenManagementPage> {
  @override
  Widget build(BuildContext context) {
    final asyncPricing = ref.watch(tokenPricingStreamProvider);

    return ListView(
      padding: const EdgeInsets.all(40),
      children: [
        _buildHeader('TOKEN GOVERNANCE', 'Manage global pricing, minting, and redemption protocols'),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildPricingSection(asyncPricing)),
            const SizedBox(width: 32),
            Expanded(flex: 3, child: _buildMintingSection()),
          ],
        ),
        const SizedBox(height: 48),
        _buildHeader('REDEMPTION ANALYTICS', 'Performance of minted token batches'),
        const SizedBox(height: 24),
        _buildAnalyticsSection(),
      ],
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: EspyTheme.cinzelStyle.copyWith(fontSize: 18, color: Colors.white)),
        const SizedBox(height: 8),
        Text(subtitle, style: EspyTheme.loraStyle.copyWith(fontSize: 14, color: Colors.white38)),
      ],
    );
  }

  Widget _buildPricingSection(AsyncValue<Map<String, dynamic>> asyncPricing) {
    return asyncPricing.when(
      data: (pricing) => Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r'GLOBAL PRICING ($E)', style: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: EspyTheme.gold)),
              const SizedBox(height: 24),
              _buildPricingField('new_pin', 'NEW PIN', pricing),
              _buildPricingField('renew_pin', 'RENEW PIN', pricing),
              _buildPricingField('new_slot', 'NEW SLOT', pricing),
              _buildPricingField('renew_slot', 'RENEW SLOT', pricing),
              _buildPricingField('broadcast', 'BROADCAST', pricing),
              _buildPricingField('renew_visibility', 'RENEW VISIBILITY', pricing),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Text('Error: $e'),
    );
  }

  Widget _buildPricingField(String key, String label, Map<String, dynamic> pricing) {
    final ctrl = TextEditingController(text: (pricing[key] ?? 0).toString());
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70)),
          SizedBox(
            width: 80,
            height: 30,
            child: TextField(
              controller: ctrl,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 12, color: EspyTheme.gold, fontWeight: FontWeight.bold),
              onSubmitted: (val) {
                final newValue = int.tryParse(val);
                if (newValue != null) {
                  ref.read(firestoreServiceProvider).updateTokenPricing({key: newValue});
                }
              },
              decoration: const InputDecoration(contentPadding: EdgeInsets.zero, border: InputBorder.none, filled: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMintingSection() {
    final labelCtrl = TextEditingController();
    final tokenValueCtrl = TextEditingController(text: '1000');
    final pinCountCtrl = TextEditingController(text: '0');
    final slotCountCtrl = TextEditingController(text: '0');
    final countCtrl = TextEditingController(text: '10');
    String targetRole = 'any';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MINTING TERMINAL', style: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: EspyTheme.gold)),
            const SizedBox(height: 24),
            TextField(
              controller: labelCtrl,
              decoration: const InputDecoration(labelText: 'BATCH LABEL', hintText: 'e.g. WELCOME_PACK_AUG'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextField(controller: tokenValueCtrl, decoration: const InputDecoration(labelText: 'TOKENS'), keyboardType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: TextField(controller: pinCountCtrl, decoration: const InputDecoration(labelText: 'EXTRA PINs'), keyboardType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: TextField(controller: slotCountCtrl, decoration: const InputDecoration(labelText: 'EXTRA SLOTs'), keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: targetRole,
                    items: const [
                      DropdownMenuItem(value: 'any', child: Text('ANY ROLE')),
                      DropdownMenuItem(value: 'professional', child: Text('PROFESSIONAL')),
                      DropdownMenuItem(value: 'institution', child: Text('INSTITUTION')),
                    ],
                    onChanged: (v) => targetRole = v!,
                    decoration: const InputDecoration(labelText: 'TARGET ROLE'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: TextField(controller: countCtrl, decoration: const InputDecoration(labelText: 'BATCH COUNT'), keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                await ref.read(firestoreServiceProvider).mintRechargeCards(
                  batchLabel: labelCtrl.text,
                  count: int.parse(countCtrl.text),
                  tokenValue: int.parse(tokenValueCtrl.text),
                  extraPins: int.parse(pinCountCtrl.text),
                  extraSlots: int.parse(slotCountCtrl.text),
                  targetRole: targetRole,
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Codes minted successfully')));
                }
              },
              icon: const Icon(LucideIcons.zap, size: 16),
              label: const Text('EXECUTE MINT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: EspyTheme.gold,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 2.5,
      children: [
        _buildStatCard('TOTAL MINTED', r'450,000 $E', LucideIcons.layers, EspyTheme.gold),
        _buildStatCard('TOTAL REDEEMED', r'125,400 $E', LucideIcons.checkCircle, Colors.green),
        _buildStatCard('REDEMPTION RATE', '27.8%', LucideIcons.trendingUp, EspyTheme.cyan),
        _buildStatCard('AVG COST / TOKEN', r'$0.008', LucideIcons.dollarSign, Colors.orange),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: EspyTheme.cinzelStyle.copyWith(fontSize: 9, color: Colors.white38)),
                Icon(icon, size: 12, color: color.withOpacity(0.5)),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: EspyTheme.cinzelStyle.copyWith(fontSize: 18, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
