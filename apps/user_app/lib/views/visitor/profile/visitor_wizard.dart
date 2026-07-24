import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:espy_core/espy_core.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/profile_image_picker.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';

class VisitorWizard extends StatefulWidget {
  const VisitorWizard({super.key});

  @override
  State<VisitorWizard> createState() => _VisitorWizardState();
}

class _VisitorWizardState extends State<VisitorWizard> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _whatsappCodeController = TextEditingController(text: '+961');
  final _whatsappNumberController = TextEditingController();

  File? _profileImageFile;
  Uint8List? _profileImageWebBytes;

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
          l10n.protocolRegistration.toUpperCase(),
          style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, letterSpacing: 2, color: EspyTheme.platinum, fontSize: 14),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: FadeInUp(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.welcomeToNetwork,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(height: 1.1, color: EspyTheme.platinum, fontSize: 24),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ProfileImagePicker(
                      onImageSelected: (file, bytes) {
                        _profileImageFile = file;
                        _profileImageWebBytes = bytes;
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildLabel(l10n.legalFullName.toUpperCase()),
                  TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: l10n.legalFullNameHint,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Name required' : null,
                  ),
                  const SizedBox(height: 24),
                  _buildLabel(l10n.whatsappContact.toUpperCase()),
                  Row(
                    children: [
                      SizedBox(
                        width: 90,
                        child: TextFormField(
                          controller: _whatsappCodeController,
                          style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14, fontWeight: FontWeight.w600),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '+961',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _whatsappNumberController,
                          style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14, fontWeight: FontWeight.w600),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'XX XXX XXX',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  PremiumButton(
                    label: _isSubmitting ? l10n.saving.toUpperCase() : "COMPLETE REGISTRATION",
                    fullWidth: true,
                    isLoading: _isSubmitting,
                    onPressed: _isSubmitting ? null : _submitProfile,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      "BY COMPLETING REGISTRATION YOU AGREE TO THE PROTOCOL TERMS.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(fontSize: 9, color: Colors.white38, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w800, color: EspyTheme.cyan, letterSpacing: 1)),
    );
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
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

      final existingUser = auth.userData;
      if (existingUser == null) return;

      final updatedUser = UserModel(
        id: auth.user!.uid,
        email: existingUser.email,
        name: _nameController.text.trim(),
        whatsapp: '${_whatsappCodeController.text}${_whatsappNumberController.text}',
        photoUrl: photoUrl ?? auth.user?.photoURL,
        role: UserRole.visitor,
        isActive: true,
        hasProfile: true,
        createdAt: existingUser.createdAt,
        updatedAt: DateTime.now(),
      );

      await repo.updateUser(auth.user!.uid, updatedUser);

      await auth.fetchUserData();
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: EspyTheme.error));
      }
    }
  }
}
