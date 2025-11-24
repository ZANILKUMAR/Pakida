import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/spinner_model.dart';

class SpinnerWheel extends StatelessWidget {
  final List<SpinnerSegment> segments;
  final bool isSpinning;
  final SpinnerSegment? selectedSegment;

  const SpinnerWheel({
    super.key,
    required this.segments,
    required this.isSpinning,
    required this.selectedSegment,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedRotation(
            turns: isSpinning ? 6 : 0,
            duration: Duration(milliseconds: isSpinning ? 2800 : 0),
            curve: Curves.easeOutCubic,
            child: CustomPaint(
              size: const Size(280, 280),
              painter: _SpinnerWheelPainter(
                segments: segments,
                highlight: selectedSegment,
              ),
            ),
          ),
          Positioned(
            top: 8,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -8,
            child: CustomPaint(
              size: const Size(40, 40),
              painter: _PointerPainter(),
            ),
          ),
          if (selectedSegment != null)
            Positioned(
              bottom: 0,
              child: Column(
                children: [
                  Text(
                    'Result',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selectedSegment!.color,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: selectedSegment!.color.withOpacity(0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Text(
                      selectedSegment!.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
                  .animate()
                  .scale(duration: 300.ms, curve: Curves.elasticOut)
                  .fadeIn(duration: 300.ms),
            ),
        ],
      ),
    );
  }
}

class _SpinnerWheelPainter extends CustomPainter {
  final List<SpinnerSegment> segments;
  final SpinnerSegment? highlight;

  _SpinnerWheelPainter({
    required this.segments,
    required this.highlight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final double sweepAngle = (2 * pi) / segments.length;

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      paint.color = segment == highlight
          ? segment.color.withOpacity(0.95)
          : segment.color.withOpacity(0.85);
      final Path path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          -pi / 2 + sweepAngle * i,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, paint);

      // draw text
      final double textAngle =
          -pi / 2 + sweepAngle * i + sweepAngle / 2;
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: segment.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final double textRadius = radius * 0.65;
      final Offset textOffset = Offset(
        center.dx + textRadius * cos(textAngle) - textPainter.width / 2,
        center.dy + textRadius * sin(textAngle) - textPainter.height / 2,
      );
      canvas.save();
      canvas.translate(textOffset.dx + textPainter.width / 2,
          textOffset.dy + textPainter.height / 2);
      canvas.rotate(textAngle + pi / 2);
      canvas.translate(
          -textPainter.width / 2, -textPainter.height / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawShadow(path, Colors.black.withOpacity(0.4), 4, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

