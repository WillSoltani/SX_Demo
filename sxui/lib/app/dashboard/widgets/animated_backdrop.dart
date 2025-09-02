// lib/app/dashboard/widgets/animated_backdrop.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sxui/app/theme/app_theme.dart';

class AnimatedBackdrop extends StatefulWidget {
  final Color accent;
  final AnimationController controller;
  final Offset pointer;

  const AnimatedBackdrop({
    super.key,
    required this.accent,
    required this.controller,
    required this.pointer,
  });

  @override
  State<AnimatedBackdrop> createState() => _AnimatedBackdropState();
}

class _AnimatedBackdropState extends State<AnimatedBackdrop> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final palette = theme.extension<AppPalette>()!;

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final t = widget.controller.value * 2 * math.pi;
        final dx = math.cos(t) * 120.0;
        final dy = math.sin(t) * 120.0;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                // layered panels + a hint of primary in both modes
                palette.panel,
                palette.panelAlt,
                cs.primary.withOpacity(theme.brightness == Brightness.dark ? 0.10 : 0.06),
              ],
            ),
          ),
          child: CustomPaint(
            painter: _GlowPainter(
              color: widget.accent.withOpacity(theme.brightness == Brightness.dark ? 0.20 : 0.12),
              center: widget.pointer + Offset(dx, dy),
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}

class _GlowPainter extends CustomPainter {
  final Color color;
  final Offset center;

  _GlowPainter({required this.color, required this.center});

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide * 0.35;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r, paint);
  }

  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.center != center;
}
