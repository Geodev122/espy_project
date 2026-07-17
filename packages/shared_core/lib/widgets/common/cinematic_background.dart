import 'package:flutter/material.dart';
import 'package:shared_core/theme/espy_theme.dart';

class CinematicBackground extends StatefulWidget {
  final Widget? child;
  const CinematicBackground({super.key, this.child});

  @override
  State<CinematicBackground> createState() => _CinematicBackgroundState();
}

class _CinematicBackgroundState extends State<CinematicBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Base Gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: EspyTheme.metallicNoir,
                ),
              ),
              // Animated Radial Glow (Espy Blue Flame)
              Positioned(
                top: -150 + (30 * _glowController.value),
                right: -150,
                child: Opacity(
                  opacity: 0.25,
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          EspyTheme.cyan.withOpacity(0.6),
                          Colors.transparent
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -100 - (20 * _glowController.value),
                left: -100,
                child: Opacity(
                  opacity: 0.15,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          EspyTheme.electricBlue.withOpacity(0.5),
                          Colors.transparent
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.child != null) widget.child!,
            ],
          );
        },
      ),
    );
  }
}
