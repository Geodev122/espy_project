import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';

class DocumentPicker extends StatefulWidget {
  final String label;
  final Function(File? file, Uint8List? bytes, String? fileName) onDocumentSelected;
  
  const DocumentPicker({
    super.key, 
    required this.label, 
    required this.onDocumentSelected
  });

  @override
  State<DocumentPicker> createState() => _DocumentPickerState();
}

class _DocumentPickerState extends State<DocumentPicker> {
  String? _fileName;

  Future<void> _pickDocument() async {
    try {
      debugPrint("Opening file picker...");
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
        withData: kIsWeb, // Important for web
      );

      if (result != null) {
        final platformFile = result.files.single;
        debugPrint("File picked: ${platformFile.name}");
        
        setState(() {
          _fileName = platformFile.name;
        });

        if (kIsWeb) {
          widget.onDocumentSelected(null, platformFile.bytes, _fileName);
        } else {
          widget.onDocumentSelected(File(platformFile.path!), null, _fileName);
        }
      } else {
        debugPrint("File picker canceled.");
      }
    } catch (e) {
      debugPrint('Error picking document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.cyan, letterSpacing: 2),
        ),
        const SizedBox(height: 12),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _pickDocument,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Icon(
                    _fileName != null ? Icons.description_rounded : Icons.upload_file_rounded,
                    color: _fileName != null ? EspyTheme.gold : Colors.white38,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _fileName ?? 'Upload Proof of Registration / License (PDF/Image)',
                      style: GoogleFonts.lora(
                        color: _fileName != null ? Colors.white : Colors.white38,
                        fontSize: 13,
                        fontStyle: _fileName == null ? FontStyle.italic : FontStyle.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_fileName != null)
                    const Icon(Icons.check_circle_rounded, color: EspyTheme.teal, size: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
