import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class ParticleField extends StatefulWidget {
  const ParticleField({super.key});
  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final rng = math.Random(42);
    _particles = List.generate(18, (_) => _Particle.random(rng));
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ctrl,
    builder: (_, __) => CustomPaint(
      painter: _ParticlePainter(_particles, _ctrl.value),
      child: const SizedBox.expand(),
    ),
  );
}

class _Particle {
  final double x, startY, radius, speed, phase;
  const _Particle({required this.x, required this.startY,
    required this.radius, required this.speed, required this.phase});
  factory _Particle.random(math.Random r) => _Particle(
    x: r.nextDouble(), startY: 0.7 + r.nextDouble() * 0.3,
    radius: 1.2 + r.nextDouble() * 2.2,
    speed: 0.15 + r.nextDouble() * 0.2, phase: r.nextDouble(),
  );
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  const _ParticlePainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final progress = ((t * (1 / p.speed)) + p.phase) % 1.0;
      final y = (p.startY - progress * p.startY) * size.height;
      final opacity = progress < 0.2 ? progress / 0.2
          : progress > 0.75 ? (1.0 - progress) / 0.25 : 1.0;
      canvas.drawCircle(
        Offset(p.x * size.width, y), p.radius,
        Paint()
          ..color = EspyTheme.skyBlue.withValues(alpha: opacity * 0.45)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}
