import 'dart:async';
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
import 'package:espy_app/viewmodels/storage_service.dart';
import 'package:espy_app/widgets/common/location_picker_modal.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/profile_image_picker.dart';
import 'package:espy_app/widgets/common/document_picker.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';

class InstitutionWizard extends StatefulWidget {
  const InstitutionWizard({super.key});

  @override
  State<InstitutionWizard> createState() => _InstitutionWizardState();
}

class _InstitutionWizardState extends State<InstitutionWizard> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _bioArController = TextEditingController();
  final _whatsappCodeController = TextEditingController(text: '+961');
  final _whatsappNumberController = TextEditingController();
  final _registrationController = TextEditingController();

  String? _selectedCategoryId;
  File? _profileImageFile;
  Uint8List? _profileImageWebBytes;

  File? _proofFile;
  Uint8List? _proofBytes;
  String? _proofFileName;

  Map<String, dynamic>? _mainLocation;

  // Resource Quantities
  int _pinsCount = 1;
  int _slotsCount = 5;
  int _broadcastsCount = 0;

  final StorageService _storage = StorageService();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _prefillData();
  }

  void _prefillData() {
    final auth = Provider.of<AuthService>(context, listen: false);
    _nameController.text = auth.user?.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EspyScaffold(
      useCinematicBackground: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "INSTITUTION ONBOARDING",
          style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white, fontSize: 13),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildStepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Form(key: _formKey, child: _buildCurrentStep(l10n)),
              ),
            ),
            _buildBottomNav(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(2, (index) {
          bool active = index == _currentStep;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: active ? 40 : 12,
            height: 6,
            decoration: BoxDecoration(
              color: active ? EspyTheme.cyan : Colors.white24,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep(AppLocalizations l10n) {
    if (_currentStep == 0) {
      return _buildPhase1(l10n);
    }
    return _buildPhase2(l10n);
  }

  Widget _buildPhase1(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("PHASE I: PROFILE", style: GoogleFonts.cinzel(color: EspyTheme.cyan, fontWeight: FontWeight.w900, fontSize: 18)),
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
        _buildLabel("INSTITUTION NAME"),
        _buildTextField(_nameController, "e.g. Hope Medical Center"),
        const SizedBox(height: 24),
        _buildLabel("INSTITUTION CATEGORY"),
        _buildCategoryDropdown(l10n),
        const SizedBox(height: 24),
        _buildLabel("REGISTRATION NUMBER / ID"),
        _buildTextField(_registrationController, "Official identifier"),
        const SizedBox(height: 24),
        _buildLabel("MISSION DESCRIPTION (EN)"),
        _buildTextField(_bioController, "Describe your institutional services...", maxLines: 3),
      ],
    );
  }

  Widget _buildPhase2(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("PHASE II: PROTOCOLS", style: GoogleFonts.cinzel(color: EspyTheme.cyan, fontWeight: FontWeight.w900, fontSize: 18)),
        const SizedBox(height: 24),
        _buildResourceCard(
          icon: LucideIcons.mapPin,
          title: "HUB PIN",
          desc: "Facility location visible on the global map.",
          value: _pinsCount,
          onChanged: (v) => setState(() => _pinsCount = v),
        ),
        _buildResourceCard(
          icon: LucideIcons.layoutGrid,
          title: "DEPARTMENT SLOTS",
          desc: "Number of department profiles or services.",
          value: _slotsCount,
          onChanged: (v) => setState(() => _slotsCount = v),
        ),
        _buildResourceCard(
          icon: LucideIcons.megaphone,
          title: "BROADCASTS",
          desc: "Large scale notifications to all users.",
          value: _broadcastsCount,
          onChanged: (v) => setState(() => _broadcastsCount = v),
        ),
        const SizedBox(height: 32),
        Text("LEGAL VERIFICATION", style: GoogleFonts.cinzel(color: EspyTheme.cyan, fontWeight: FontWeight.w900, fontSize: 14)),
        const SizedBox(height: 16),
        DocumentPicker(
          label: 'Upload Registration Docs',
          onDocumentSelected: (file, bytes, fileName) {
            _proofFile = file;
            _proofBytes = bytes;
            _proofFileName = fileName;
          },
        ),
        const SizedBox(height: 24),
        _buildLabel("OFFICIAL WHATSAPP"),
        Row(
          children: [
            SizedBox(width: 80, child: _buildTextField(_whatsappCodeController, "+961", kType: TextInputType.phone)),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField(_whatsappNumberController, "Number", kType: TextInputType.phone)),
          ],
        ),
        const SizedBox(height: 24),
        _buildLabel("PRIMARY FACILITY LOCATION"),
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
          Icon(icon, color: EspyTheme.electricBlue, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1)),
                Text(desc, style: GoogleFonts.lora(fontSize: 9, color: Colors.black45), maxLines: 2),
              ],
            ),
          ),
          Row(
            children: [
              _counterBtn(Icons.remove, () => value > 0 ? onChanged(value - 1) : null),
              SizedBox(width: 30, child: Center(child: Text("$value", style: GoogleFonts.montserrat(fontWeight: FontWeight.w900)))),
              _counterBtn(Icons.add, () => onChanged(value + 1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black12)),
        child: Icon(icon, size: 14),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, {int maxLines = 1, bool isRtl = false, TextInputType kType = TextInputType.text}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      textAlign: isRtl ? TextAlign.right : TextAlign.left,
      keyboardType: kType,
      style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w800, color: EspyTheme.cyan, letterSpacing: 1)),
    );
  }

  Widget _buildCategoryDropdown(AppLocalizations l10n) {
    final repo = Provider.of<EspyRepository>(context, listen: false);
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: repo.listCategories(sectorId: "institution"), // Assuming institutional sector
      builder: (context, snapshot) {
        final categories = snapshot.data ?? [];
        return DropdownButtonFormField<String>(
          value: _selectedCategoryId,
          items: categories.map((cat) => DropdownMenuItem(value: cat['id'].toString(), child: Text(cat['nameEn'].toUpperCase(), style: const TextStyle(fontSize: 12)))).toList(),
          onChanged: (val) => setState(() => _selectedCategoryId = val),
          decoration: InputDecoration(hintText: l10n.selectCategory, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
        );
      },
    );
  }

  Widget _buildLocationPicker(AppLocalizations l10n) {
    return PremiumCard(
      padding: const EdgeInsets.all(12),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: EspyTheme.gold),
        title: Text(_mainLocation?['cityName'] ?? "No Pin Dropped", style: GoogleFonts.lora(fontSize: 13, fontWeight: FontWeight.bold)),
        trailing: TextButton(onPressed: () => _openMainLocationPicker(l10n), child: const Text("SET HUB")),
      ),
    );
  }

  Future<void> _openMainLocationPicker(AppLocalizations l10n) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationPickerModal(title: l10n.setMainNode),
    );
    if (result != null) setState(() => _mainLocation = result);
  }

  Widget _buildBottomNav(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(color: EspyTheme.navyDeep),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            IconButton(onPressed: () => setState(() => _currentStep--), icon: const Icon(Icons.arrow_back_ios, color: Colors.white70)),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: PremiumButton(
              label: _currentStep == 1 ? "FINALIZE ONBOARDING" : l10n.continueText.toUpperCase(),
              isLoading: _isSubmitting,
              onPressed: () => _currentStep == 0 ? setState(() => _currentStep++) : _submitProfile(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitProfile() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final repo = Provider.of<EspyRepository>(context, listen: false);
    setState(() => _isSubmitting = true);

    try {
      String? photoUrl;
      if (_profileImageWebBytes != null) {
        photoUrl = await _storage.uploadProfileImageWeb(userId: auth.user!.uid, bytes: _profileImageWebBytes!);
      } else if (_profileImageFile != null) {
        photoUrl = await _storage.uploadProfileImage(userId: auth.user!.uid, file: _profileImageFile!);
      }

      await repo.updateUser(auth.user!.uid, {
        'name': _nameController.text.trim(),
        'photoUrl': photoUrl ?? auth.user?.photoURL,
        'role': 'institution',
        'hasProfile': true,
      });

      // Create Resource Order logic...

      await auth.fetchUserData();
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: EspyTheme.error));
      }
    }
  }
}
