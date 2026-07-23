import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/espy_repository.dart';
import '../../../viewmodels/taxonomy_view_model.dart';
import '../../../widgets/common/premium_button.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';
import '../../../widgets/common/espy_icon.dart';

import '../../../viewmodels/audit_view_model.dart';

class TaxonomyManagerScreen extends StatelessWidget {
  const TaxonomyManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaxonomyViewModel(context.read<EspyRepository>())),
        ChangeNotifierProvider(create: (context) => AuditViewModel(context.read<EspyRepository>())),
      ],
      child: const _TaxonomyManagerView(),
    );
  }
}

class _TaxonomyManagerView extends StatefulWidget {
  const _TaxonomyManagerView();

  @override
  State<_TaxonomyManagerView> createState() => _TaxonomyManagerViewState();
}

class _TaxonomyManagerViewState extends State<_TaxonomyManagerView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaxonomyViewModel>(context);
    final auditVM = Provider.of<AuditViewModel>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("TAXONOMY PROTOCOLS", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
        bottom: TabBar(
          controller: _tabController,
          labelColor: EspyTheme.royalBlue,
          unselectedLabelColor: Colors.black38,
          indicatorColor: EspyTheme.royalBlue,
          tabs: const [
            Tab(text: "GEOGRAPHY"),
            Tab(text: "SECTORS"),
            Tab(text: "METADATA"),
            Tab(text: "AUDIT"),
          ],
        ),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _GeographyPanel(vm: viewModel),
                _SectorsPanel(vm: viewModel),
                _MetadataPanel(vm: viewModel),
                _AuditPanel(vm: auditVM),
              ],
            ),
    );
  }
}

class _GeographyPanel extends StatefulWidget {
  final TaxonomyViewModel vm;
  const _GeographyPanel({required this.vm});

  @override
  State<_GeographyPanel> createState() => _GeographyPanelState();
}

class _GeographyPanelState extends State<_GeographyPanel> {
  String? _selectedCountryId;
  String? _selectedRegionId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSectionHeader("1. COUNTRIES", onAdd: () => _showGeographyDialog("country")),
        ...widget.vm.countries.map((c) => _buildListTile(
          label: "${c['flagEmoji'] ?? ''} ${c['nameEn']}",
          isSelected: _selectedCountryId == c['id'],
          onTap: () {
            setState(() {
              _selectedCountryId = c['id'];
              _selectedRegionId = null;
            });
            widget.vm.loadRegions(c['id']);
          },
        )),
        
        if (_selectedCountryId != null) ...[
          const SizedBox(height: 32),
          _buildSectionHeader("2. REGIONS", onAdd: () => _showGeographyDialog("region")),
          ...widget.vm.regions.map((r) => _buildListTile(
            label: r['nameEn'],
            isSelected: _selectedRegionId == r['id'],
            onTap: () {
              setState(() => _selectedRegionId = r['id']);
              widget.vm.loadCities(r['id']);
            },
          )),
        ],

        if (_selectedRegionId != null) ...[
          const SizedBox(height: 32),
          _buildSectionHeader("3. CITIES", onAdd: () => _showGeographyDialog("city"), onImport: () => _showImportDialog("city")),
          ...widget.vm.cities.map((city) => _buildListTile(
            label: city['nameEn'],
            onTap: () {}, // Detail editor could open here
          )),
        ],
      ],
    );
  }

  void _showGeographyDialog(String type) {
    final nameEn = TextEditingController();
    final nameAr = TextEditingController();
    final code = TextEditingController(); // ISO or Region Code

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ADD ${type.toUpperCase()}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameEn, decoration: const InputDecoration(hintText: "Name (English)")),
            const SizedBox(height: 8),
            TextField(controller: nameAr, textDirection: TextDirection.rtl, decoration: const InputDecoration(hintText: "الأسم (عربي)")),
            const SizedBox(height: 8),
            if (type != 'city') TextField(controller: code, decoration: InputDecoration(hintText: type == 'country' ? "ISO Code" : "Region Code")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () async {
              final data = {
                'id': type == 'country' ? code.text.toUpperCase() : null, // Countries use ISO codes as ID
                'nameEn': nameEn.text,
                'nameAr': nameAr.text,
                'regionCode': type == 'region' ? code.text : null,
                'countryId': _selectedCountryId,
                'regionId': _selectedRegionId,
              };

              if (type == 'country') await widget.vm.upsertCountry(data);
              if (type == 'region') await widget.vm.upsertRegion(data);
              if (type == 'city') await widget.vm.upsertCity(data);

              if (mounted) Navigator.pop(context);
            },
            child: const Text("SAVE"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onAdd, VoidCallback? onImport}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 2)),
          Row(
            children: [
              if (onImport != null)
                IconButton(icon: const Icon(Icons.file_upload_rounded, size: 20, color: EspyTheme.royalBlue), onPressed: onImport),
              if (onAdd != null)
                IconButton(icon: const Icon(Icons.add_circle_outline, size: 20, color: EspyTheme.gold), onPressed: onAdd),
            ],
          ),
        ],
      ),
    );
  }

  void _showImportDialog(String type) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("IMPORT ${type.toUpperCase()}S (CSV)"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Format: NameEn, NameAr, Lat, Lng", style: TextStyle(fontSize: 10, color: Colors.black38)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 8,
              decoration: const InputDecoration(hintText: "Enter CSV data here...", border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () async {
              if (type == 'city' && _selectedRegionId != null) {
                await widget.vm.importCitiesCsv(_selectedRegionId!, controller.text);
              }
              if (mounted) Navigator.pop(context);
            },
            child: const Text("IMPORT"),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({required String label, bool isSelected = false, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: PremiumCard(
        padding: EdgeInsets.zero,
        child: ListTile(
          onTap: onTap,
          selected: isSelected,
          selectedTileColor: EspyTheme.royalBlue.withValues(alpha: 0.05),
          title: Text(label.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w700, color: isSelected ? EspyTheme.royalBlue : EspyTheme.navyDeep)),
          trailing: const Icon(Icons.chevron_right_rounded, size: 18),
        ),
      ),
    );
  }
}

