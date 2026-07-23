import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:espy_app/theme/espy_theme.dart';

class MultiSelectChipGroup extends StatefulWidget {
  final List<Map<String, dynamic>> options;
  final List<String> initialSelectedIds;
  final Function(List<String> selectedIds) onChanged;
  final String label;

  const MultiSelectChipGroup({
    super.key,
    required this.options,
    required this.initialSelectedIds,
    required this.onChanged,
    required this.label,
  });

  @override
  State<MultiSelectChipGroup> createState() => _MultiSelectChipGroupState();
}

class _MultiSelectChipGroupState extends State<MultiSelectChipGroup> {
  late List<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = List<String>.from(widget.initialSelectedIds);
  }

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
    widget.onChanged(_selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            widget.label.toUpperCase(),
            style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.bold, color: EspyTheme.gold, letterSpacing: 1),
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.options.map((opt) {
            final bool isSelected = _selectedIds.contains(opt['id']);
            return FilterChip(
              label: Text(opt['nameEn']?.toString().toUpperCase() ?? 'N/A'),
              selected: isSelected,
              onSelected: (_) => _toggle(opt['id']),
              selectedColor: EspyTheme.royalBlue,
              checkmarkColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              labelStyle: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : Colors.white70,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
