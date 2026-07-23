import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:espy_app/theme/espy_theme.dart';

class AdminDataRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onEdit;
  final bool isCopyable;

  const AdminDataRow({
    super.key,
    required this.label,
    required this.value,
    this.onEdit,
    this.isCopyable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label.toUpperCase(),
              style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black38),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600, color: EspyTheme.navyDeep),
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit_note_rounded, size: 18, color: EspyTheme.gold),
              onPressed: onEdit,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
