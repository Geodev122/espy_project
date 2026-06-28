import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../services/firestore_service.dart';
import '../../widgets/common/admin_settings_table.dart';
import '../../providers/system_providers.dart';
import 'sync_debugger_page.dart';
import 'token_management_page.dart';

class SystemPage extends ConsumerStatefulWidget {
  const SystemPage({super.key});

  @override
  ConsumerState<SystemPage> createState() => _SystemPageState();
}

class _SystemPageState extends ConsumerState<SystemPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabs(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildInfrastructureView(),
              TokenManagementPage(),
              const SyncDebuggerPage(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05)))),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: EspyTheme.electricBlue,
        dividerColor: Colors.transparent,
        labelStyle: EspyTheme.cinzelStyle.copyWith(fontSize: 11, fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'INFRASTRUCTURE'),
          Tab(text: 'TOKEN & REDEMPTION'),
          Tab(text: 'THE GUARDIAN (SYNC DEBUGGER)'),
        ],
      ),
    );
  }

  Widget _buildInfrastructureView() {
    final asyncCountries = ref.watch(countriesFutureProvider);
    final asyncSectors = ref.watch(sectorsFutureProvider);
    final asyncGovernorates = ref.watch(governoratesFutureProvider);
    final asyncCities = ref.watch(citiesFutureProvider);
    final asyncCategories = ref.watch(categoriesFutureProvider);

    return ListView(
      padding: const EdgeInsets.all(40),
      children: [
        _buildSectionHeader('NETWORK MINT & PRICING'),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildTokenPricingTable()),
            const SizedBox(width: 24),
            Expanded(child: _buildMintingTerminal()),
          ],
        ),
        const SizedBox(height: 48),
        _buildSectionHeader('GLOBAL ANCHORS', subtitle: 'Manage geographical hierarchy and system sectors'),
        const SizedBox(height: 24),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
                try {
                  await ref.read(firestoreServiceProvider).syncAndCleanAnchors();
                  ref.invalidate(countriesFutureProvider);
                  ref.invalidate(governoratesFutureProvider);
                  ref.invalidate(citiesFutureProvider);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ecosystem Hierarchy Re-anchored Successfully.'))
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Migration Failed: $e'))
                    );
                  }
                }
              },
              icon: const Icon(LucideIcons.refreshCcw, size: 16),
              label: const Text('SYNC & RE-ANCHOR ECOSYSTEM'),
              style: ElevatedButton.styleFrom(
                backgroundColor: EspyTheme.electricBlue.withOpacity(0.1),
                foregroundColor: EspyTheme.electricBlue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        asyncCountries.when(
          data: (data) => AdminSettingsTable(
            title: 'H1: NATION STATES (COUNTRIES)',
            collection: 'directory_countries',
            columns: const ['Name EN', 'Name AR', 'Code', 'Currency'],
            data: data,
          ),
          loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
          error: (e, s) => Text('Error: $e'),
        ),
        const SizedBox(height: 32),
        asyncGovernorates.when(
          data: (data) => AdminSettingsTable(
            title: 'H2: REGIONAL GOVERNORATES',
            collection: 'directory_governorates',
            columns: const ['Name EN', 'Name AR', 'Country ID'],
            data: data,
          ),
          loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
          error: (e, s) => Text('Error: $e'),
        ),
        const SizedBox(height: 32),
        asyncCities.when(
          data: (data) => AdminSettingsTable(
            title: 'H3: DIRECTORY CITIES',
            collection: 'directory_cities',
            columns: const ['Name EN', 'Name AR', 'Country ID', 'Governorate ID'],
            data: data,
          ),
          loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
          error: (e, s) => Text('Error: $e'),
        ),
        const SizedBox(height: 48),
        _buildSectionHeader('SYSTEM SECTORS & CATEGORIES'),
        const SizedBox(height: 24),
        asyncSectors.when(
          data: (data) => AdminSettingsTable(
            title: 'DIRECTORY SECTORS',
            collection: 'directory_sectors',
            columns: const ['Name EN', 'Name AR'],
            data: data,
          ),
          loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
          error: (e, s) => Text('Error loading sectors: $e'),
        ),
        const SizedBox(height: 32),
        asyncCategories.when(
          data: (data) => AdminSettingsTable(
            title: 'PROFESSIONAL CATEGORIES',
            collection: 'directory_categories',
            columns: const ['Name EN', 'Name AR'],
            data: data.where((c) => c['type'] == 'professional_category').toList(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Text('Error: $e'),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: EspyTheme.cinzelStyle.copyWith(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle ?? 'Unified management of system PINs and geographical anchors',
          style: EspyTheme.loraStyle.copyWith(fontSize: 14, color: Colors.white38),
        ),
      ],
    );
  }

  Widget _buildTokenPricingTable() {
    final asyncPricing = ref.watch(tokenPricingStreamProvider);

    return asyncPricing.when(
      data: (pricing) => Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('GLOBAL TOKEN PRICING', style: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: Colors.white24)),
                  Icon(LucideIcons.edit, size: 14, color: EspyTheme.gold),
                ],
              ),
              const SizedBox(height: 20),
              _buildPricingField('pro_new_pin', 'PRO: NEW PIN', pricing),
              _buildPricingField('pro_renew_pin', 'PRO: RENEW PIN', pricing),
              _buildPricingField('pro_new_slot', 'PRO: NEW SLOT', pricing),
              _buildPricingField('inst_new_pin', 'INST: NEW PIN', pricing),
              _buildPricingField('broadcast', 'BROADCAST', pricing),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          SizedBox(
            width: 80,
            height: 30,
            child: TextField(
              controller: ctrl,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 12, color: EspyTheme.gold),
              onSubmitted: (val) {
                final newValue = int.tryParse(val);
                if (newValue != null) {
                  ref.read(firestoreServiceProvider).updateTokenPricing({key: newValue});
                }
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                filled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMintingTerminal() {
    final labelCtrl = TextEditingController();
    final valueCtrl = TextEditingController(text: '1000');
    final countCtrl = TextEditingController(text: '10');
    String targetRole = 'professional';

    return StatefulBuilder(
      builder: (context, setModalState) => Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MINTING TERMINAL', style: EspyTheme.cinzelStyle.copyWith(fontSize: 10, color: Colors.white24)),
              const SizedBox(height: 20),
              TextField(
                controller: labelCtrl,
                decoration: const InputDecoration(labelText: 'BATCH LABEL', hintText: 'e.g. SILVER_PRO_10'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: valueCtrl,
                      decoration: const InputDecoration(labelText: 'TOKEN VALUE'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: countCtrl,
                      decoration: const InputDecoration(labelText: 'CARD COUNT'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: targetRole,
                items: const [
                  DropdownMenuItem(value: 'professional', child: Text('PROFESSIONAL')),
                  DropdownMenuItem(value: 'institution', child: Text('INSTITUTION')),
                  DropdownMenuItem(value: 'any', child: Text('ANY ROLE')),
                ],
                onChanged: (v) => targetRole = v!,
                decoration: const InputDecoration(labelText: 'TARGET ROLE'),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  await ref.read(firestoreServiceProvider).mintRechargeCards(
                    batchLabel: labelCtrl.text,
                    count: int.parse(countCtrl.text),
                    tokenValue: int.parse(valueCtrl.text),
                    targetRole: targetRole,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Codes generated successfully')));
                    labelCtrl.clear();
                  }
                },
                icon: const Icon(LucideIcons.zap, size: 16),
                label: const Text('GENERATE CODES'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: EspyTheme.gold,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
