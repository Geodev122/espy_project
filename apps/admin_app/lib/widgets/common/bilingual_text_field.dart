import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:espy_app/theme/espy_theme.dart';

class BilingualTextField extends StatelessWidget {
  final TextEditingController controllerEn;
  final TextEditingController controllerAr;
  final String labelEn;
  final String labelAr;
  final int maxLines;

  const BilingualTextField({
    super.key,
    required this.controllerEn,
    required this.controllerAr,
    required this.labelEn,
    required this.labelAr,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSingleField(controllerEn, labelEn, TextDirection.ltr),
        const SizedBox(height: 16),
        _buildSingleField(controllerAr, labelAr, TextDirection.rtl),
      ],
    );
  }

  Widget _buildSingleField(TextEditingController controller, String label, TextDirection direction) {
    return Column(
      crossAxisAlignment: direction == TextDirection.ltr ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.gold, letterSpacing: 1),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          textDirection: direction,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
