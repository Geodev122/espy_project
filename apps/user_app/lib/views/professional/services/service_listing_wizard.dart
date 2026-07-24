import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:espy_app/l10n/app_localizations.dart';

import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/user_service.dart';
import 'package:espy_app/viewmodels/sound_service.dart';
import 'package:espy_app/viewmodels/espy_repository.dart';
import 'package:espy_app/widgets/common/multi_select_chip_group.dart';
import 'package:espy_app/widgets/common/hierarchical_location_picker.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import '../../../models/service_model.dart';
import '../../../models/city_model.dart';
import '../../../models/enums.dart';

import 'dart:io' as io;

class ServiceListingWizard extends StatefulWidget {
  final ServiceModel? initialService;
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
  
  String _allocationType = 'main';
  String? _selectedPriceTagId;
  List<String> _selectedTagIds = [];
  String _deliveryMode = 'FACE_TO_FACE';
  CityModel? _customLocation;

  @override
  void initState() {
    super.initState();
    if (widget.initialService != null) {
      _titleController.text = widget.initialService!.titleEn;
      _descController.text = widget.initialService!.descriptionEn ?? '';
      _deliveryMode = widget.initialService!.deliveryMode.name.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text(l10n.listNewService.toUpperCase(), style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) setState(() => _currentStep++);
          else _submit();
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
        },
        steps: [
          Step(
            title: const Text("IDENTITY"),
            content: _buildIdentityStep(l10n),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text("PROTOCOL"),
            content: _buildProtocolStep(l10n),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text("LOCATION"),
            content: _buildLocationStep(l10n),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityStep(AppLocalizations l10n) {
    return Column(
      children: [
        _buildImagePicker(),
        const SizedBox(height: 24),
        TextField(controller: _titleController, decoration: const InputDecoration(labelText: "SERVICE TITLE")),
        const SizedBox(height: 16),
        TextField(controller: _descController, maxLines: 3, decoration: const InputDecoration(labelText: "DESCRIPTION")),
      ],
    );
  }

  Widget _buildProtocolStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("DELIVERY MODE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: ['FACE_TO_FACE', 'ONLINE', 'FIELD'].map((mode) => ChoiceChip(
            label: Text(mode),
            selected: _deliveryMode == mode,
            onSelected: (v) => setState(() => _deliveryMode = mode),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationStep(AppLocalizations l10n) {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text("Main Hub"),
          value: 'main',
          groupValue: _allocationType,
          onChanged: (v) => setState(() => _allocationType = v!),
        ),
        RadioListTile<String>(
          title: const Text("Custom Presence Node"),
          value: 'custom',
          groupValue: _allocationType,
          onChanged: (v) => setState(() => _allocationType = v!),
        ),
        if (_allocationType == 'custom')
          HierarchicalLocationPicker(onCitySelected: (city) => setState(() => _customLocation = city)),
      ],
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final img = await picker.pickImage(source: ImageSource.gallery);
        if (img != null) {
          final bytes = await img.readAsBytes();
          setState(() {
            _imageFile = img;
            _webImageBytes = bytes;
          });
        }
      },
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(24)),
        child: _webImageBytes != null 
          ? ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.memory(_webImageBytes!, fit: BoxFit.cover))
          : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo_rounded, size: 40, color: Colors.black26), Text("ADD PROTOCOL IMAGE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black26))]),
      ),
    );
  }

  Future<void> _submit() async {
    final repo = context.read<EspyRepository>();
    final userService = context.read<UserService>();
    
    // Implementation of service creation
    SoundService.playSuccess();
    Navigator.pop(context);
  }
}
