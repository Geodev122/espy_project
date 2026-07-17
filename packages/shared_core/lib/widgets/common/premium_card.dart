import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_core/theme/espy_theme.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? accentColor;
  final bool isGlass;
  final double borderRadius;

  const PremiumCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.accentColor,
    this.isGlass = false,
    this.borderRadius = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: (accentColor ?? EspyTheme.navy).withValues(alpha: isGlass ? 0.2 : 0.08),
            blurRadius: 40,
            spreadRadius: isGlass ? -10 : 0,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: isGlass ? 15 : 0,
            sigmaY: isGlass ? 15 : 0,
          ),
          child: Container(
            padding: padding ?? const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isGlass
                  ? Colors.white.withOpacity(0.08)
                  : EspyTheme.white,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: accentColor?.withOpacity(0.4) ??
                    (isGlass ? Colors.white.withOpacity(0.15) : EspyTheme.cyan.withOpacity(0.1)),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // Premium light edge highlight
                Positioned(
                  top: 0,
                  left: 40,
                  right: 40,
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: isGlass ? 0.3 : 0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
