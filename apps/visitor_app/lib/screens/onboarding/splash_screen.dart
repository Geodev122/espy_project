// ─────────────────────────────────────────────────────────────────────────────
// Espy — SplashScreen  (Enhanced Cinematic v2)
// Hope, Healing, Humanity
//
// Animation sequence (total ≈ 3.6 s):
//
//   0.00 s  Background gradient fades in               (_bgCtrl  500 ms)
//   0.10 s  Particles begin drifting upward             (ParticleField — looping)
//   0.40 s  Double halo begins pulsing                 (_haloCtrl — looping 3 s)
//   0.50 s  Icon scales + fades in from 0.82 → 1.0     (_iconCtrl 900 ms easeOutCubic)
//   1.20 s  Gold shimmer ring sweeps once               (_shimmerCtrl 800 ms)
//   1.50 s  "Espy" wordmark fades in                   (_textCtrl  interval 0.0–0.5)
//   1.90 s  Gold rule fades in                         (_textCtrl  interval 0.4–0.7)
//   2.10 s  Tagline slides up + fades in               (_textCtrl  interval 0.6–1.0)
//   2.60 s  Progress bar fills left → right            (_progressCtrl 800 ms)
//   3.40 s  Fade-out entire screen → navigate          (_exitCtrl 400 ms)
//
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import '../../core/theme.dart';
import '../../widgets/common/particle_field.dart';

