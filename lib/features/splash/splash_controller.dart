import 'dart:async';
import 'package:flutter/material.dart';

/// Controls splash animation phases.
///
/// Timeline:
/// 0.5s  -> Logo appears
/// 1.5s  -> Brand name typewriter starts
/// 2.3s  -> Tagline fades/slides in
/// 3.2s  -> Powered By appears
/// 4.0s  -> Loading pulse appears
/// 4.8s  -> Navigate to Home
class SplashController {
  bool showLogo = false;
  bool showBrandName = false;
  bool showTagline = false;
  bool showPoweredBy = false;
  bool showPulse = false;

  final List<Timer> _timers = [];
  VoidCallback? _listener;

  void setListener(VoidCallback listener) {
    _listener = listener;
  }

  void startPhaseTimers() {
    _add(500, () => showLogo = true);

    _add(1500, () => showBrandName = true);

    _add(2300, () => showTagline = true);

    _add(3200, () => showPoweredBy = true);

    _add(4000, () => showPulse = true);
  }

  void _add(int ms, VoidCallback update) {
    _timers.add(
      Timer(Duration(milliseconds: ms), () {
        update();
        _listener?.call();
      }),
    );
  }

  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
  }
}