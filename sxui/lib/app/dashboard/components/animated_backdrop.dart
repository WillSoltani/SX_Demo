import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedBackdrop extends StatelessWidget {
  final Color accent;
  final AnimationController controller;
  final Offset pointer;
  const AnimatedBackdrop({super.key, required this.accent, required this.controller, required this.pointer});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value * 2 * math.pi;
        final blob1 = Offset(math.cos(t) * 0.25, math.sin(t) * 0.2);
        final blob2 = Offset(math.cos(-t * 0.7) * -0.3, math.sin(-t * 0.7) * 0.25);
        final size = MediaQuery.of(context).size;

        return Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _GlowPainter(accent, blob1, blob2))),
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      (size.width == 0) ? 0 : (pointer.dx / size.width) * 2 - 1,
                      (size.height == 0) ? 0 : (pointer.dy / size.height) * 2 - 1,
                    ),
                    radius: 1.1,
                    colors: [accent.withOpacity(0.14), Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GlowPainter extends CustomPainter {
  final Color accent;
  final Offset blob1;
  final Offset blob2;
  _GlowPainter(this.accent, this.blob1, this.blob2);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);
    p.color = accent.withOpacity(0.10);
    canvas.drawCircle(Offset(size.width * (0.5 + blob1.dx), size.height * (0.4 + blob1.dy)), size.width * 0.35, p);
    p.color = Colors.purpleAccent.withOpacity(0.08);
    canvas.drawCircle(Offset(size.width * (0.4 + blob2.dx), size.height * (0.6 + blob2.dy)), size.width * 0.30, p);
  }
  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) => true;
}
