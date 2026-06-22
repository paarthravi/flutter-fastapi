import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../screens/chat_list_screen.dart';
import 'splash_controller.dart';
import 'widgets/animated_logo_widget.dart';


// ─────────────────────────────────────────────────────────────────────────────
// Brand constants
// ─────────────────────────────────────────────────────────────────────────────
const _kPrimaryBlue = Color(0xFF1496D4);
const _kAccentPink  = Color(0xFFFF5C97);
const _kTagline     = 'Digital Solutions for All Your\nHealthcare Needs';

    /// GO GENERIC Healthcare
    // 1. Gradient background
    // 2. Logo reveal
    // 3. GO GENERIC Healthcare typewriter
    // 4. Tagline slide-up
    // 5. Powered By slide-up
    // 6. Pulse dots
    // 7. Fade transition to ChatList
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final SplashController _controller;
  late final AnimationController _fadeOutCtrl;
  Timer? _navTimer;

  bool _bgVisible = false;

  String _typedBrand = '';
  bool _typewriterStarted = false;


  @override
  void initState() {
    super.initState();

    _fadeOutCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _controller = SplashController()
      ..setListener(() {

        if (_controller.showBrandName &&
            !_typewriterStarted) {
          _typewriterStarted = true;
          _startTypewriter();
        }

        if (mounted) {
          setState(() {});
        }
      });

    // Phase 1: start background fade on first rendered frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _bgVisible = true);
    });

    // Start fade-out overlay at 4.2 s, navigate at 4.8 s
    _navTimer = Timer(const Duration(milliseconds: 4200), () {
      if (mounted) _fadeOutCtrl.forward();
    });
    Timer(const Duration(milliseconds: 4800), _navigateToHome);
  }

  void _startTypewriter() {
    const text = 'GO GENERIC Healthcare';

    int index = 0;

    Timer.periodic(
      const Duration(milliseconds: 80),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (index >= text.length) {
          timer.cancel();
          return;
        }

        setState(() {
          _typedBrand = text.substring(0, index + 1);
        });

        index++;
      },
    );
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ChatListScreen(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) =>
                FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _fadeOutCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: Stack(
        children: [
          // Main animated splash content
          AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: _bgVisible ? 1.0 : 0.0,
            child: _buildGradientBackground(context),
          ),

          // White overlay that fades in to transition away
          AnimatedBuilder(
            animation: _fadeOutCtrl,
            builder: (context, _) => IgnorePointer(
              child: Opacity(
                opacity: _fadeOutCtrl.value,
                child: Container(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8FBFF),
            Color(0xFFD6EBFF),
            Color(0xFFC2E2FF),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Ambient glow blobs
          _ambientGlow(size),

          // Main content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogoSection(),
                  const SizedBox(height: 8),
                  _buildBrandName(),
                  const SizedBox(height: 12),
                  _buildTagline(),
                  const SizedBox(height: 24),
                  _buildPoweredBy(),
                  const SizedBox(height: 32),
                  _buildPulseIndicator(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Ambient glow blobs ───────────────────────────────────────────────────

  Widget _ambientGlow(Size size) {
    return Positioned.fill(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 900),
        opacity: _bgVisible ? 1.0 : 0.0,
        child: Stack(
          children: [
            // Top-right teal glow
            Positioned(
              top: -size.width * 0.25,
              right: -size.width * 0.2,
              child: _glowCircle(size.width * 0.75, _kPrimaryBlue, 0.18),
            ),
            // Bottom-left pink glow
            Positioned(
              bottom: -size.width * 0.2,
              left: -size.width * 0.15,
              child: _glowCircle(size.width * 0.6, _kAccentPink, 0.12),
            ),
            // Centre soft blue
            Positioned(
              top: size.height * 0.25,
              left: size.width * 0.1,
              child: _glowCircle(size.width * 0.8, _kPrimaryBlue, 0.07),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle(double diameter, Color color, double opacity) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 700),
      opacity: _controller.showLogo ? 1 : 0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutBack,
        scale: _controller.showLogo ? 1 : 0.8,
        child: AnimatedLogoWidget(
          controller: _controller,
          onLoaded: () {},
        ),
      ),
    );
  }

  Widget _buildLogoTextFallback() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFFD6EBFF), Color(0xFFC2E2FF)],
        ),
        border: Border.all(color: _kPrimaryBlue, width: 3),
      ),
      child: Center(
        child: Text(
          'GG',
          style: GoogleFonts.poppins(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: _kPrimaryBlue,
          ),
        ),
      ),
    );
  }

  // ── Brand name ────────────────────────────────────────────────────────────

  Widget _buildBrandName() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 700),
      opacity: _controller.showBrandName ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        offset: _controller.showBrandName
            ? Offset.zero
            : const Offset(0, 0.35),
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              _kPrimaryBlue,
              Color(0xFF0E7AB8),
            ],
          ).createShader(bounds),
          child: Text(
            _typedBrand,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  // ── Tagline ───────────────────────────────────────────────────────────────

  Widget _buildTagline() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: _controller.showTagline ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        offset: _controller.showTagline
            ? Offset.zero
            : const Offset(0, 0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            _kTagline,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              height: 1.65,
              color: const Color(0xFF4B5F7F),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPoweredBy() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 700),
      opacity: _controller.showPoweredBy ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        offset: _controller.showPoweredBy
            ? Offset.zero
            : const Offset(0, 0.3),
        child: Column(
          children: [
            Text(
              'Powered By',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7A90),
              ),
            ),

            const SizedBox(height: 14),

            Container(
              width: 260,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.75),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Singhania Med',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _kPrimaryBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Pulse loading indicator ───────────────────────────────────────────────

  Widget _buildPulseIndicator() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: _controller.showPulse ? 1.0 : 0.0,
      child: const _PulsingDots(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pulsing dots indicator
// ─────────────────────────────────────────────────────────────────────────────

class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final t = ((_anim.value + i * 0.33) % 1.0);
            final scale = 0.6 + 0.6 * (t < 0.5 ? t * 2 : (1 - t) * 2);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == 1
                        ? _kAccentPink
                        : _kPrimaryBlue.withValues(alpha: 0.7),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
