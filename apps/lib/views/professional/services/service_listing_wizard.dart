import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/l10n/app_localizations.dart';

import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/firestore_service.dart';
import 'package:shared_core/services/user_service.dart';
import 'package:shared_core/services/storage_service.dart';
import 'package:shared_core/services/sound_service.dart';
import 'package:shared_core/widgets/common/premium_button.dart';
import 'package:shared_core/widgets/common/whatsapp_input.dart';
import 'package:shared_core/widgets/common/espy_scaffold.dart';

import 'dart:io' as io;

class ServiceListingWizard extends StatefulWidget {
  final Map<String, dynamic>? initialService;
  const ServiceListingWizard({super.key, this.initialService});

  @override
  State<ServiceListingWizard> createState() => _ServiceListingWizardState();
}

class _ServiceListingWizardState extends State<ServiceListingWizard> {
  final FirestoreService _firestore = FirestoreService();
  int _currentStep = 0;
  XFile? _imageFile;
  Uint8List? _webImageBytes;
  
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  
  String? _selectedPricingTagId;
  String _allocationType = 'main';
  String? _selectedSecondaryPinId;

  String? _manualCountryId;
  String? _manualGovernorateId;
  String? _manualCityId;
  
  String _whatsappCode = '+961';
  String _whatsappNumber = '';
  bool _useDefaultWhatsapp = true;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialService != null) {
      _titleController.text = widget.initialService!['title'] ?? '';
      _descController.text = widget.initialService!['description'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EspyScaffold(
      useCinematicBackground: true,
      appBar: AppBar(
        title: Text(l10n.serviceProtocol.toUpperCase(), style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white, fontSize: 13)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildProgress(),
          Expanded(child: _buildCurrentStep(l10n)),
          _buildActions(l10n),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: (_currentStep + 1) / 2, 
          backgroundColor: Colors.white10,
          valueColor: const AlwaysStoppedAnimation<Color>(EspyTheme.gold),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0: return _stepIdentity(l10n);
      case 1: return _stepAllocation(l10n);
      default: return const SizedBox();
    }
  }

  Widget _stepIdentity(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.identityAndContent.toUpperCase(), style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white, letterSpacing: 1.5)),
          const SizedBox(height: 32),
          _buildImagePicker(l10n),
          const SizedBox(height: 32),
          _buildTextField(_titleController, l10n.serviceTitle.toUpperCase()),
          const SizedBox(height: 24),
          _buildTextField(_descController, l10n.description.toUpperCase(), maxLines: 4),
        ],
      ),
    );
  }

  Widget _buildImagePicker(AppLocalizations l10n) {
    return GestureDetector(
      onTap: _pickAndCropImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white24)),
        child: (_imageFile == null && _webImageBytes == null)
          ? Center(child: Icon(Icons.add_a_photo, color: EspyTheme.gold, size: 40))
          : ClipRRect(borderRadius: BorderRadius.circular(24), child: Image(image: kIsWeb ? MemoryImage(_webImageBytes!) : FileImage(io.File(_imageFile!.path)) as ImageProvider, fit: BoxFit.cover)),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.gold)),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24))),
        ),
      ],
    );
  }

  Widget _stepAllocation(AppLocalizations l10n) {
    final userService = Provider.of<UserService>(context);
    final profile = userService.profile ?? {};
    final secondaryPins = profile['secondaryLocations'] as List? ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ALLOCATION & ANCHORS', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white, letterSpacing: 1.5)),
          const SizedBox(height: 32),
          RadioListTile<String>(
            value: 'main', groupValue: _allocationType,
            activeColor: EspyTheme.gold,
            title: Text('PRIMARY HUB PIN', style: const TextStyle(color: Colors.white)),
            onChanged: (val) => setState(() => _allocationType = val!)
          ),
          if (secondaryPins.isNotEmpty)
            RadioListTile<String>(
              value: 'secondary', groupValue: _allocationType,
              activeColor: EspyTheme.gold,
              title: Text('SPECIFIC PRACTICE PIN', style: const TextStyle(color: Colors.white)),
              onChanged: (val) => setState(() => _allocationType = val!)
            ),
          RadioListTile<String>(
            value: 'slot', groupValue: _allocationType,
            activeColor: EspyTheme.gold,
            title: Text('SERVICE SLOT (MANUAL)', style: const TextStyle(color: Colors.white)),
            onChanged: (val) => setState(() => _allocationType = val!)
          ),
        ],
      ),
    );
  }

  Widget _buildActions(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentStep > 0) IconButton(onPressed: () => setState(() => _currentStep--), icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
          const Spacer(),
          PremiumButton(
            label: _currentStep == 1 ? l10n.listService : l10n.continueText,
            isLoading: _isSubmitting,
            onPressed: () {
              if (_currentStep == 0) {
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

  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    if (kIsWeb) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _webImageBytes = bytes);
    } else {
      setState(() => _imageFile = pickedFile);
    }
  }

  Future<void> _finalizeListing(AppLocalizations l10n) async {
    setState(() => _isSubmitting = true);
    // Logic to save service...
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      SoundService.playSuccess();
      Navigator.pop(context);
    }
  }
}
