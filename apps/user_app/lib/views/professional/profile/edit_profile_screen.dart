import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/l10n/app_localizations.dart';
import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/user_service.dart';
import 'package:espy_app/viewmodels/sound_service.dart';
import 'package:espy_app/viewmodels/storage_service.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/premium_card.dart';
import 'package:espy_app/widgets/common/profile_image_picker.dart';
import 'package:espy_app/widgets/common/location_picker_modal.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import '../../../models/user_model.dart';
import '../../../models/enums.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _bioArController;
  late TextEditingController _whatsappCodeController;
  late TextEditingController _whatsappNumberController;

  File? _profileImageFile;
  Uint8List? _profileImageWebBytes;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<UserService>(context, listen: false).profile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _bioController = TextEditingController(text: profile?['bio'] ?? '');
    _bioArController = TextEditingController(text: profile?['bio_ar'] ?? '');
    _whatsappCodeController = TextEditingController(text: profile?['whatsapp_code'] ?? '+961');
    _whatsappNumberController = TextEditingController(text: profile?['whatsapp_number'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _bioArController.dispose();
    _whatsappCodeController.dispose();
    _whatsappNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userService = Provider.of<UserService>(context);
    final profile = userService.profile;
    final bool isVisitor = profile?.role == UserRole.visitor;

    return EspyScaffold(
      useCinematicBackground: true,
      appBar: AppBar(
        title: Text(l10n.editProfileTitle.toUpperCase()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileImagePicker(
                onImageSelected: (file, bytes) {
                  setState(() {
                    _profileImageFile = file;
                    _profileImageWebBytes = bytes;
                  });
                },
              ),
              const SizedBox(height: 32),
              PremiumCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildTextField(_nameController, l10n.fullName.toUpperCase()),
                    if (!isVisitor) ...[
                      const SizedBox(height: 20),
                      _buildTextField(_bioController, l10n.bioEn.toUpperCase(), maxLines: 3),
                      const SizedBox(height: 20),
                      _buildTextField(_bioArController, l10n.bioAr.toUpperCase(), maxLines: 3, isRtl: true),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 80,
                          child: _buildTextField(_whatsappCodeController, l10n.code.toUpperCase()),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(_whatsappNumberController, l10n.whatsappNumber.toUpperCase()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PremiumButton(
                label: 'UPDATE LOCATION ANCHORS',
                variant: PremiumButtonVariant.outline,
                fullWidth: true,
                icon: Icons.location_on_rounded,
                onPressed: _updateLocation,
              ),
              const SizedBox(height: 32),
              PremiumButton(
                label: _isSaving ? l10n.syncing.toUpperCase() : l10n.saveChanges.toUpperCase(),
                fullWidth: true,
                onPressed: _isSaving ? null : _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, bool isRtl = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.gold, letterSpacing: 1)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          style: const TextStyle(color: EspyTheme.navyDeep),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Future<void> _updateLocation() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LocationPickerModal(title: 'UPDATE LOCATION'),
    );
    if (result != null) {
      final userService = Provider.of<UserService>(context, listen: false);
      if (userService.profile == null) return;

      setState(() => _isSaving = true);
      try {
        final current = userService.profile!;
        final updated = UserModel(
          id: current.id,
          email: current.email,
          name: current.name,
          role: current.role,
          isActive: current.isActive,
          hasProfile: current.hasProfile,
          createdAt: current.createdAt,
          updatedAt: DateTime.now(),
          rawData: {
            ...current.rawData,
            'mainLocation': result,
            'countryId': result['countryId'],
            'governorateId': result['governorateId'],
            'cityId': result['cityId'],
          },
        );
        await userService.updateProfile(updated);
        SoundService.playSuccess();
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final userService = Provider.of<UserService>(context, listen: false);
    if (userService.profile == null) return;

    setState(() => _isSaving = true);
    final storageService = Provider.of<StorageService>(context, listen: false);
    try {
      String? photoUrl;
      if (_profileImageWebBytes != null) {
        photoUrl = await storageService.uploadProfileImageWeb(userId: userService.userId, bytes: _profileImageWebBytes!);
      } else if (_profileImageFile != null) {
        photoUrl = await storageService.uploadProfileImage(userId: userService.userId, file: _profileImageFile!);
      }
      
      final current = userService.profile!;
      final updated = UserModel(
        id: current.id,
        email: current.email,
        name: _nameController.text,
        photoUrl: photoUrl ?? current.photoUrl,
        whatsapp: '${_whatsappCodeController.text}${_whatsappNumberController.text}',
        role: current.role,
        isActive: current.isActive,
        hasProfile: current.hasProfile,
        createdAt: current.createdAt,
        updatedAt: DateTime.now(),
        rawData: {
          ...current.rawData,
          'bio': _bioController.text,
          'bio_ar': _bioArController.text,
          'whatsapp_code': _whatsappCodeController.text,
          'whatsapp_number': _whatsappNumberController.text,
        }
      );
      
      await userService.updateProfile(updated);
      SoundService.playSuccess();
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
