import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';

import '../../core/theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/services/storage_service.dart';
import '../../widgets/common/premium_button.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/profile_image_picker.dart';
import '../../widgets/common/cinematic_background.dart';

class VisitorWizard extends StatefulWidget {
  const VisitorWizard({super.key});

  @override
  State<VisitorWizard> createState() => _VisitorWizardState();
}

class _VisitorWizardState extends State<VisitorWizard> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _whatsappCodeController = TextEditingController(text: '+961');
  final _whatsappNumberController = TextEditingController();

  File? _profileImageFile;
  Uint8List? _profileImageWebBytes;

  final FirestoreService _firestore = FirestoreService();
  final StorageService _storage = StorageService();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthService>(context, listen: false);
    _nameController.text = auth.user?.displayName ?? '';
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
          style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, letterSpacing: 4, color: EspyTheme.platinum),
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
        color: Colors.white.withOpacity(0.05),
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(2, (index) {
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
              boxShadow: isActive ? [BoxShadow(color: EspyTheme.cyan.withOpacity(0.3), blurRadius: 10)] : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return FadeInRight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.welcomeToNetwork,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(height: 1.1, color: EspyTheme.platinum),
              ),
              const SizedBox(height: 32),
              ProfileImagePicker(
                onImageSelected: (file, bytes) {
                  _profileImageFile = file;
                  _profileImageWebBytes = bytes;
                },
              ),
              const SizedBox(height: 32),
              _buildFieldLabel(l10n.displayName),
              TextFormField(
                controller: _nameController,
                style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                decoration: InputDecoration(hintText: l10n.legalFullNameHint),
              ),
              const SizedBox(height: 32),
              _buildFieldLabel(l10n.whatsappOptional),
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      controller: _whatsappCodeController,
                      style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                      decoration: InputDecoration(hintText: l10n.whatsappCodeHint),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _whatsappNumberController,
                      style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
                      decoration: InputDecoration(hintText: l10n.whatsappNumberHint),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case 1:
        return FadeInRight(
          child: Column(
            children: [
              const SizedBox(height: 32),
              PremiumCard(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, size: 64, color: EspyTheme.teal),
                    const SizedBox(height: 32),
                    Text(l10n.readyToExplore, style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 16),
                    Text(
                      l10n.profileSet,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lora(color: EspyTheme.noir.withOpacity(0.6), height: 1.6),
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
        color: EspyTheme.navy,
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
              label: _currentStep == 1 ? (_isSubmitting ? l10n.saving.toUpperCase() : l10n.enterSuite) : l10n.continueText,
              onPressed: _isSubmitting ? null : _handleNext,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNext() async {
    if (_currentStep < 1) {
      setState(() => _currentStep++);
    } else {
      _submitProfile();
    }
  }

  Future<void> _submitProfile() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    setState(() => _isSubmitting = true);

    try {
      String? photoUrl;
      if (_profileImageWebBytes != null) {
        photoUrl = await _storage.uploadProfileImageWeb(userId: auth.user!.uid, bytes: _profileImageWebBytes!);
      } else if (_profileImageFile != null) {
        photoUrl = await _storage.uploadProfileImage(userId: auth.user!.uid, file: _profileImageFile!);
      }

      await _firestore.updateVisitorProfile(auth.user!.uid, {
        'name': _nameController.text,
        'whatsapp': '${_whatsappCodeController.text}${_whatsappNumberController.text}',
        'whatsapp_code': _whatsappCodeController.text,
        'whatsapp_number': _whatsappNumberController.text,
        'photoUrl': photoUrl ?? auth.user?.photoURL,
        'role': 'visitor',
        'isActive': true, // Forced active for new visitors
        'hasProfile': true,
      });

      // Refresh auth state to trigger MainGate rebuild
      await auth.fetchUserData();
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
