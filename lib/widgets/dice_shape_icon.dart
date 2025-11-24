import 'dart:math';

import 'package:flutter/material.dart';
import '../models/dice_model.dart';

class DiceShapeIcon extends StatelessWidget {
  final DiceType type;
  final double size;
  final bool isRolling;
  final bool showValue;

  const DiceShapeIcon({
    super.key,
    required this.type,
    this.size = 48,
    this.isRolling = false,
    this.showValue = true,
  });

  @override
  Widget build(BuildContext context) {
    final _DiceIconStyle style = _DiceIconStyle.fromType(type);
    final widget = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PolygonPainter(
          sides: style.polygonSides,
          fillColor: style.fillColor,
          strokeColor: style.borderColor,
        ),
        child: Center(
          child: showValue
              ? Text(
                  '${type.sides}',
                  style: TextStyle(
                    color: style.textColor,
                    fontSize: size * 0.32,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
      ),
    );

    if (!isRolling) return widget;

    return AnimatedRotation(
      turns: 2,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCirc,
      child: widget,
    );
  }
}

class _PolygonPainter extends CustomPainter {
  final int sides;
  final Color fillColor;
  final Color strokeColor;

  _PolygonPainter({
    required this.sides,
    required this.fillColor,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    final Paint strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.05;

    final Path path = Path();
    final double radius = size.shortestSide / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double rotationOffset = sides == 3 ? -pi / 2 : -pi / 2;

    for (int i = 0; i < sides; i++) {
      final double angle = (2 * pi * i / sides) + rotationOffset;
      final Offset point = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.4), 6, true);
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _DiceIconStyle {
  final Color fillColor;
  final Color borderColor;
  final Color textColor;
  final int polygonSides;

  const _DiceIconStyle({
    required this.fillColor,
    required this.borderColor,
    required this.textColor,
    required this.polygonSides,
  });

  factory _DiceIconStyle.fromType(DiceType type) {
    switch (type) {
      case DiceType.d4:
        return _DiceIconStyle(
          fillColor: const Color(0xFF16A34A),
          borderColor: const Color(0xFF15803D),
          textColor: Colors.white,
          polygonSides: 3,
        );
      case DiceType.d6:
        return _DiceIconStyle(
          fillColor: const Color(0xFF0EA5E9),
          borderColor: const Color(0xFF0369A1),
          textColor: Colors.white,
          polygonSides: 4,
        );
      case DiceType.d8:
        return _DiceIconStyle(
          fillColor: const Color(0xFF8B5CF6),
          borderColor: const Color(0xFF6D28D9),
          textColor: Colors.white,
          polygonSides: 5,
        );
      case DiceType.d10:
        return _DiceIconStyle(
          fillColor: const Color(0xFFF472B6),
          borderColor: const Color(0xFFDB2777),
          textColor: Colors.white,
          polygonSides: 6,
        );
      case DiceType.d12:
        return _DiceIconStyle(
          fillColor: const Color(0xFFF97316),
          borderColor: const Color(0xFFC2410C),
          textColor: Colors.white,
          polygonSides: 7,
        );
      case DiceType.d20:
        return _DiceIconStyle(
          fillColor: const Color(0xFFFB923C),
          borderColor: const Color(0xFFF97316),
          textColor: Colors.white,
          polygonSides: 8,
        );
      case DiceType.d100:
        return _DiceIconStyle(
          fillColor: const Color(0xFF64748B),
          borderColor: const Color(0xFF475569),
          textColor: Colors.white,
          polygonSides: 8,
        );
    }
  }
}

