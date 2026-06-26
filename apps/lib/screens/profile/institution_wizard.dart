import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';

import '../../core/theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/services/storage_service.dart';
import '../../widgets/common/location_picker_modal.dart';
import '../../widgets/common/premium_button.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/profile_image_picker.dart';
import '../../widgets/common/document_picker.dart';
import '../../widgets/common/cinematic_background.dart';

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
        _nameController.text = user['fullNameEn'] ?? user.name;
        _bioController.text = user['bio'] ?? '';
        _bioArController.text = user['bio_ar'] ?? '';
        _whatsappCodeController.text = user['whatsapp_code'] ?? '+961';
        _whatsappNumberController.text = user['whatsapp_number'] ?? '';
        _registrationController.text = user['registrationNumber'] ?? '';
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

  Future<void> _saveProgress() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final uid = auth.user?.uid;
    if (uid == null) return;

    await _firestore.updateUserProfile(uid, {
      'fullNameEn': _nameController.text,
      'bio': _bioController.text,
      'bio_ar': _bioArController.text,
      'whatsapp_code': _whatsappCodeController.text,
      'whatsapp_number': _whatsappNumberController.text,
      'registrationNumber': _registrationController.text,
      'categoryId': _selectedCategoryId,
      'mainLocation': _mainLocation,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.protocolRegistration,
          style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, letterSpacing: 2, color: EspyTheme.platinum, fontSize: 14),
        ),
        iconTheme: const IconThemeData(color: EspyTheme.platinum),
      ),
      body: CinematicBackground(
        child: SafeArea(
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
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border(bottom: BorderSide(color: Colors.white10)),
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
              boxShadow: isActive ? [BoxShadow(color: EspyTheme.cyan.withValues(alpha: 0.3), blurRadius: 10)] : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return _buildStepFade(
          key: 'step0',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepTitle(l10n.tellUsAboutYourself),
              const SizedBox(height: 32),
              ProfileImagePicker(
                onImageSelected: (file, bytes) {
                  _profileImageFile = file;
                  _profileImageWebBytes = bytes;
                },
              ),
              const SizedBox(height: 32),
              _buildFieldLabel(l10n.institutionName),
              TextFormField(
                controller: _nameController,
                style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                decoration: const InputDecoration(hintText: 'e.g. Hope Medical Center'),
              ),
              const SizedBox(height: 24),
              _buildFieldLabel(l10n.institutionCategory.toUpperCase()),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _firestore.getCategories('institution'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(height: 64, child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: EspyTheme.gold)));
                  }
                  final categories = snapshot.data ?? [];
                  if (categories.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                      child: Text(l10n.noCategoriesFound.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 10, color: EspyTheme.platinum)),
                    );
                  }
                  final isAr = Localizations.localeOf(context).languageCode == 'ar';
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: EspyTheme.skyBlue.withValues(alpha: 0.3)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        dropdownColor: EspyTheme.platinum,
                        style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: EspyTheme.gold),
                        initialValue: _selectedCategoryId,
                        items: categories.map<DropdownMenuItem<String>>((cat) {
                          final name = (isAr ? cat['name_ar'] : cat['name_en']) ?? cat['name_en'] ?? 'OTHER';
                          return DropdownMenuItem<String>(
                            value: cat['id'].toString(),
                            child: Text(name.toString().toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedCategoryId = val),
                        decoration: InputDecoration(
                          hintText: l10n.selectCategory.toUpperCase(),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              _buildFieldLabel(l10n.registrationNumber),
              TextFormField(
                controller: _registrationController,
                style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                decoration: const InputDecoration(hintText: 'Official identifier'),
              ),
            ],
          ),
        );
      case 1:
        return _buildStepFade(
          key: 'step1',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel(l10n.missionDepartments),
              const SizedBox(height: 48),
              _buildFieldLabel("${l10n.aboutInstitution} (EN)"),
              TextFormField(
                controller: _bioController,
                style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe your clinical services and facilities...',
                ),
              ),
              const SizedBox(height: 24),
              _buildFieldLabel("${l10n.aboutInstitution} (AR)"),
              TextFormField(
                controller: _bioArController,
                style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                maxLines: 4,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  hintText: 'صف خدماتك السريرية ومرافقك...',
                ),
              ),
              const SizedBox(height: 24),
              DocumentPicker(
                label: 'Registration Documents',
                onDocumentSelected: (file, bytes, fileName) {
                  _proofFile = file;
                  _proofBytes = bytes;
                  _proofFileName = fileName;
                },
              ),
              const SizedBox(height: 24),
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
        return _buildStepFade(
          key: 'step2',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepTitle(l10n.hubLocations),
              const SizedBox(height: 32),
              _buildFieldLabel(l10n.primaryFacilityLocation),
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
                          style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, color: EspyTheme.mahogany)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildFieldLabel(l10n.secondaryPresenceNodes),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Text(
                  l10n.primaryNodeInfo,
                  style: GoogleFonts.lora(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      case 3:
        return _buildStepFade(
          key: 'step3',
          child: Column(
            children: [
              const SizedBox(height: 32),
              PremiumCard(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Icon(Icons.verified_user_rounded, size: 64, color: EspyTheme.success),
                    const SizedBox(height: 32),
                    Text(l10n.almostThere, style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 16),
                    Text(
                      l10n.institutionDashboardRedir,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lora(color: EspyTheme.noir.withValues(alpha: 0.6), height: 1.6),
                    ),
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

  Future<void> _openMainLocationPicker(AppLocalizations l10n) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationPickerModal(title: l10n.setMainNode),
    );
    if (result != null) {
      setState(() => _mainLocation = result);
    }
  }

  Widget _buildStepFade({required String key, required Widget child}) {
    return FadeInRight(key: ValueKey(key), duration: const Duration(milliseconds: 500), child: child);
  }

  Widget _buildStepTitle(String title) {
    return Text(title, style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.w900, color: EspyTheme.platinum, height: 1.1, letterSpacing: 1.5));
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10, color: EspyTheme.cyan, letterSpacing: 2)),
    );
  }

  Widget _buildBottomActions(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: EspyTheme.navyDeep,
        border: Border(top: BorderSide(color: Colors.white12)),
        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 20, offset: const Offset(0, -10))],
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            IconButton(
              onPressed: () => setState(() => _currentStep--),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.white38,
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: PremiumButton(
              label: _currentStep == 3 ? (_isSubmitting ? l10n.submitting.toUpperCase() : l10n.submitForReview) : l10n.continueText,
              onPressed: _isSubmitting ? null : _handleNext,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNext() async {
    final l10n = AppLocalizations.of(context)!;
    if (_currentStep < 3) {
      if (_currentStep == 0) {
        if (_nameController.text.isEmpty || _selectedCategoryId == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.nameAndCategoryRequired)));
          return;
        }
      }
      if (_currentStep == 2 && _mainLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.primaryNodeRequired)));
        return;
      }
      await _saveProgress();
      setState(() => _currentStep++);
    } else {
      _submitProfile();
    }
  }

  Future<void> _submitProfile() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final uid = auth.user?.uid;
    if (uid == null) return;

    setState(() => _isSubmitting = true);

    try {
      String? photoUrl;
      if (_profileImageWebBytes != null) {
        photoUrl = await _storage.uploadProfileImageWeb(userId: uid, bytes: _profileImageWebBytes!);
      } else if (_profileImageFile != null) {
        photoUrl = await _storage.uploadProfileImage(userId: uid, file: _profileImageFile!);
      }

      String? proofUrl;
      if (_proofBytes != null && _proofFileName != null) {
        proofUrl = await _storage.uploadIdentityProofWeb(userId: uid, bytes: _proofBytes!, fileName: _proofFileName!);
      } else if (_proofFile != null && _proofFileName != null) {
        proofUrl = await _storage.uploadIdentityProof(userId: uid, file: _proofFile!, fileName: _proofFileName!);
      }

      await _firestore.createProfessionalProfile(uid, {
        'fullNameEn': _nameController.text,
        'name': _nameController.text,
        'bio': _bioController.text,
        'bio_ar': _bioArController.text,
        'whatsapp': '${_whatsappCodeController.text}${_whatsappNumberController.text}',
        'whatsapp_code': _whatsappCodeController.text,
        'whatsapp_number': _whatsappNumberController.text,
        'registrationNumber': _registrationController.text,
        'categoryId': _selectedCategoryId,
        'photoUrl': photoUrl ?? auth.user?.photoURL,
        'proofUrl': proofUrl,
        'mainLocation': _mainLocation,
        'secondaryLocations': _secondaryLocations,
        'role': 'institution',
      });

      await _firestore.sendInAppNotification(
        userId: uid,
        title: l10n.instWelcomeTitle,
        message: l10n.instWelcomeMessage,
        type: 'welcome',
        actionUrl: '/wallet',
      );

      await auth.fetchUserData();
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l10n.submissionError}: $e')));
      }
    }
  }
}
