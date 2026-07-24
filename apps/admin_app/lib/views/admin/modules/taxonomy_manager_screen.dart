import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
        _buildSectionHeader("1. COUNTRIES", 
          onAdd: () => _showGeographyDialog("country"),
          onImport: () => _showMasterImportDialog(),
          onExcel: () => _showCsvImportDialog(),
        ),
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
          _buildSectionHeader("2. REGIONS", 
            onAdd: () => _showGeographyDialog("region"),
            onImport: () => _showImportDialog("region"),
            onDownload: () => _showTemplateDialog("region"),
          ),
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
          _buildSectionHeader("3. CITIES", 
            onAdd: () => _showGeographyDialog("city"), 
            onImport: () => _showImportDialog("city"),
            onDownload: () => _showTemplateDialog("city"),
          ),
          ...widget.vm.cities.map((city) => _buildListTile(
            label: city['nameEn'],
            onTap: () {},
          )),
        ],
      ],
    );
  }

  void _showCsvImportDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("HIERARCHICAL CSV IMPORT"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Format: Type,ID,ParentID,NameEn,NameAr,Value1,Value2", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            const Text("Types: COUNTRY, REGION, CITY", style: TextStyle(fontSize: 10)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 12,
              decoration: const InputDecoration(hintText: "COUNTRY,LB,,Lebanon,لبنان,LB,🇱🇧\nREGION,beirut,LB,Beirut,بيروت,BE,\nCITY,bey-city,beirut,Beirut,بيروت,33.8,35.5", border: OutlineInputBorder()),
              style: GoogleFonts.firaCode(fontSize: 10),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () async {
              try {
                await widget.vm.importHierarchicalCsv(controller.text);
                if (mounted) Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Import Failed: $e")));
              }
            },
            child: const Text("IMPORT CSV"),
          ),
        ],
      ),
    );
  }

  void _showMasterImportDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("MASTER HIERARCHY IMPORT (JSON)"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Paste a JSON array containing Countries, Regions, and Cities.", style: TextStyle(fontSize: 11)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 12,
              decoration: const InputDecoration(hintText: "[ { \"id\": \"LB\", ... } ]", border: OutlineInputBorder()),
              style: GoogleFonts.firaCode(fontSize: 10),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () async {
              try {
                await widget.vm.importFullTaxonomyJson(controller.text);
                if (mounted) Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Import Failed: $e")));
              }
            },
            child: const Text("EXECUTE MASTER SEED"),
          ),
        ],
      ),
    );
  }

  void _showGeographyDialog(String type) {
    final id = TextEditingController();
    final nameEn = TextEditingController();
    final nameAr = TextEditingController();
    final code = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("ADD ${type.toUpperCase()}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (type != 'country') TextField(controller: id, decoration: const InputDecoration(hintText: "Slug ID (e.g. beirut)")),
            const SizedBox(height: 8),
            TextField(controller: nameEn, decoration: const InputDecoration(hintText: "Name (English)")),
            const SizedBox(height: 8),
            TextField(controller: nameAr, textDirection: TextDirection.rtl, decoration: const InputDecoration(hintText: "الأسم (عربي)")),
            const SizedBox(height: 8),
            if (type != 'city') TextField(controller: code, decoration: InputDecoration(hintText: type == 'country' ? "ISO Code (e.g. LB)" : "Region Code")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () async {
              final finalId = type == 'country' ? code.text.toUpperCase() : id.text.toLowerCase().trim();
              if (finalId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ID is required")));
                return;
              }

              final data = {
                'id': finalId,
                'nameEn': nameEn.text,
                'nameAr': nameAr.text,
                'regionCode': type == 'region' ? code.text : null,
                'countryId': _selectedCountryId,
                'regionId': _selectedRegionId,
                'isoCode': type == 'country' ? code.text : null,
              };

              try {
                if (type == 'country') await widget.vm.upsertCountry(data);
                if (type == 'region') await widget.vm.upsertRegion(data);
                if (type == 'city') await widget.vm.upsertCity(data);
                if (mounted) Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Save Failed: $e")));
              }
            },
            child: const Text("SAVE"),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(String type) {
    final controller = TextEditingController();
    final template = type == 'region' 
      ? "id, nameEn, nameAr, regionCode"
      : "id, nameEn, nameAr, lat, lng";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("IMPORT ${type.toUpperCase()}S (CSV)"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("COLUMNS: $template", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 10, color: EspyTheme.royalBlue)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 8,
              decoration: const InputDecoration(hintText: "Paste CSV data here...", border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () async {
              if (type == 'region' && _selectedCountryId != null) {
                await widget.vm.importRegionsCsv(_selectedCountryId!, controller.text);
              }
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

  void _showTemplateDialog(String type) {
    final String jsonTemplate = """
[
  {
    "id": "LB",
    "nameEn": "Lebanon",
    "nameAr": "لبنان",
    "isoCode": "LB",
    "regions": [
      {
        "id": "beirut",
        "nameEn": "Beirut",
        "nameAr": "بيروت",
        "regionCode": "BE",
        "cities": [
          { "id": "beirut-city", "nameEn": "Beirut", "nameAr": "بيروت", "lat": 33.89, "lng": 35.50 }
        ]
      }
    ]
  }
]
""";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("HIERARCHY TEMPLATE (JSON)"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Use this format for Master Import:", style: TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
              child: SingleChildScrollView(
                child: SelectableText(jsonTemplate, style: GoogleFonts.firaCode(fontSize: 9)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CLOSE")),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonTemplate));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Template copied to clipboard")));
            },
            child: const Text("COPY JSON TEMPLATE"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onAdd, VoidCallback? onImport, VoidCallback? onDownload, VoidCallback? onExcel}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 2)),
          Row(
            children: [
              if (onDownload != null)
                IconButton(icon: const Icon(Icons.description_outlined, size: 20, color: EspyTheme.royalBlue), onPressed: onDownload),
              if (onExcel != null)
                IconButton(icon: const Icon(Icons.table_view_rounded, size: 20, color: Colors.green), onPressed: onExcel),
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
