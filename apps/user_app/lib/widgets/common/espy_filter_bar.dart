import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:espy_app/theme/espy_theme.dart';

class EspyFilterBar extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(String?) onSelected;
  final String label;

  const EspyFilterBar({
    super.key,
    required this.options,
    this.selectedOption,
    required this.onSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black38, letterSpacing: 1.5),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildChip(null, "ALL"),
              ...options.map((opt) => _buildChip(opt, opt.toUpperCase())),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String? value, String label) {
    final bool isSelected = selectedOption == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => onSelected(selected ? value : null),
        selectedColor: EspyTheme.royalBlue,
        checkmarkColor: Colors.white,
        backgroundColor: Colors.black.withValues(alpha: 0.03),
        side: BorderSide.none,
        labelStyle: GoogleFonts.montserrat(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: isSelected ? Colors.white : Colors.black54,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
