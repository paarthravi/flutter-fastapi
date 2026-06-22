import 'package:flutter/material.dart';
import '../splash_controller.dart';

class AnimatedLogoWidget extends StatefulWidget {
  final SplashController controller;
  final VoidCallback onLoaded;

  const AnimatedLogoWidget({
    super.key,
    required this.controller,
    required this.onLoaded,
  });

  @override
  State<AnimatedLogoWidget> createState() => _AnimatedLogoWidgetState();
}

class _AnimatedLogoWidgetState extends State<AnimatedLogoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.80,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.startPhaseTimers();
      widget.onLoaded();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = size.width * 0.40;

    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: logoSize * 1.8,
              height: logoSize * 1.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1496D4).withOpacity(0.20),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),

            Image.asset(
              'assets/images/gogenericlogo.png',
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}