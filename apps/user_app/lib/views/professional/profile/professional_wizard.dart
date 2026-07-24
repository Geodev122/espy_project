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
import 'package:espy_app/widgets/common/hierarchical_location_picker.dart';
import 'package:espy_app/widgets/common/bilingual_text_field.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/profile_image_picker.dart';
import 'package:espy_app/widgets/common/document_picker.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import '../../../models/sector_model.dart';
import '../../../models/category_model.dart';
import '../../../models/city_model.dart';
import '../../../models/enums.dart';

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
  final _specializationController = TextEditingController();
  final _specializationArController = TextEditingController();
  final _whatsappCodeController = TextEditingController(text: '+961');
  final _whatsappNumberController = TextEditingController();

  String? _selectedSectorId;
  String? _selectedCategoryId;
  CityModel? _mainLocation;
  File? _profileImage;
  File? _verificationDoc;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistrationViewModel>(context);
    final l10n = AppLocalizations.of(context)!;

    return EspyScaffold(
      useCinematicBackground: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressHeader(viewModel),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: viewModel.currentPhase == 0 
                  ? _buildPhase1(l10n) 
                  : _buildPhase2(l10n, viewModel),
              ),
              const SizedBox(height: 40),
              _buildActions(viewModel, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHeader(RegistrationViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("PROFESSIONAL ONBOARDING", style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.cyan, letterSpacing: 2)),
        const SizedBox(height: 12),
        Row(
          children: [
            _stepIndicator(0, "IDENTITY", vm.currentPhase >= 0),
            _stepIndicator(1, "CAPACITY", vm.currentPhase >= 1),
          ],
        ),
      ],
    );
  }

  Widget _stepIndicator(int index, String label, bool active) {
    return Expanded(
      child: Column(
        children: [
          Container(height: 4, color: active ? EspyTheme.gold : Colors.white10),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.montserrat(fontSize: 8, fontWeight: FontWeight.bold, color: active ? Colors.white : Colors.white24)),
        ],
      ),
    );
  }

  Widget _buildPhase1(AppLocalizations l10n) {
    return Column(
      children: [
        ProfileImagePicker(onImageSelected: (file, bytes) => setState(() => _profileImage = file)),
        const SizedBox(height: 32),
        PremiumCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildLabel("Identity Name"),
              TextField(controller: _nameController, decoration: const InputDecoration(hintText: "LEGAL FULL NAME")),
              const SizedBox(height: 20),
              _buildSectorPicker(),
              const SizedBox(height: 20),
              _buildLabel("Phone Node (WhatsApp)"),
              Row(
                children: [
                  SizedBox(width: 80, child: TextField(controller: _whatsappCodeController)),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: _whatsappNumberController, decoration: const InputDecoration(hintText: "NUMBER"))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        HierarchicalLocationPicker(onCitySelected: (city) => setState(() => _mainLocation = city)),
      ],
    );
  }

  Widget _buildPhase2(AppLocalizations l10n, RegistrationViewModel vm) {
    return Column(
      children: [
        PremiumCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildResourceCard(icon: LucideIcons.mapPin, title: "MAP PINS", desc: "Map nodes visible to visitors.", value: vm.pinsCount, onChanged: vm.updatePins),
              _buildResourceCard(icon: LucideIcons.layoutGrid, title: "SERVICE SLOTS", desc: "Active service profiles.", value: vm.slotsCount, onChanged: vm.updateSlots),
            ],
          ),
        ),
        const SizedBox(height: 24),
        DocumentPicker(label: "VERIFICATION PROTOCOL (ID/LICENSE)", onDocumentSelected: (file, bytes, name) => setState(() => _verificationDoc = file)),
      ],
    );
  }

  Widget _buildResourceCard({required IconData icon, required String title, required String desc, required int value, required Function(int) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: EspyTheme.gold, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w900)),
              Text(desc, style: GoogleFonts.lora(fontSize: 10, color: Colors.white54)),
            ]),
          ),
          Row(children: [
            IconButton(icon: const Icon(Icons.remove_circle_outline, size: 18), onPressed: value > 1 ? () => onChanged(value - 1) : null),
            Text(value.toString(), style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
            IconButton(icon: const Icon(Icons.add_circle_outline, size: 18), onPressed: () => onChanged(value + 1)),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectorPicker() {
    final repo = context.read<EspyRepository>();
    return StreamBuilder<List<SectorModel>>(
      stream: repo.listSectors(),
      builder: (context, snapshot) {
        final sectors = snapshot.data ?? [];
        return DropdownButtonFormField<String>(
          value: _selectedSectorId,
          hint: const Text("SELECT CARE SECTOR"),
          items: sectors.map((s) => DropdownMenuItem(value: s.id, child: Text(s.nameEn.toUpperCase()))).toList(),
          onChanged: (v) => setState(() => _selectedSectorId = v),
        );
      }
    );
  }

  Widget _buildActions(RegistrationViewModel vm, AppLocalizations l10n) {
    return Row(
      children: [
        if (vm.currentPhase > 0)
          IconButton(onPressed: () => vm.setPhase(0), icon: const Icon(Icons.arrow_back_ios, color: Colors.white70)),
        const SizedBox(width: 16),
        Expanded(
          child: PremiumButton(
            label: vm.currentPhase == 1 ? "FINALIZE REGISTRATION" : "CONTINUE",
            isLoading: vm.isSubmitting,
            onPressed: () async {
              if (vm.currentPhase == 0) {
                vm.setPhase(1);
              } else {
                final success = await vm.submitProfessionalRegistration(
                  name: _nameController.text,
                  bio: _bioController.text,
                  bioAr: _bioArController.text,
                  specialty: _specializationController.text,
                  specialtyAr: _specializationArController.text,
                  sectorId: _selectedSectorId ?? 'health',
                  categoryId: _selectedCategoryId ?? 'doctors',
                  whatsapp: '${_whatsappCodeController.text}${_whatsappNumberController.text}',
                  mainLocation: _mainLocation,
                );
                if (success) {
                   // Done
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.bold, color: EspyTheme.gold)));
  }
}
