import 'package:flutter/material.dart';
import 'package:espy_app/theme/espy_theme.dart';

class RoleBrandedWrapper extends StatelessWidget {
  final String role;
  final Widget child;
  final bool useBorder;
  final bool useShadow;

  const RoleBrandedWrapper({
    super.key,
    required this.role,
    required this.child,
    this.useBorder = true,
    this.useShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isInstitution = role.toLowerCase() == 'institution';
    final Color brandColor = isInstitution ? EspyTheme.gold : EspyTheme.royalBlue;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: useBorder ? Border.all(color: brandColor.withValues(alpha: 0.2), width: 1.5) : null,
        boxShadow: useShadow ? [
          BoxShadow(
            color: brandColor.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ] : null,
      ),
      child: child,
    );
  }
}
