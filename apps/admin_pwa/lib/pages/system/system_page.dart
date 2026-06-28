import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../services/firestore_service.dart';
import '../../widgets/common/admin_settings_table.dart';
import '../../widgets/common/admin_edit_master_modal.dart';
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
  String _infraCountryFilter = 'lebanon';
  String _infraRegionFilter = 'ALL';

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
    final asyncCountries = ref.watch(countriesStreamProvider);
    final asyncGovernorates = ref.watch(governoratesStreamProvider);
    final asyncCities = ref.watch(citiesStreamProvider);
    final asyncSectors = ref.watch(sectorsStreamProvider);
    final asyncCategories = ref.watch(categoriesStreamProvider);

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
        _buildSectionHeader('GEOGRAPHICAL HIERARCHY', subtitle: 'Manage Global -> Country -> Region -> City anchors'),
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
                  ref.invalidate(countriesStreamProvider);
                  ref.invalidate(governoratesStreamProvider);
                  ref.invalidate(citiesStreamProvider);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ecosystem Hierarchy Re-anchored and Deduplicated Successfully.'))
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
              label: const Text('FORCE SYNC & DEDUPLICATE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: EspyTheme.electricBlue.withOpacity(0.1),
                foregroundColor: EspyTheme.electricBlue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () => showDialog(context: context, builder: (_) => AdminEditMasterModal(collection: 'directory_countries', title: 'ADD NEW COUNTRY')),
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text('ADD COUNTRY'),
            ),
            const Spacer(),
            asyncCountries.maybeWhen(
              data: (countries) => DropdownButton<String>(
                value: countries.any((c) => c['id'] == _infraCountryFilter) ? _infraCountryFilter : (countries.isNotEmpty ? countries.first['id'] : 'ALL'),
                dropdownColor: const Color(0xFF061226),
                style: EspyTheme.cinzelStyle.copyWith(fontSize: 11, color: Colors.white),
                items: [
                  const DropdownMenuItem(value: 'ALL', child: Text('VIEW ALL COUNTRIES')),
                  ...countries.map((c) => DropdownMenuItem(value: c['id'], child: Text(c['name_en'].toString().toUpperCase()))),
                ],
                onChanged: (v) => setState(() { _infraCountryFilter = v!; _infraRegionFilter = 'ALL'; }),
              ),
              orElse: () => const SizedBox(),
            ),
          ],
        ),
        const SizedBox(height: 32),
        asyncCountries.when(
          data: (countries) {
            if (countries.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('NO COUNTRIES DEFINED. USE THE BUTTON ABOVE TO START EXPANDING.', style: TextStyle(color: Colors.white24, fontSize: 10)),
                ),
              );
            }
            return _buildHierarchicalTree(countries, asyncGovernorates.value ?? [], asyncCities.value ?? []);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text('HIERARCHY FETCH ERROR: $e', style: const TextStyle(color: Colors.redAccent, fontSize: 10)),
          ),
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

  Widget _buildHierarchicalTree(List<Map<String, dynamic>> countries, List<Map<String, dynamic>> govs, List<Map<String, dynamic>> cities) {
    // Audit Orphans
    final orphanGovs = govs.where((g) => !countries.any((c) => c['id'] == g['country_id'])).toList();
    final orphanCities = cities.where((city) => !govs.any((g) => g['id'] == city['governorate_id'])).toList();

    return Column(
      children: [
        ...countries.map((country) {
          final countryGovs = govs.where((g) => g['country_id'] == country['id']).toList();
          
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              shape: const Border(),
              leading: const Icon(LucideIcons.globe, color: EspyTheme.electricBlue, size: 18),
              title: Text(
                '${country['name_en']?.toString().toUpperCase() ?? 'UNKNOWN'} (${country['id']})',
                style: EspyTheme.cinzelStyle.copyWith(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${countryGovs.length} REGIONS IDENTIFIED', style: const TextStyle(fontSize: 10, color: Colors.white24)),
              trailing: IconButton(
                icon: const Icon(LucideIcons.plus, size: 16, color: EspyTheme.gold),
                onPressed: () => showDialog(
                  context: context, 
                  builder: (_) => AdminEditMasterModal(
                    collection: 'directory_governorates', 
                    title: 'NEW REGION FOR ${country['name_en']}',
                    item: {'country_id': country['id']},
                  )
                ),
              ),
              children: countryGovs.map((gov) {
                final govCities = cities.where((c) => c['governorate_id'] == gov['id']).toList();
                
                return Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: ExpansionTile(
                    shape: const Border(),
                    leading: const Icon(LucideIcons.map, color: EspyTheme.gold, size: 14),
                    title: Text(
                      gov['name_en']?.toString().toUpperCase() ?? 'UNKNOWN REGION',
                      style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${govCities.length} CITIES', style: const TextStyle(fontSize: 9, color: Colors.white24)),
                    trailing: IconButton(
                      icon: const Icon(LucideIcons.plus, size: 14, color: EspyTheme.cyan),
                      onPressed: () => showDialog(
                        context: context, 
                        builder: (_) => AdminEditMasterModal(
                          collection: 'directory_cities', 
                          title: 'NEW CITY FOR ${gov['name_en']}',
                          item: {'country_id': country['id'], 'governorate_id': gov['id']},
                        )
                      ),
                    ),
                    children: govCities.map((city) => ListTile(
                      contentPadding: const EdgeInsets.only(left: 64, right: 24),
                      leading: const Icon(LucideIcons.mapPin, color: EspyTheme.cyan, size: 12),
                      title: Text(city['name_en']?.toString() ?? 'Unnamed City', style: const TextStyle(fontSize: 11, color: Colors.white54)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(LucideIcons.edit, size: 12, color: Colors.white24),
                            onPressed: () => showDialog(context: context, builder: (_) => AdminEditMasterModal(collection: 'directory_cities', item: city, title: 'EDIT CITY')),
                          ),
                          IconButton(
                            icon: const Icon(LucideIcons.trash2, size: 12, color: Colors.redAccent),
                            onPressed: () => _handleDelete(city['id'], 'directory_cities'),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),

        if (orphanGovs.isNotEmpty || orphanCities.isNotEmpty) ...[
          const SizedBox(height: 32),
          _buildSectionHeader('SYSTEM ORPHANS (SUPERADMIN AUDIT)', subtitle: 'Data points with disconnected hierarchy links'),
          const SizedBox(height: 24),
          if (orphanGovs.isNotEmpty)
            AdminSettingsTable(title: 'ORPHAN REGIONS', collection: 'directory_governorates', columns: const ['Name EN', 'Country ID'], data: orphanGovs),
          const SizedBox(height: 16),
          if (orphanCities.isNotEmpty)
            AdminSettingsTable(title: 'ORPHAN CITIES', collection: 'directory_cities', columns: const ['Name EN', 'Gov ID'], data: orphanCities),
        ],
      ],
    );
  }

  Future<void> _handleDelete(String id, String collection) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF061226),
        title: const Text('CONFIRM DELETE'),
        content: const Text('Permanently remove this master data entry?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), child: const Text('DELETE')),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(firestoreServiceProvider).deleteItem(collection, id);
    }
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