class _SectorsPanel extends StatefulWidget {
  final TaxonomyViewModel vm;
  const _SectorsPanel({required this.vm});

  @override
  State<_SectorsPanel> createState() => _SectorsPanelState();
}

class _SectorsPanelState extends State<_SectorsPanel> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: widget.vm.sectors.length,
      itemBuilder: (context, index) {
        final s = widget.vm.sectors[index];
        final Color color = Color(int.tryParse(s['colorHex'] ?? '0xFF1565C0') ?? 0xFF1565C0);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PremiumCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: EspyIcon(iconName: s['iconName'] ?? 'help', color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s['nameEn'].toString().toUpperCase(), style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 13)),
                      Text(s['nameAr'] ?? 'N/A', style: const TextStyle(fontSize: 12, color: Colors.black38)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.palette_rounded, size: 18, color: EspyTheme.gold), 
                  onPressed: () => _showBrandingDialog(s),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBrandingDialog(Map<String, dynamic> sector) {
    final iconName = TextEditingController(text: sector['iconName']);
    final colorHex = TextEditingController(text: sector['colorHex']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("BRANDING: ${sector['nameEn']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: iconName, decoration: const InputDecoration(hintText: "Icon Name (e.g. heart, brain, scale)")),
            const SizedBox(height: 12),
            TextField(controller: colorHex, decoration: const InputDecoration(hintText: "Color Hex (e.g. 0xFF1565C0)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () async {
              await widget.vm.updateSectorBranding(sector['id'], {
                'iconName': iconName.text,
                'colorHex': colorHex.text,
              });
              if (mounted) Navigator.pop(context);
            },
            child: const Text("SAVE"),
          ),
        ],
      ),
    );
  }
}

class _MetadataPanel extends StatefulWidget {
  final TaxonomyViewModel vm;
  const _MetadataPanel({required this.vm});

  @override
  State<_MetadataPanel> createState() => _MetadataPanelState();
}

class _MetadataPanelState extends State<_MetadataPanel> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildTagSection("SERVICE TAGS", widget.vm.tags['serviceTags'] ?? [], 'service'),
        const SizedBox(height: 32),
        _buildTagSection("PRICE TAGS", widget.vm.tags['priceTags'] ?? [], 'price'),
        const SizedBox(height: 32),
        _buildTagSection("PIN CATEGORIES", widget.vm.tags['pinCategories'] ?? [], 'pin'),
        const SizedBox(height: 32),
        _buildTagSection("PRESENCE TAGS", widget.vm.tags['presenceTags'] ?? [], 'presence'),
      ],
    );
  }

  Widget _buildTagSection(String title, List<Map<String, dynamic>> tags, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 2)),
            IconButton(
              icon: const Icon(Icons.add_box_outlined, size: 18, color: EspyTheme.gold), 
              onPressed: () => _showTagDialog(type),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: tags.map((t) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black.withValues(alpha: 0.05))),
            child: Text(t['nameEn'].toString().toUpperCase(), style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.bold, color: EspyTheme.navyDeep)),
          )).toList(),
        ),
      ],
    );
  }

  void _showTagDialog(String type) {
    final id = TextEditingController();
    final nameEn = TextEditingController();
    final nameAr = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ADD ${type.toUpperCase()} TAG"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: id, decoration: const InputDecoration(hintText: "ID (e.g. online, consultation)")),
            const SizedBox(height: 8),
            TextField(controller: nameEn, decoration: const InputDecoration(hintText: "Name (English)")),
            const SizedBox(height: 8),
            TextField(controller: nameAr, textDirection: TextDirection.rtl, decoration: const InputDecoration(hintText: "الأسم (عربي)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () async {
              await widget.vm.upsertTag(type, {
                'id': id.text.toLowerCase(),
                'nameEn': nameEn.text,
                'nameAr': nameAr.text,
              });
              if (mounted) Navigator.pop(context);
            },
            child: const Text("SAVE"),
          ),
        ],
      ),
    );
  }
}

class _AuditPanel extends StatelessWidget {
  final AuditViewModel vm;
  const _AuditPanel({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          PremiumButton(
            label: vm.isChecking ? "AUDITING..." : "RUN TAXONOMY AUDIT",
            onPressed: vm.isChecking ? null : vm.runTaxonomyAudit,
            fullWidth: true,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: vm.conflicts.isEmpty
                ? Center(child: Text("NO AUDIT LOGS", style: GoogleFonts.lora(color: Colors.black26)))
                : ListView.builder(
                    itemCount: vm.conflicts.length,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: EspyTheme.platinum, borderRadius: BorderRadius.circular(16)),
                      child: Text(vm.conflicts[index], style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
