import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/viewmodels/espy_repository.dart';
import 'package:espy_app/viewmodels/registration_view_model.dart';
import 'package:espy_app/widgets/common/location_picker_modal.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/profile_image_picker.dart';
import 'package:espy_app/widgets/common/document_picker.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';

class ProfessionalWizard extends StatefulWidget {
  const ProfessionalWizard({super.key});

  @override
  State<ProfessionalWizard> createState() => _ProfessionalWizardState();
}

class _ProfessionalWizardState extends State<ProfessionalWizard> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _bioArController = TextEditingController();
  final _whatsappCodeController = TextEditingController(text: '+961');
  final _whatsappNumberController = TextEditingController();
  final _specializationController = TextEditingController();
  final _specializationArController = TextEditingController();

  String? _selectedSectorId;
  String? _selectedCategoryId;
  File? _profileImageFile;
  Uint8List? _profileImageWebBytes;

  Map<String, dynamic>? _mainLocation;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthService>(context, listen: false);
    _nameController.text = auth.user?.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistrationViewModel>(context);
    final l10n = AppLocalizations.of(context)!;

    return EspyScaffold(
      useCinematicBackground: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("PROTOCOL ONBOARDING", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white, fontSize: 13)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildStepIndicator(viewModel),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(key: _formKey, child: viewModel.currentPhase == 0 ? _buildPhase1(l10n) : _buildPhase2(l10n, viewModel)),
              ),
            ),
            _buildBottomNav(l10n, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(RegistrationViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(2, (index) {
          bool active = index == vm.currentPhase;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: active ? 40 : 12, height: 6,
            decoration: BoxDecoration(color: active ? EspyTheme.gold : Colors.white24, borderRadius: BorderRadius.circular(3)),
          );
        }),
      ),
    );
  }

  Widget _buildPhase1(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("PHASE I: IDENTITY", style: GoogleFonts.cinzel(color: EspyTheme.gold, fontWeight: FontWeight.w900, fontSize: 18)),
        const SizedBox(height: 32),
        Center(
          child: ProfileImagePicker(
            onImageSelected: (file, bytes) {
              _profileImageFile = file;
              _profileImageWebBytes = bytes;
            },
          ),
        ),
        const SizedBox(height: 32),
        _buildLabel("LEGAL NAME / CLINIC NAME"),
        _buildTextField(_nameController, "e.g. Dr. Adam Smith"),
        const SizedBox(height: 24),
        _buildLabel("SECTOR & CATEGORY"),
        _buildSectorDropdown(),
        if (_selectedSectorId != null) ...[
          const SizedBox(height: 12),
          _buildCategoryDropdown(),
        ],
        const SizedBox(height: 24),
        _buildLabel("SPECIALIZATION (EN / AR)"),
        _buildTextField(_specializationController, "Specialty in English"),
        const SizedBox(height: 12),
        _buildTextField(_specializationArController, "التخصص بالعربية", isRtl: true),
        const SizedBox(height: 24),
        _buildLabel("PROFESSIONAL BIO (EN)"),
        _buildTextField(_bioController, "Tell users about your experience...", maxLines: 3),
      ],
    );
  }

  Widget _buildPhase2(AppLocalizations l10n, RegistrationViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("PHASE II: RESOURCES", style: GoogleFonts.cinzel(color: EspyTheme.gold, fontWeight: FontWeight.w900, fontSize: 18)),
        const SizedBox(height: 24),
        _buildResourceCard(icon: LucideIcons.mapPin, title: "MAP PINS", desc: "Map nodes visible to visitors.", value: vm.pinsCount, onChanged: vm.updatePins),
        _buildResourceCard(icon: LucideIcons.layoutGrid, title: "SERVICE SLOTS", desc: "Active service profiles.", value: vm.slotsCount, onChanged: vm.updateSlots),
        _buildResourceCard(icon: LucideIcons.megaphone, title: "BROADCASTS", desc: "Marketing bursts to reach community.", value: vm.broadcastsCount, onChanged: vm.updateBroadcasts),
        const SizedBox(height: 32),
        Text("VERIFICATION", style: GoogleFonts.cinzel(color: EspyTheme.gold, fontWeight: FontWeight.w900, fontSize: 14)),
        const SizedBox(height: 16),
        DocumentPicker(label: 'Upload License/Degree', onDocumentSelected: (f, b, n) {}),
        const SizedBox(height: 24),
        _buildLabel("WHATSAPP FOR CLIENTS"),
        Row(
          children: [
            SizedBox(width: 80, child: _buildTextField(_whatsappCodeController, "+961", kType: TextInputType.phone)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField(_whatsappNumberController, "Number", kType: TextInputType.phone)),
          ],
        ),
        const SizedBox(height: 24),
        _buildLabel("MAIN PRACTICE HUB"),
        _buildLocationPicker(l10n),
      ],
    );
  }

  Widget _buildResourceCard({required IconData icon, required String title, required String desc, required int value, required Function(int) onChanged}) {
    return PremiumCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: EspyTheme.royalBlue, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
              Text(desc, style: GoogleFonts.lora(fontSize: 9, color: Colors.black45), maxLines: 2),
            ]),
          ),
          Row(children: [
            _counterBtn(Icons.remove, () => value > 0 ? onChanged(value - 1) : null),
            SizedBox(width: 30, child: Center(child: Text("$value", style: GoogleFonts.montserrat(fontWeight: FontWeight.w900)))),
            _counterBtn(Icons.add, () => onChanged(value + 1)),
          ]),
        ],
      ),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap) {
    return InkWell(onTap: onTap, child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black12)), child: Icon(icon, size: 14)));
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, {int maxLines = 1, bool isRtl = false, TextInputType kType = TextInputType.text}) {
    return TextFormField(
      controller: ctrl, maxLines: maxLines, textAlign: isRtl ? TextAlign.right : TextAlign.left, keyboardType: kType,
      style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14, fontWeight: FontWeight.w600),
      decoration: InputDecoration(hintText: hint, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text(text, style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w800, color: EspyTheme.cyan, letterSpacing: 1)));
  }

  Widget _buildSectorDropdown() {
    final repo = Provider.of<EspyRepository>(context, listen: false);
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: repo.listSectors(),
      builder: (context, snapshot) {
        final sectors = snapshot.data ?? [];
        return DropdownButtonFormField<String>(
          value: _selectedSectorId,
          items: sectors.map((s) => DropdownMenuItem(value: s['id'].toString(), child: Text(s['nameEn'].toUpperCase(), style: const TextStyle(fontSize: 12)))).toList(),
          onChanged: (v) => setState(() { _selectedSectorId = v; _selectedCategoryId = null; }),
          decoration: InputDecoration(hintText: "Select Sector", filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
        );
      },
    );
  }

  Widget _buildCategoryDropdown() {
    final repo = Provider.of<EspyRepository>(context, listen: false);
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: repo.listCategories(sectorId: _selectedSectorId),
      builder: (context, snapshot) {
        final cats = snapshot.data ?? [];
        return DropdownButtonFormField<String>(
          value: _selectedCategoryId,
          items: cats.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['nameEn'].toUpperCase(), style: const TextStyle(fontSize: 12)))).toList(),
          onChanged: (v) => setState(() => _selectedCategoryId = v),
          decoration: InputDecoration(hintText: "Select Category", filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
        );
      },
    );
  }

  Widget _buildLocationPicker(AppLocalizations l10n) {
    return PremiumCard(padding: const EdgeInsets.all(12), child: ListTile(
      leading: const Icon(Icons.location_on, color: EspyTheme.gold),
      title: Text(_mainLocation?['cityName'] ?? "No Pin Dropped", style: GoogleFonts.lora(fontSize: 13, fontWeight: FontWeight.bold)),
      trailing: TextButton(onPressed: () => _openMainLocationPicker(l10n), child: const Text("SET PIN")),
    ));
  }

  Future<void> _openMainLocationPicker(AppLocalizations l10n) async {
    final result = await showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (_) => LocationPickerModal(title: l10n.setMainNode));
    if (result != null) setState(() => _mainLocation = result);
  }

  Widget _buildBottomNav(AppLocalizations l10n, RegistrationViewModel vm) {
    return Container(padding: const EdgeInsets.all(32), decoration: const BoxDecoration(color: EspyTheme.navyDeep), child: Row(children: [
      if (vm.currentPhase > 0) ...[
        IconButton(onPressed: () => vm.setPhase(0), icon: const Icon(Icons.arrow_back_ios, color: Colors.white70)),
        const SizedBox(width: 16),
      ],
      Expanded(child: PremiumButton(
        label: vm.currentPhase == 1 ? "FINALIZE REGISTRATION" : l10n.continueText.toUpperCase(),
        isLoading: vm.isSubmitting,
        onPressed: () {
          if (vm.currentPhase == 0) {
             vm.setPhase(1);
          } else {
            vm.submitProfessionalRegistration(
              name: _nameController.text.trim(),
              bio: _bioController.text,
              bioAr: _bioArController.text,
              specialty: _specializationController.text,
              specialtyAr: _specializationArController.text,
              sectorId: _selectedSectorId!,
              categoryId: _selectedCategoryId!,
              whatsapp: '${_whatsappCodeController.text}${_whatsappNumberController.text}',
              profileImage: _profileImageFile,
              profileBytes: _profileImageWebBytes,
              mainLocation: _mainLocation,
            );
          }
        },
      )),
    ]));
  }
}
