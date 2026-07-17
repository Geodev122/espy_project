import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/sound_service.dart';

class ProfileImagePicker extends StatefulWidget {
  final String? initialUrl;
  final Function(File?, Uint8List?) onImageSelected;

  const ProfileImagePicker({
    super.key,
    this.initialUrl,
    required this.onImageSelected,
  });

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _imageFile;
  Uint8List? _webImage;

  Future<void> _pickImage() async {
    HapticFeedback.mediumImpact();
    SoundService.playPop();

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imageFile = null;
        });
        widget.onImageSelected(null, bytes);
      } else {
        // Crop on mobile
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'CROP IDENTITY PHOTO',
              toolbarColor: EspyTheme.navy,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: EspyTheme.cyan,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            ),
            IOSUiSettings(title: 'CROP IDENTITY'),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _imageFile = File(croppedFile.path);
            _webImage = null;
          });
          widget.onImageSelected(File(croppedFile.path), null);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: EspyTheme.navy.withOpacity(0.05),
              border: Border.all(color: EspyTheme.electricBlue.withOpacity(0.3), width: 4),
              boxShadow: [
                BoxShadow(
                  color: EspyTheme.electricBlue.withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 2,
                )
              ],
              image: _webImage != null
                  ? DecorationImage(image: MemoryImage(_webImage!), fit: BoxFit.cover)
                  : (_imageFile != null
                      ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                      : (widget.initialUrl != null
                          ? DecorationImage(image: NetworkImage(widget.initialUrl!), fit: BoxFit.cover)
                          : null)),
            ),
            child: (_webImage == null && _imageFile == null && widget.initialUrl == null)
                ? Icon(Icons.person_add_rounded, size: 50, color: EspyTheme.electricBlue.withOpacity(0.4))
                : null,
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: EspyTheme.flameBlue,
                  boxShadow: [
                    BoxShadow(color: EspyTheme.electricBlue.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 4))
                  ]
                ),
                child: const Icon(Icons.camera_enhance_rounded, size: 22, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
