import 'package:flutter/material.dart';
import 'package:shared_core/theme/espy_theme.dart';

enum ShimmerVariant { light, dark, blue }

class ShimmerWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final ShimmerVariant variant;

  const ShimmerWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.variant = ShimmerVariant.light,
  });

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
              colors: _getColors(),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }

  List<Color> _getColors() {
    switch (widget.variant) {
      case ShimmerVariant.blue:
        return [
          EspyTheme.electricBlue.withOpacity(0.2),
          EspyTheme.cyan,
          EspyTheme.electricBlue.withOpacity(0.2),
        ];
      case ShimmerVariant.dark:
        return [
          Colors.white.withOpacity(0.05),
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.05),
        ];
      case ShimmerVariant.light:
        return [
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.8),
          Colors.white.withOpacity(0.1),
        ];
    }
  }
}
