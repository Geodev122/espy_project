import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import 'package:shared_core/services/sound_service.dart';

enum PremiumButtonVariant { electric, cyan, gold, glass, outline, platinum }
enum PremiumButtonSize { small, medium, large }

class PremiumButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final PremiumButtonVariant variant;
  final PremiumButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final bool haptic;

  const PremiumButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = PremiumButtonVariant.electric,
    this.size = PremiumButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
    this.haptic = true,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _pressController.forward();
      if (widget.haptic) HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _pressController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      _pressController.reverse();
    }
  }

  void _handlePressed() {
    if (widget.onPressed != null && !widget.isLoading) {
      SoundService.playClick();
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOutline = widget.variant == PremiumButtonVariant.outline;
    final bool isPlatinum = widget.variant == PremiumButtonVariant.platinum;

    final Color contentColor = isOutline ? EspyTheme.electricBlue : (isPlatinum ? EspyTheme.navyDeep : Colors.white);

    final double verticalPadding = widget.size == PremiumButtonSize.small ? 12 : (widget.size == PremiumButtonSize.large ? 22 : 18);
    final double horizontalPadding = widget.size == PremiumButtonSize.small ? 16 : 24;
    final double fontSize = widget.size == PremiumButtonSize.small ? 10 : (widget.size == PremiumButtonSize.large ? 14 : 12);
    final double borderRadius = 20.0;

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: fontSize * 1.5,
              height: fontSize * 1.5,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(contentColor),
              ),
            ),
          )
        else if (widget.icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              widget.icon,
              size: fontSize * 1.6,
              color: contentColor,
            ),
          ),
        Text(
          widget.label.toUpperCase(),
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w900,
            fontSize: fontSize,
            letterSpacing: 2.5,
            color: contentColor,
          ),
        ),
      ],
    );

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handlePressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: widget.fullWidth ? double.infinity : null,
          child: Container(
            decoration: _getBoxDecoration(borderRadius),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
                child: Center(child: buttonContent),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getBoxDecoration(double radius) {
    if (widget.variant == PremiumButtonVariant.outline) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: EspyTheme.electricBlue.withValues(alpha: 0.5), width: 2),
      );
    }

    if (widget.variant == PremiumButtonVariant.glass) {
      return BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      );
    }

    if (widget.variant == PremiumButtonVariant.platinum) {
      return BoxDecoration(
        color: EspyTheme.platinum,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      );
    }

    return BoxDecoration(
      gradient: _getGradient(),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: _getShadowColor().withValues(alpha: 0.35),
          blurRadius: 20,
          spreadRadius: -5,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  LinearGradient _getGradient() {
    switch (widget.variant) {
      case PremiumButtonVariant.cyan:
        return EspyTheme.cyanFlame;
      case PremiumButtonVariant.gold:
        return EspyTheme.metallicGold;
      case PremiumButtonVariant.electric:
      default:
        return EspyTheme.flameBlue;
    }
  }

  Color _getShadowColor() {
    switch (widget.variant) {
      case PremiumButtonVariant.cyan:
        return EspyTheme.cyan;
      case PremiumButtonVariant.gold:
        return EspyTheme.gold;
      case PremiumButtonVariant.electric:
      default:
        return EspyTheme.electricBlue;
    }
  }
}
