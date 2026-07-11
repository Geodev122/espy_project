import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';

class WhatsappInput extends StatefulWidget {
  final String? initialCode;
  final String? initialNumber;
  final Function(String code, String number) onChanged;

  const WhatsappInput({
    super.key,
    this.initialCode,
    this.initialNumber,
    required this.onChanged,
  });

  @override
  State<WhatsappInput> createState() => _WhatsappInputState();
}

class _WhatsappInputState extends State<WhatsappInput> {
  late String _code;
  late TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    _code = widget.initialCode ?? '+961';
    _numberController = TextEditingController(text: widget.initialNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          width: 90,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _code,
              dropdownColor: Colors.white,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              style: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.w900, color: EspyTheme.navy),
              items: ['+961', '+971', '+966', '+1', '+44', '+33', '+49'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _code = val);
                  widget.onChanged(_code, _numberController.text);
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _numberController,
            keyboardType: TextInputType.phone,
            onChanged: (val) => widget.onChanged(_code, val),
            style: GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'WhatsApp Number',
              hintStyle: GoogleFonts.lora(fontSize: 14, color: EspyTheme.navy.withOpacity(0.3)),
              prefixIcon: Icon(Icons.chat_bubble_outline_rounded, color: Colors.green.shade400, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
