import 'package:flutter/material.dart';
import '../../core/theme.dart';

class AdminBadge extends StatelessWidget {
  final String variant;
  final Widget children;
  final double? fontSize;

  const AdminBadge({
    super.key,
    required this.variant,
    required this.children,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bg;

    switch (variant) {
      case 'gold':
        color = EspyTheme.gold;
        bg = EspyTheme.gold.withOpacity(0.1);
        break;
      case 'emerald':
      case 'success':
        color = Colors.green;
        bg = Colors.green.withOpacity(0.1);
        break;
      case 'danger':
      case 'error':
        color = Colors.redAccent;
        bg = Colors.redAccent.withOpacity(0.1);
        break;
      case 'teal':
      case 'cyan':
        color = EspyTheme.cyan;
        bg = EspyTheme.cyan.withOpacity(0.1);
        break;
      case 'outline':
        color = Colors.white38;
        bg = Colors.white.withOpacity(0.1);
        break;
      default:
        color = EspyTheme.electricBlue;
        bg = EspyTheme.electricBlue.withOpacity(0.1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: DefaultTextStyle(
        style: EspyTheme.cinzelStyle.copyWith(
          fontSize: fontSize ?? 8,
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        child: children,
      ),
    );
  }
}