// ── Replace this import with your router. Two patterns shown: ────────────────
//    Pattern A (go_router):  import 'package:go_router/go_router.dart';
//    Pattern B (Navigator):  use _navigateForward() below — already wired.
// ─────────────────────────────────────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ─────────────────────────────────────────────────────────────
  late final AnimationController _bgCtrl;        // background fade-in
  late final AnimationController _haloCtrl;      // dual halo pulse (loops)
  late final AnimationController _iconCtrl;      // icon scale + opacity
  late final AnimationController _shimmerCtrl;   // gold ring sweep (one-shot)
  late final AnimationController _textCtrl;      // wordmark + rule + tagline
  late final AnimationController _progressCtrl;  // progress bar fill
  late final AnimationController _exitCtrl;      // fade-out before navigate

  // ── Animations ───────────────────────────────────────────────────────────────

  // Background
  late final Animation<double> _bgOpacity;

  // Halo — two rings at different radii and offsets
  late final Animation<double> _haloInner;
  late final Animation<double> _haloOuter;

  // Icon
  late final Animation<double> _iconScale;
  late final Animation<double> _iconOpacity;

  // Shimmer ring
  late final Animation<double> _shimmerAngle;  // 0 → 2π sweep
  late final Animation<double> _shimmerOpacity;

  // Text — staggered via Interval within one controller
  late final Animation<double> _wordmarkOpacity;
  late final Animation<double> _ruleOpacity;
  late final Animation<Offset>  _taglineSlide;
  late final Animation<double> _taglineOpacity;

  // Progress
  late final Animation<double> _progressValue;

  // Exit
  late final Animation<double> _exitOpacity;

  // ── State ────────────────────────────────────────────────────────────────────
  bool _hasNavigated = false;

  // ── Lifecycle ────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _buildControllers();
    _buildAnimations();
    _runSequence();
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _haloCtrl.dispose();
    _iconCtrl.dispose();
    _shimmerCtrl.dispose();
    _textCtrl.dispose();
    _progressCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  // ── Build controllers ────────────────────────────────────────────────────────
  void _buildControllers() {
    _bgCtrl       = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _haloCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat(reverse: true);
    _iconCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _shimmerCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _textCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _progressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _exitCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  // ── Build animations ─────────────────────────────────────────────────────────
  void _buildAnimations() {
    // Background
    _bgOpacity = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeIn);

    // Halo — inner ring leads, outer ring lags slightly
    _haloInner = Tween<double>(begin: 0.08, end: 0.20).animate(
        CurvedAnimation(parent: _haloCtrl,
            curve: const Interval(0.0, 1.0, curve: Curves.easeInOut)));
    _haloOuter = Tween<double>(begin: 0.03, end: 0.11).animate(
        CurvedAnimation(parent: _haloCtrl,
            curve: const Interval(0.15, 1.0, curve: Curves.easeInOut)));

    // Icon — spring-like arrival
    _iconScale = Tween<double>(begin: 0.82, end: 1.0).animate(
        CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOutCubic));
    _iconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _iconCtrl, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)));

    // Shimmer ring sweep
    _shimmerAngle = Tween<double>(begin: -math.pi / 2, end: 3 * math.pi / 2).animate(
        CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));
    _shimmerOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_shimmerCtrl);

    // Text — wordmark → rule → tagline (all driven by _textCtrl 0→1)
    _wordmarkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _textCtrl,
            curve: const Interval(0.0, 0.50, curve: Curves.easeOut)));
    _ruleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _textCtrl,
            curve: const Interval(0.40, 0.70, curve: Curves.easeOut)));
    _taglineSlide = Tween<Offset>(
        begin: const Offset(0, 0.5), end: Offset.zero).animate(
        CurvedAnimation(parent: _textCtrl,
            curve: const Interval(0.60, 1.00, curve: Curves.easeOutCubic)));
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _textCtrl,
            curve: const Interval(0.60, 1.00, curve: Curves.easeOut)));

    // Progress bar
    _progressValue = CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOut);

    // Exit fade-out
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn));
  }

  // ── Animation sequence ───────────────────────────────────────────────────────
  Future<void> _runSequence() async {
    // 1. Background
    await _bgCtrl.forward();

    // 2. Halo already looping. Short pause then icon.
    await Future.delayed(const Duration(milliseconds: 300));
    _iconCtrl.forward();

    // 3. Shimmer ring after icon peaks
    await Future.delayed(const Duration(milliseconds: 700));
    _shimmerCtrl.forward();

    // 4. Text stagger
    await Future.delayed(const Duration(milliseconds: 300));
    _textCtrl.forward();

    // 5. Progress bar
    await Future.delayed(const Duration(milliseconds: 500));
    await _progressCtrl.forward();

    // 6. Brief pause — let user absorb the brand
    await Future.delayed(const Duration(milliseconds: 400));

    // 7. Exit
    await _exitCtrl.forward();
    _navigateForward();
  }

  // ── Navigation ───────────────────────────────────────────────────────────────
  void _navigateForward() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    // ── Pattern A: go_router ──────────────────────────────────────────────────
    // context.go('/home');   // or '/onboarding' for first launch

    // ── Pattern B: Navigator (default) ───────────────────────────────────────
    Navigator.of(context).pushReplacementNamed('/home');
    // Replace '/home' with your route. For onboarding:
    // Navigator.of(context).pushReplacementNamed('/onboarding');
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: EspyTheme.navyDeep,
      body: AnimatedBuilder(
        animation: _exitCtrl,
        builder: (context, child) => Opacity(
          opacity: _exitOpacity.value,
          child: child,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [

            // ── Layer 1: Background gradient ─────────────────────────────────
            FadeTransition(
              opacity: _bgOpacity,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: EspyTheme.backgroundGradient,
                ),
              ),
            ),

            // ── Layer 2: Particle field ───────────────────────────────────────
            const ParticleField(),

            // ── Layer 3: Dual halo rings ──────────────────────────────────────
            _buildHalo(size),

            // ── Layer 4: Shimmer ring (one-shot sweep) ────────────────────────
            _buildShimmerRing(size),

            // ── Layer 5: App icon (Hero — morphs into auth screen) ────────────
            _buildIcon(size),

            // ── Layer 6: Bottom text composition ─────────────────────────────
            _buildBottomText(size),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // LAYER BUILDERS
  // ─────────────────────────────────────────────────────────────────────────────

  // ── Dual halo ────────────────────────────────────────────────────────────────
  Widget _buildHalo(Size size) {
    final center = size.center(Offset.zero);
    // Icon sits at vertical centre, but slightly above the absolute mid
    // because the text composition is below. Offset halo upward to match.
    final haloCenter = Offset(center.dx, center.dy - 60);

    return AnimatedBuilder(
      animation: _haloCtrl,
      builder: (_, __) => CustomPaint(
        painter: _HaloPainter(
          center: haloCenter,
          innerAlpha: _haloInner.value,
          outerAlpha: _haloOuter.value,
          innerRadius: 140,
          outerRadius: 210,
          colour: EspyTheme.skyBlue,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  // ── Gold shimmer sweep ring ───────────────────────────────────────────────────
  Widget _buildShimmerRing(Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 60);

    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (_, __) {
        if (!_shimmerCtrl.isAnimating && _shimmerCtrl.value == 0) {
          return const SizedBox.shrink();
        }
        return CustomPaint(
          painter: _ShimmerRingPainter(
            center: center,
            radius: 142,
            angle: _shimmerAngle.value,
            opacity: _shimmerOpacity.value,
            colour: EspyTheme.gold,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }

  // ── Icon ─────────────────────────────────────────────────────────────────────
  Widget _buildIcon(Size size) {
    // Icon occupies 55% of the narrower dimension (slightly smaller to avoid any OS circular clipping issues if layered)
    final iconSize = size.width * 0.55;

    return Align(
      alignment: const Alignment(0, -0.22),
      child: AnimatedBuilder(
        animation: _iconCtrl,
        builder: (_, child) => Transform.scale(
          scale: _iconScale.value,
          child: Opacity(
            opacity: _iconOpacity.value,
            child: child,
          ),
        ),
        child: Hero(
          tag: 'espy_icon',
          child: Container(
            padding: const EdgeInsets.all(32), // Deep padding to ensure no "square" clipping occurs
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.02),
            ),
            child: Image.asset(
              'assets/images/espy_icon.png',
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => _fallbackIcon(iconSize),
            ),
          ),
        ),
      ),
    );
  }

  // ── Bottom text block ─────────────────────────────────────────────────────────
  Widget _buildBottomText(Size size) {
    return Positioned(
      bottom: 52,
      left: 24,
      right: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // Wordmark: "Espy"
          FadeTransition(
            opacity: _wordmarkOpacity,
            child: Text(
              'Espy',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: EspyTheme.textWordmark,
                letterSpacing: 5,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Gold rule
          FadeTransition(
            opacity: _ruleOpacity,
            child: Container(
              height: 1.5,
              decoration: const BoxDecoration(
                gradient: EspyTheme.goldRule,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Tagline: "Hope, Healing, Humanity"
          SlideTransition(
            position: _taglineSlide,
            child: FadeTransition(
              opacity: _taglineOpacity,
              child: Text(
                'Hope, Healing, Humanity',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: EspyTheme.gold,
                  letterSpacing: 0.5,
                  height: 1.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Progress bar
          _buildProgressBar(),
        ],
      ),
    );
  }

  // ── Progress bar ──────────────────────────────────────────────────────────────
  Widget _buildProgressBar() {
    return FadeTransition(
      opacity: _wordmarkOpacity, // appears with wordmark
      child: AnimatedBuilder(
        animation: _progressCtrl,
        builder: (_, __) => Column(
          children: [
            // Track + fill
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: SizedBox(
                height: 2,
                child: LinearProgressIndicator(
                  value: _progressValue.value,
                  backgroundColor: EspyTheme.skyBlue.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    // Interpolate from skyBlue → gold as it fills
                    Color.lerp(
                      EspyTheme.skyBlue,
                      EspyTheme.gold,
                      _progressValue.value,
                    )!,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Pulsing orbs (3 dots)
            _buildOrbs(),
          ],
        ),
      ),
    );
  }

  // ── Pulsing orbs ──────────────────────────────────────────────────────────────
  Widget _buildOrbs() {
    return AnimatedBuilder(
      animation: _haloCtrl, // reuse halo controller for the pulse rhythm
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            // Each orb offset by 0.25 cycle
            final t = (_haloCtrl.value - i * 0.25).clamp(0.0, 1.0);
            final opacity = Curves.easeInOut.transform(t) * 0.65 + 0.2;
            final scale   = Curves.easeInOut.transform(t) * 0.4  + 0.6;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: EspyTheme.skyBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // ── Fallback icon (shown if asset missing) ────────────────────────────────────
  Widget _fallbackIcon(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: size * 0.28,
            color: EspyTheme.skyBlue,
          ),
          SizedBox(height: size * 0.06),
          Text(
            'ESPY',
            style: GoogleFonts.montserrat(
              fontSize: size * 0.12,
              fontWeight: FontWeight.w900,
              letterSpacing: size * 0.025,
              color: EspyTheme.textOnDark,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// CUSTOM PAINTERS
// ═════════════════════════════════════════════════════════════════════════════

/// Dual concentric halo rings — pulsing radial gradient circles.
class _HaloPainter extends CustomPainter {
  final Offset center;
  final double innerAlpha;
  final double outerAlpha;
  final double innerRadius;
  final double outerRadius;
  final Color colour;

  const _HaloPainter({
    required this.center,
    required this.innerAlpha,
    required this.outerAlpha,
    required this.innerRadius,
    required this.outerRadius,
    required this.colour,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Outer ring — larger, more diffuse
    canvas.drawCircle(
      center,
      outerRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            colour.withValues(alpha: outerAlpha),
            colour.withValues(alpha: outerAlpha * 0.4),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(
            Rect.fromCircle(center: center, radius: outerRadius)),
    );

    // Inner ring — smaller, more vivid
    canvas.drawCircle(
      center,
      innerRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            colour.withValues(alpha: innerAlpha),
            colour.withValues(alpha: innerAlpha * 0.3),
            Colors.transparent,
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(
            Rect.fromCircle(center: center, radius: innerRadius)),
    );
  }

  @override
  bool shouldRepaint(_HaloPainter old) =>
      old.innerAlpha != innerAlpha ||
          old.outerAlpha != outerAlpha ||
          old.center     != center;
}

/// Single gold arc that sweeps 360° around the icon — one-shot animation.
class _ShimmerRingPainter extends CustomPainter {
  final Offset center;
  final double radius;
  final double angle;    // current tip angle in radians
  final double opacity;
  final Color colour;

  const _ShimmerRingPainter({
    required this.center,
    required this.radius,
    required this.angle,
    required this.opacity,
    required this.colour,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;

    const arcLength = math.pi * 0.55; // how long the trailing arc is

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: angle - arcLength,
        endAngle: angle,
        colors: [
          colour.withValues(alpha: 0),
          colour.withValues(alpha: opacity),
        ],
        tileMode: TileMode.clamp,
        transform: const GradientRotation(0),
      ).createShader(
          Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      angle - arcLength,
      arcLength,
      false,
      paint,
    );

    // Bright dot at the tip
    final tipX = center.dx + radius * math.cos(angle);
    final tipY = center.dy + radius * math.sin(angle);
    canvas.drawCircle(
      Offset(tipX, tipY),
      3,
      Paint()..color = colour.withValues(alpha: opacity),
    );
  }

  @override
  bool shouldRepaint(_ShimmerRingPainter old) =>
      old.angle   != angle   ||
          old.opacity != opacity ||
          old.center  != center;
}
