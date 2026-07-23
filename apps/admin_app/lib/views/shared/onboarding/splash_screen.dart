import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/widgets/common/particle_field.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import 'package:espy_app/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _haloCtrl;
  late final AnimationController _iconCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _progressCtrl;
  late final AnimationController _exitCtrl;

  late final Animation<double> _bgOpacity;
  late final Animation<double> _haloInner;
  late final Animation<double> _haloOuter;
  late final Animation<double> _iconScale;
  late final Animation<double> _iconOpacity;
  late final Animation<double> _shimmerAngle;
  late final Animation<double> _shimmerOpacity;
  late final Animation<double> _wordmarkOpacity;
  late final Animation<double> _ruleOpacity;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _progressValue;
  late final Animation<double> _exitOpacity;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _buildControllers();
    _buildAnimations();
    _runSequence();
  }

  void _buildControllers() {
    _bgCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _haloCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat(reverse: true);
    _iconCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _textCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _progressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _exitCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  void _buildAnimations() {
    _bgOpacity = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeIn);
    _haloInner = Tween<double>(begin: 0.08, end: 0.20).animate(CurvedAnimation(parent: _haloCtrl, curve: const Interval(0.0, 1.0, curve: Curves.easeInOut)));
    _haloOuter = Tween<double>(begin: 0.03, end: 0.11).animate(CurvedAnimation(parent: _haloCtrl, curve: const Interval(0.15, 1.0, curve: Curves.easeInOut)));
    _iconScale = Tween<double>(begin: 0.82, end: 1.0).animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOutCubic));
    _iconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _iconCtrl, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)));
    _shimmerAngle = Tween<double>(begin: -math.pi / 2, end: 3 * math.pi / 2).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));
    _shimmerOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_shimmerCtrl);
    _wordmarkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textCtrl, curve: const Interval(0.0, 0.50, curve: Curves.easeOut)));
    _ruleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textCtrl, curve: const Interval(0.40, 0.70, curve: Curves.easeOut)));
    _taglineSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _textCtrl, curve: const Interval(0.60, 1.00, curve: Curves.easeOutCubic)));
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textCtrl, curve: const Interval(0.60, 1.00, curve: Curves.easeOut)));
    _progressValue = CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOut);
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn));
  }

  Future<void> _runSequence() async {
    await _bgCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _iconCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    _shimmerCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    await _progressCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    await _exitCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose(); _haloCtrl.dispose(); _iconCtrl.dispose(); _shimmerCtrl.dispose(); _textCtrl.dispose(); _progressCtrl.dispose(); _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return EspyScaffold(
      useCinematicBackground: false,
      extendBodyBehindAppBar: true,
      body: AnimatedBuilder(
        animation: _exitCtrl,
        builder: (context, child) => Opacity(opacity: _exitOpacity.value, child: child),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FadeTransition(opacity: _bgOpacity, child: Container(decoration: const BoxDecoration(gradient: EspyTheme.backgroundGradient))),
            const ParticleField(),
            _buildHalo(size),
            _buildShimmerRing(size),
            _buildIcon(size),
            _buildBottomText(size),
          ],
        ),
      ),
    );
  }

  Widget _buildHalo(Size size) {
    return AnimatedBuilder(
      animation: _haloCtrl,
      builder: (_, __) => Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 120),
          child: CustomPaint(
            painter: _HaloPainter(
              center: Offset.zero,
              innerAlpha: _haloInner.value,
              outerAlpha: _haloOuter.value,
              innerRadius: 140,
              outerRadius: 210,
              colour: EspyTheme.skyBlue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerRing(Size size) {
    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (_, __) => !_shimmerCtrl.isAnimating && _shimmerCtrl.value == 0 ? const SizedBox.shrink() : Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 120),
          child: CustomPaint(
            painter: _ShimmerRingPainter(
              center: Offset.zero,
              radius: 142,
              angle: _shimmerAngle.value,
              opacity: _shimmerOpacity.value,
              colour: EspyTheme.gold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(Size size) {
    final iconSize = size.width * 0.55;
    return Align(
      alignment: const Alignment(0, -0.22),
      child: AnimatedBuilder(
        animation: _iconCtrl,
        builder: (_, child) => Transform.scale(scale: _iconScale.value, child: Opacity(opacity: _iconOpacity.value, child: child)),
        child: Hero(tag: 'espy_icon', child: Image.asset('assets/images/espy_icon.png', width: iconSize, height: iconSize, fit: BoxFit.contain)),
      ),
    );
  }

  Widget _buildBottomText(Size size) {
    final l10n = AppLocalizations.of(context)!;
    return Positioned(
      bottom: 52, left: 24, right: 24,
      child: Column(
        children: [
          FadeTransition(opacity: _wordmarkOpacity, child: Text(l10n.appTitle, style: GoogleFonts.montserrat(fontSize: 38, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 5))),
          const SizedBox(height: 10),
          FadeTransition(opacity: _ruleOpacity, child: Container(height: 1.5, decoration: const BoxDecoration(gradient: EspyTheme.goldRule))),
          const SizedBox(height: 10),
          SlideTransition(position: _taglineSlide, child: FadeTransition(opacity: _taglineOpacity, child: Text(l10n.hopeHealingHumanity.toUpperCase(), style: GoogleFonts.playfairDisplay(fontSize: 15, fontStyle: FontStyle.italic, color: EspyTheme.gold)))),
          const SizedBox(height: 24),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return FadeTransition(
      opacity: _wordmarkOpacity,
      child: AnimatedBuilder(
        animation: _progressCtrl,
        builder: (_, __) => ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(height: 2, child: LinearProgressIndicator(value: _progressValue.value, backgroundColor: Colors.white10, valueColor: AlwaysStoppedAnimation<Color>(EspyTheme.gold))),
        ),
      ),
    );
  }
}

class _HaloPainter extends CustomPainter {
  final Offset center; final double innerAlpha; final double outerAlpha; final double innerRadius; final double outerRadius; final Color colour;
  _HaloPainter({required this.center, required this.innerAlpha, required this.outerAlpha, required this.innerRadius, required this.outerRadius, required this.colour});
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(center, outerRadius, Paint()..shader = RadialGradient(colors: [colour.withValues(alpha: outerAlpha), Colors.transparent]).createShader(Rect.fromCircle(center: center, radius: outerRadius)));
    canvas.drawCircle(center, innerRadius, Paint()..shader = RadialGradient(colors: [colour.withValues(alpha: innerAlpha), Colors.transparent]).createShader(Rect.fromCircle(center: center, radius: innerRadius)));
  }
  @override
  bool shouldRepaint(_HaloPainter old) => old.innerAlpha != innerAlpha || old.outerAlpha != outerAlpha;
}

class _ShimmerRingPainter extends CustomPainter {
  final Offset center; final double radius; final double angle; final double opacity; final Color colour;
  _ShimmerRingPainter({required this.center, required this.radius, required this.angle, required this.opacity, required this.colour});
  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), angle - 1.5, 1.5, false, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = colour.withValues(alpha: opacity));
  }
  @override
  bool shouldRepaint(_ShimmerRingPainter old) => old.angle != angle || old.opacity != opacity;
}
