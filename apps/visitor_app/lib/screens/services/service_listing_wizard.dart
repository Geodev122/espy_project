import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/services/user_service.dart';
import 'package:shared_core/services/storage_service.dart';
import 'package:shared_core/services/sound_service.dart';
import '../../widgets/common/premium_button.dart';
import '../../widgets/common/whatsapp_input.dart';

// Use package:file or similar if needed, but for now we just guard the io usages
// ignore: avoid_web_libraries_in_flutter
import 'dart:io' as io;

class ServiceListingWizard extends StatefulWidget {
  final Map<String, dynamic>? initialService;
  const ServiceListingWizard({super.key, this.initialService});

  @override
  State<ServiceListingWizard> createState() => _ServiceListingWizardState();
}

class _ServiceListingWizardState extends State<ServiceListingWizard> {
  int _currentStep = 0;
  XFile? _imageFile;
  Uint8List? _webImageBytes;
  
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  
  String? _selectedPricingTagId;
  String _locationType = 'online'; // 'online', 'main', 'secondary'
  
  String _whatsappCode = '+961';
  String _whatsappNumber = '';
  bool _useDefaultWhatsapp = true;

  String? _selectedSlotId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialService != null) {
      _titleController.text = widget.initialService!['title'] ?? '';
      _descController.text = widget.initialService!['description'] ?? '';
      // Map other initial fields if editing
    }
  }

  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    if (kIsWeb) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _webImageBytes = bytes);
    } else {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'CROP SERVICE PREVIEW',
            toolbarColor: EspyTheme.noir,
            toolbarWidgetColor: EspyTheme.gold,
            activeControlsWidgetColor: EspyTheme.gold,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'CROP PREVIEW'),
        ],
      );

      if (croppedFile != null) {
        setState(() => _imageFile = XFile(croppedFile.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n.serviceProtocol.toUpperCase()),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: EspyTheme.lightBlueFlame),
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildProgress(),
            Expanded(child: _buildCurrentStep(l10n)),
            _buildActions(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: (_currentStep + 1) / 2, // Changed from 3 to 2
          minHeight: 6,
          backgroundColor: EspyTheme.navyDeep.withOpacity(0.05),
          valueColor: const AlwaysStoppedAnimation<Color>(EspyTheme.royalBlue),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0: return _stepIdentity(l10n);
      case 1: return _stepPresence(l10n);
      default: return const SizedBox();
    }
  }

  Widget _stepIdentity(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.identityAndContent.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 16, color: EspyTheme.navyDeep, letterSpacing: 2)),
          const SizedBox(height: 32),
          Text(l10n.pricingProtocolHint.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 2)),
          const SizedBox(height: 12),
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: FirestoreService().getServicePricingTags(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator(color: EspyTheme.royalBlue);
              }
              final tags = snapshot.data ?? [];
              if (tags.isEmpty) {
                return Text(l10n.noPricingTags.toUpperCase(), style: GoogleFonts.lora(fontSize: 11, color: EspyTheme.navyDeep.withOpacity(0.4)));
              }
              return DropdownButtonFormField<String>(
                initialValue: _selectedPricingTagId,
                dropdownColor: EspyTheme.platinum,
                items: tags.map<DropdownMenuItem<String>>((t) {
                  final locale = Localizations.localeOf(context).languageCode;
                  final label = (locale == 'ar' ? t['label_ar'] : t['label_en']) ?? t['label_en'] ?? 'NONE';
                  return DropdownMenuItem<String>(
                    value: t['id'] as String,
                    child: Text(label.toString().toUpperCase(), style: GoogleFonts.cinzel(fontSize: 12, fontWeight: FontWeight.w900)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedPricingTagId = val),
                decoration: InputDecoration(
                  hintText: l10n.selectPricingHint.toUpperCase(),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)
                ),
              );
            },
          ),
          if (_selectedPricingTagId != null) ...[
            const SizedBox(height: 12),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: FirestoreService().getServicePricingTags(),
              builder: (context, snapshot) {
                final tag = (snapshot.data ?? []).firstWhere((t) => t['id'] == _selectedPricingTagId, orElse: () => {});
                final locale = Localizations.localeOf(context).languageCode;
                final hint = (locale == 'ar' ? tag['hint_ar'] : tag['hint_en']) ?? tag['hint_en'];
                if (hint == null) return const SizedBox();
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: EspyTheme.royalBlue.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: EspyTheme.royalBlue, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(hint, style: GoogleFonts.lora(fontSize: 12, fontStyle: FontStyle.italic, color: EspyTheme.navyDeep))),
                    ],
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 32),
          GestureDetector(
            onTap: _pickAndCropImage,
            child: Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: EspyTheme.royalBlue.withOpacity(0.2), width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)
                ],
                image: _webImageBytes != null 
                  ? DecorationImage(image: MemoryImage(_webImageBytes!), fit: BoxFit.cover)
                  : (_imageFile != null && !kIsWeb)
                    ? DecorationImage(image: FileImage(io.File(_imageFile!.path)), fit: BoxFit.cover)
                    : null,
              ),
              child: _imageFile == null 
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_a_photo_rounded, color: EspyTheme.royalBlue, size: 40),
                      const SizedBox(height: 16),
                      Text(l10n.uploadPreview.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2, color: EspyTheme.royalBlue)),
                    ],
                  )
                : const SizedBox(),
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _titleController,
            style: GoogleFonts.montserrat(color: EspyTheme.navyDeep, fontSize: 14),
            decoration: InputDecoration(
              labelText: l10n.serviceTitle.toUpperCase(),
              labelStyle: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep.withOpacity(0.5)),
            )
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _descController,
            maxLines: 4,
            style: GoogleFonts.lora(color: EspyTheme.navyDeep, fontSize: 14),
            decoration: InputDecoration(
              labelText: l10n.description.toUpperCase(),
              labelStyle: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep.withOpacity(0.5)),
            )
          ),
        ],
      ),
    );
  }

  Widget _stepPresence(AppLocalizations l10n) {
    final userService = Provider.of<UserService>(context);
    final profile = userService.profile ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.reachAndContact.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 16, color: EspyTheme.navyDeep, letterSpacing: 2)),
          const SizedBox(height: 32),
          Text(l10n.locationAttachment.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 2)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'online', groupValue: _locationType,
                  activeColor: EspyTheme.royalBlue,
                  title: Text(l10n.onlineDelivery, style: GoogleFonts.lora(fontSize: 14, fontWeight: FontWeight.bold)),
                  onChanged: (val) => setState(() => _locationType = val!)
                ),
                Divider(height: 1, color: EspyTheme.navyDeep.withOpacity(0.05), indent: 16, endIndent: 16),
                RadioListTile<String>(
                  value: 'main', groupValue: _locationType,
                  activeColor: EspyTheme.royalBlue,
                  title: Text('${l10n.primaryHub} (${profile['mainLocation']?['cityName'] ?? 'Beirut'})', style: GoogleFonts.lora(fontSize: 14, fontWeight: FontWeight.bold)),
                  onChanged: (val) => setState(() => _locationType = val!)
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(l10n.whatsappConfig.toUpperCase(), style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue, letterSpacing: 2)),
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text(l10n.useProfileDefault, style: GoogleFonts.lora(fontSize: 14, fontWeight: FontWeight.bold)),
            value: _useDefaultWhatsapp, 
            activeThumbColor: EspyTheme.royalBlue,
            onChanged: (val) => setState(() => _useDefaultWhatsapp = val)
          ),
          if (!_useDefaultWhatsapp)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: WhatsappInput(onChanged: (code, number) {
                _whatsappCode = code;
                _whatsappNumber = number;
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        border: Border(top: BorderSide(color: EspyTheme.navyDeep.withOpacity(0.05), width: 1))
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            IconButton(
              onPressed: () => setState(() => _currentStep--), 
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: EspyTheme.navyDeep.withOpacity(0.4),
            ),
          const Spacer(),
          PremiumButton(
            label: _isSubmitting ? l10n.listing.toUpperCase() : (_currentStep == 1 ? l10n.listService.toUpperCase() : l10n.continueText.toUpperCase()),
            variant: PremiumButtonVariant.gold,
            onPressed: _isSubmitting ? null : () {
              if (_currentStep < 1) {
                setState(() => _currentStep++);
              } else {
                _finalizeListing(l10n);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _finalizeListing(AppLocalizations l10n) async {
    final firestore = Provider.of<FirestoreService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    final storage = StorageService();

    setState(() => _isSubmitting = true);

    try {
      String? imageUrl;
      final userId = userService.profile?['uid'];
      
      if (kIsWeb && _webImageBytes != null) {
        imageUrl = await storage.uploadServiceImageWeb(userId: userId, bytes: _webImageBytes!);
      } else if (_imageFile != null) {
        imageUrl = await storage.uploadServiceImage(userId: userId, file: io.File(_imageFile!.path));
      }

      await firestore.createService({
        'title': _titleController.text,
        'description': _descController.text,
        'locationType': _locationType,
        'pricingTagId': _selectedPricingTagId,
        'professionalId': userId,
        'whatsapp': _useDefaultWhatsapp ? null : {'code': _whatsappCode, 'number': _whatsappNumber},
        'isAllocated': false, // Decoupled: Starts as hidden until allocated in manager
        'isActive': true,
        'imageUrl': imageUrl, 
      });

      SoundService.playSuccess();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Listing Error: $e')));
      }
    }
  }
}
