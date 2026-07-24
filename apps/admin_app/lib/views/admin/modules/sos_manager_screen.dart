import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_core/espy_core.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/taxonomy_view_model.dart';
import '../../../viewmodels/sos_management_view_model.dart';
import '../../../widgets/common/premium_button.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';

class SosManagerScreen extends StatelessWidget {
  const SosManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaxonomyViewModel(context.read<EspyRepository>())),
        ChangeNotifierProvider(create: (context) => SosManagementViewModel(context.read<EspyRepository>())),
      ],
      child: const _SosManagerView(),
    );
  }
}

class _SosManagerView extends StatefulWidget {
  const _SosManagerView();

  @override
  State<_SosManagerView> createState() => _SosManagerViewState();
}

class _SosManagerViewState extends State<_SosManagerView> {
  String? _selectedCountryId;
  String? _selectedSectorId;
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final taxonomyVM = Provider.of<TaxonomyViewModel>(context);
    final sosVM = Provider.of<SosManagementViewModel>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("SOS OPERATIONS GOVERNANCE", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: Row(
        children: [
          // Hierarchy Sidebar
          Container(
            width: 300,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
              color: Colors.white,
            ),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildSidebarHeader("COUNTRY"),
                ...taxonomyVM.countries.map((c) => _buildSidebarTile(
                  label: "${c.flagEmoji ?? ''} ${c.nameEn}",
                  isSelected: _selectedCountryId == c.id,
                  onTap: () {
                    setState(() {
                      _selectedCountryId = c.id;
                      _selectedSectorId = null;
                      _selectedCategoryId = null;
                    });
                    sosVM.listenToSosNumbers(countryId: c.id);
                  },
                )),
                if (_selectedCountryId != null) ...[
                  const SizedBox(height: 24),
                  _buildSidebarHeader("SECTOR (OPTIONAL)"),
                  _buildSidebarTile(
                    label: "ALL SECTORS",
                    isSelected: _selectedSectorId == null,
                    onTap: () {
                      setState(() {
                        _selectedSectorId = null;
                        _selectedCategoryId = null;
                      });
                      sosVM.listenToSosNumbers(countryId: _selectedCountryId);
                    },
                  ),
                  ...taxonomyVM.sectors.map((s) => _buildSidebarTile(
                    label: s.nameEn,
                    isSelected: _selectedSectorId == s.id,
                    onTap: () {
                      setState(() {
                        _selectedSectorId = s.id;
                        _selectedCategoryId = null;
                      });
                      sosVM.listenToSosNumbers(countryId: _selectedCountryId, sectorId: s.id);
                    },
                  )),
                ],
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: Container(
              color: EspyTheme.platinum.withValues(alpha: 0.3),
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ACTIVE EMERGENCY NUMBERS", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 18)),
                          Text("Direct links to governmental and sectorial responders", style: GoogleFonts.lora(fontSize: 12, color: Colors.black45)),
                        ],
                      ),
                      PremiumButton(
                        label: "ADD NEW SOS NUMBER",
                        onPressed: _selectedCountryId == null ? null : () => _showSosDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: sosVM.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildSosList(sosVM),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 2)),
    );
  }

  Widget _buildSidebarTile({required String label, bool isSelected = false, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        selected: isSelected,
        selectedTileColor: EspyTheme.royalBlue.withValues(alpha: 0.05),
        title: Text(label.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w700, color: isSelected ? EspyTheme.royalBlue : EspyTheme.navyDeep)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSosList(SosManagementViewModel vm) {
    if (vm.sosNumbers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emergency_outlined, size: 64, color: Colors.black12),
            const SizedBox(height: 16),
            Text("NO SOS NUMBERS CONFIGURED FOR THIS SCOPE", style: GoogleFonts.lora(color: Colors.black26)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: vm.sosNumbers.length,
      itemBuilder: (context, index) {
        final sos = vm.sosNumbers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: PremiumCard(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: EspyTheme.royalBlue.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.phone_in_talk, color: EspyTheme.royalBlue),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sos['labelEn'].toUpperCase(), style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 14)),
                      Text(sos['labelAr'] ?? '', style: const TextStyle(fontSize: 13, color: Colors.black38)),
                      const SizedBox(height: 4),
                      Text(sos['number'], style: GoogleFonts.firaCode(fontWeight: FontWeight.bold, fontSize: 16, color: EspyTheme.gold)),
                    ],
                  ),
                ),
                Switch(
                  value: sos['isActive'] ?? true,
                  onChanged: (val) => vm.toggleSosStatus(sos['id'], sos, val),
                  activeColor: EspyTheme.gold,
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => _showSosDialog(context, existing: sos),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSosDialog(BuildContext context, {Map<String, dynamic>? existing}) {
    final labelEn = TextEditingController(text: existing?['labelEn']);
    final labelAr = TextEditingController(text: existing?['labelAr']);
    final number = TextEditingController(text: existing?['number']);
    final sosVM = Provider.of<SosManagementViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? "ADD SOS NUMBER" : "EDIT SOS NUMBER"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: labelEn, decoration: const InputDecoration(hintText: "Label (English)")),
            const SizedBox(height: 8),
            TextField(controller: labelAr, textDirection: TextDirection.rtl, decoration: const InputDecoration(hintText: "Label (Arabic)")),
            const SizedBox(height: 8),
            TextField(controller: number, decoration: const InputDecoration(hintText: "Phone Number")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () async {
              await sosVM.upsertSosNumber({
                if (existing != null) 'id': existing['id'],
                'countryId': _selectedCountryId,
                'sectorId': _selectedSectorId,
                'categoryId': _selectedCategoryId,
                'labelEn': labelEn.text,
                'labelAr': labelAr.text,
                'number': number.text,
                'isActive': true,
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
