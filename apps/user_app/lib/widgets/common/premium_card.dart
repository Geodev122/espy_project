import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:espy_app/theme/espy_theme.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? accentColor;
  final bool isGlass;
  final double borderRadius;

  const PremiumCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.accentColor,
    this.isGlass = false,
    this.borderRadius = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: (accentColor ?? EspyTheme.navyDeep).withOpacity(isGlass ? 0.2 : 0.06),
            blurRadius: 30,
            spreadRadius: isGlass ? -8 : 0,
            offset: const Offset(0, 15),
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
                  : Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: accentColor?.withOpacity(0.3) ??
                    (isGlass ? Colors.white.withOpacity(0.15) : EspyTheme.platinum),
                width: 1.2,
              ),
            ),
            child: Stack(
              children: [
                // Subtle edge highlight
                Positioned(
                  top: 0,
                  left: 30,
                  right: 30,
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(isGlass ? 0.2 : 0.5),
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
