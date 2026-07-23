import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EspyIcon extends StatelessWidget {
  final String iconName;
  final double size;
  final Color? color;

  const EspyIcon({
    super.key,
    required this.iconName,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final IconData data = _getIconData(iconName);
    return Icon(data, size: size, color: color);
  }

  IconData _getIconData(String name) {
    switch (name.toLowerCase()) {
      case 'health':
      case 'heart':
        return LucideIcons.heartPulse;
      case 'mental_health':
      case 'brain':
        return LucideIcons.brain;
      case 'social':
      case 'users':
        return LucideIcons.users;
      case 'legal':
      case 'scale':
        return LucideIcons.scale;
      case 'other_care':
      case 'help':
        return LucideIcons.helpingHand;
      case 'globe':
        return LucideIcons.globe;
      case 'map_pin':
        return LucideIcons.mapPin;
      case 'tag':
        return LucideIcons.tag;
      case 'check':
        return LucideIcons.checkCircle;
      case 'alert':
        return LucideIcons.alertTriangle;
      case 'phone':
        return LucideIcons.phone;
      case 'mail':
        return LucideIcons.mail;
      case 'message':
        return LucideIcons.messageSquare;
      default:
        return LucideIcons.helpCircle;
    }
  }
}
