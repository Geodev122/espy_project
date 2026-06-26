import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme.dart';
import 'package:shared_core/services/user_service.dart';
import 'package:shared_core/services/sound_service.dart';
import 'package:shared_core/services/storage_service.dart';
import '../../widgets/common/premium_button.dart';
import '../../widgets/common/premium_card.dart';
import '../../widgets/common/profile_image_picker.dart';

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
    final profile = Provider.of<UserService>(context, listen: false).profile ?? {};
    _nameController = TextEditingController(text: profile['fullNameEn'] ?? profile['name'] ?? '');
    _bioController = TextEditingController(text: profile['bio'] ?? '');
    _bioArController = TextEditingController(text: profile['bio_ar'] ?? '');
    _whatsappCodeController = TextEditingController(text: profile['whatsapp_code'] ?? '+961');
    _whatsappNumberController = TextEditingController(text: profile['whatsapp_number'] ?? '');
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
    final profile = userService.profile ?? {};
    final String role = profile['role']?.toString().toLowerCase() ?? 'visitor';
    final bool isVisitor = role == 'visitor';

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n.editProfileTitle.toUpperCase()),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: EspyTheme.lightBlueFlame),
        child: SingleChildScrollView(
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
          decoration: InputDecoration(
            fillColor: EspyTheme.cognac.withValues(alpha: 0.03),
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final userService = Provider.of<UserService>(context, listen: false);
    final storageService = Provider.of<StorageService>(context, listen: false);

    try {
      String? photoUrl;
      if (_profileImageWebBytes != null) {
        photoUrl = await storageService.uploadProfileImageWeb(userId: userService.userId, bytes: _profileImageWebBytes!);
      } else if (_profileImageFile != null) {
        photoUrl = await storageService.uploadProfileImage(userId: userService.userId, file: _profileImageFile!);
      }

      await userService.updateProfile({
        'fullNameEn': _nameController.text,
        'name': _nameController.text,
        'bio': _bioController.text,
        'bio_ar': _bioArController.text,
        'whatsapp_code': _whatsappCodeController.text,
        'whatsapp_number': _whatsappNumberController.text,
        'whatsapp': '${_whatsappCodeController.text}${_whatsappNumberController.text}',
        if (photoUrl != null) 'photoUrl': photoUrl,
      });

      SoundService.playSuccess();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
