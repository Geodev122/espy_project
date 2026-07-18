import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:espy_app/l10n/app_localizations.dart';
import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/services/storage_service.dart';
import 'package:shared_core/widgets/common/location_picker_modal.dart';
import 'package:shared_core/widgets/common/premium_button.dart';
import 'package:shared_core/widgets/common/premium_card.dart';
import 'package:shared_core/widgets/common/profile_image_picker.dart';
import 'package:shared_core/widgets/common/document_picker.dart';
import 'package:shared_core/widgets/common/espy_scaffold.dart';
import 'package:shared_core/widgets/common/wizard_step_container.dart';

class ProfessionalWizard extends StatefulWidget {
  const ProfessionalWizard({super.key});

  @override
  State<ProfessionalWizard> createState() => _ProfessionalWizardState();
}

class _ProfessionalWizardState extends State<ProfessionalWizard> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  bool get isAr => Localizations.localeOf(context).languageCode == 'ar';

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

  File? _proofFile;
  Uint8List? _proofBytes;
  String? _proofFileName;

  Map<String, dynamic>? _mainLocation;
  final List<Map<String, dynamic>> _secondaryLocations = [];

  final FirestoreService _firestore = FirestoreService();
  final StorageService _storage = StorageService();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.userData;
    
    if (user != null) {
      setState(() {
        _nameController.text = user.name;
        _bioController.text = user['bio'] ?? '';
        _bioArController.text = user['bio_ar'] ?? '';
        _whatsappCodeController.text = user['whatsapp_code'] ?? '+961';
        _whatsappNumberController.text = user['whatsapp_number'] ?? '';
        _specializationController.text = user['specialization'] ?? '';
        _specializationArController.text = user['specialization_ar'] ?? '';
        _selectedSectorId = user['sectorId'];
        _selectedCategoryId = user['categoryId'];
        _mainLocation = user['mainLocation'];
        
        if (_selectedCategoryId != null) {
          if (_mainLocation != null) {
            _currentStep = 3;
          } else {
            _currentStep = 2;
          }
        }
      });
    }
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
          l10n.protocolRegistration.toUpperCase(),
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white, fontSize: 13),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: _buildCurrentStep(l10n),
                ),
              ),
            ),
            _buildBottomActions(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          bool isActive = index == _currentStep;
          bool isDone = index < _currentStep;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: isActive ? 48 : 12,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isActive
                  ? EspyTheme.cyan
                  : (isDone ? EspyTheme.electricBlue : Colors.white12),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return WizardStepContainer(
          title: l10n.tellUsAboutYourself,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileImagePicker(
                onImageSelected: (file, bytes) {
                  _profileImageFile = file;
                  _profileImageWebBytes = bytes;
                },
              ),
              const SizedBox(height: 32),
              _buildFieldLabel(l10n.legalFullName),
              TextFormField(
                controller: _nameController,
                style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                decoration: const InputDecoration(hintText: 'e.g. Dr. Marc Antoine'),
              ),
              const SizedBox(height: 24),
              _buildFieldLabel(l10n.professionalSector),
              _buildSectorDropdown(l10n),
              if (_selectedSectorId != null) ...[
                const SizedBox(height: 24),
                _buildFieldLabel(l10n.selectCategory),
                _buildCategoryDropdown(l10n),
              ],
              const SizedBox(height: 24),
              _buildFieldLabel("${l10n.specialization} (EN)"),
              TextFormField(
                controller: _specializationController,
                style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                decoration: const InputDecoration(hintText: 'e.g. Clinical Psychologist'),
              ),
              const SizedBox(height: 24),
              _buildFieldLabel("${l10n.specialization} (AR)"),
              TextFormField(
                controller: _specializationArController,
                style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(hintText: 'مثلاً: أخصائي علم نفس عيادي'),
              ),
            ],
          ),
        );
      case 1:
        return WizardStepContainer(
          title: l10n.professionalExpertise,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel("${l10n.tellNetworkAboutYou} (EN)"),
              TextFormField(
                controller: _bioController,
                style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                maxLines: 4,
                decoration: const InputDecoration(hintText: 'Describe your clinical background...'),
              ),
              const SizedBox(height: 24),
              _buildFieldLabel("${l10n.tellNetworkAboutYou} (AR)"),
              TextFormField(
                controller: _bioArController,
                style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                maxLines: 4,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(hintText: 'صف خلفيتك السريرية...'),
              ),
              const SizedBox(height: 32),
              DocumentPicker(
                label: 'Professional Credentials',
                onDocumentSelected: (file, bytes, fileName) {
                  _proofFile = file;
                  _proofBytes = bytes;
                  _proofFileName = fileName;
                },
              ),
              const SizedBox(height: 32),
              _buildFieldLabel(l10n.whatsappContact),
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      controller: _whatsappCodeController,
                      style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                      decoration: const InputDecoration(hintText: '+961'),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _whatsappNumberController,
                      style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                      decoration: const InputDecoration(hintText: 'XX XXX XXX'),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case 2:
        return WizardStepContainer(
          title: 'SERVICE COVERAGE',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel(l10n.mainHub),
              PremiumCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: EspyTheme.gold),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _mainLocation?['cityName'] ?? l10n.noPinDropped,
                        style: GoogleFonts.lora(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _openMainLocationPicker(l10n),
                      child: Text(l10n.setPin,
                          style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, color: EspyTheme.gold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 3:
        return WizardStepContainer(
          title: l10n.almostThere,
          child: Column(
            children: [
              PremiumCard(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Icon(Icons.verified_user_rounded, size: 64, color: EspyTheme.success),
                    const SizedBox(height: 32),
                    Text(l10n.professionalDashboardRedir, textAlign: TextAlign.center, style: GoogleFonts.lora(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildSectorDropdown(AppLocalizations l10n) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestore.getSectors(),
      builder: (context, snapshot) {
        final sectors = snapshot.data ?? [];
        return DropdownButtonFormField<String>(
          value: _selectedSectorId,
          items: sectors.map((s) => DropdownMenuItem(value: s['id'].toString(), child: Text(s['name_en'].toUpperCase()))).toList(),
          onChanged: (v) => setState(() { _selectedSectorId = v; _selectedCategoryId = null; }),
          decoration: InputDecoration(hintText: l10n.selectSector),
        );
      },
    );
  }

  Widget _buildCategoryDropdown(AppLocalizations l10n) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestore.getCategories('professional_category'),
      builder: (context, snapshot) {
        final cats = snapshot.data?.where((c) => c['parent_id'] == _selectedSectorId).toList() ?? [];
        return DropdownButtonFormField<String>(
          value: _selectedCategoryId,
          items: cats.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['name_en'].toUpperCase()))).toList(),
          onChanged: (v) => setState(() => _selectedCategoryId = v),
          decoration: InputDecoration(hintText: l10n.selectCategory),
        );
      },
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

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10, color: EspyTheme.cyan, letterSpacing: 2)),
    );
  }

  Widget _buildBottomActions(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: EspyTheme.navyDeep),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            IconButton(onPressed: () => setState(() => _currentStep--), icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: PremiumButton(
              label: _currentStep == 3 ? l10n.submitForReview : l10n.continueText,
              isLoading: _isSubmitting,
              onPressed: _handleNext,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNext() async {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _submitProfile();
    }
  }

  Future<void> _submitProfile() async {
     // ... logic to submit via repo
  }
}
