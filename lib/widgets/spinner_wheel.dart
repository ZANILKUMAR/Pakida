import 'dart:math';

import 'package:flutter/material.dart';
import '../models/spinner_model.dart';

class SpinnerWheel extends StatefulWidget {
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
  State<SpinnerWheel> createState() => _SpinnerWheelState();
}

class _SpinnerWheelState extends State<SpinnerWheel> with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  double _currentRotation = 0;
  double _randomRotationAmount = 0; // Additional random rotation

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 2800),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(SpinnerWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // When spinning starts
    if (widget.isSpinning && !oldWidget.isSpinning) {
      _startSpin();
    }
  }

  SpinnerSegment? _getSegmentAtPointer() {
    if (widget.segments.isEmpty) return null;
    
    // Normalize rotation to 0-2π
    double normalizedRotation = _currentRotation % (2 * pi);
    if (normalizedRotation < 0) normalizedRotation += 2 * pi;
    
    final segmentAngle = (2 * pi) / widget.segments.length;
    
    // Pointer is at top (angle 0)
    // Find which segment center is at top
    // Segment 0 center is at -π/2 + (segmentAngle/2) initially
    // After rotation by amount R, segment centers are at: -π/2 + (segmentAngle/2) + R, etc.
    
    int segmentIndex = (normalizedRotation / segmentAngle).round() % widget.segments.length;
    if (segmentIndex < 0) {
      segmentIndex = widget.segments.length + segmentIndex;
    }
    
    return widget.segments[segmentIndex];
  }

  void _startSpin() {
    // Generate random rotation amount (between 0 and full circle)
    final random = Random();
    _randomRotationAmount = random.nextDouble() * 2 * pi;
    
    _spinController.forward(from: 0.0);
    
    // Animate to final rotation
    _spinController.addListener(() {
      setState(() {
        // Spin 6 full rotations during animation + random partial rotation
        _currentRotation = _spinController.value * 6 * 2 * pi + _randomRotationAmount;
      });
    });
    
    // After animation completes, get the final segment
    _spinController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final finalSegment = _getSegmentAtPointer();
        if (finalSegment != null && widget.selectedSegment != finalSegment) {
          // This will be handled by the provider through the widget update
        }
      }
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: _currentRotation,
            child: CustomPaint(
              size: const Size(280, 280),
              painter: _SpinnerWheelPainter(
                segments: widget.segments,
                highlight: widget.selectedSegment,
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: CustomPaint(
              size: const Size(40, 40),
              painter: _PointerPainter(),
            ),
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
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(0.4);

    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final double sweepAngle = (2 * pi) / segments.length;
    final double startAngle = -pi / 2 - sweepAngle / 2; // Center first segment at top

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      fillPaint.color = segment == highlight
          ? segment.color.withOpacity(0.95)
          : segment.color.withOpacity(0.85);
      final Path path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle + sweepAngle * i,
          sweepAngle,
          false,
        )
        ..close();

      // Draw filled segment
      canvas.drawPath(path, fillPaint);
      
      // Draw border only if not highlighted and not adjacent to highlighted
      if (segment != highlight) {
        bool isAdjacentToHighlight = false;
        if (highlight != null) {
          final highlightIndex = segments.indexWhere((s) => s == highlight);
          final currentIndex = i;
          final prevIndex = (currentIndex - 1 + segments.length) % segments.length;
          final nextIndex = (currentIndex + 1) % segments.length;
          isAdjacentToHighlight = (prevIndex == highlightIndex || nextIndex == highlightIndex);
        }
        if (!isAdjacentToHighlight) {
          canvas.drawPath(path, borderPaint);
        }
      }

      // draw text
      final double textAngle =
          startAngle + sweepAngle * i + sweepAngle / 2;
      
      // Adjust font size based on text length and number of segments
      double fontSize = 14;
      String displayText = segment.label;
      
      // Calculate available segment width
      final double segmentArcLength = radius * sweepAngle * 0.7; // 70% of arc
      
      if (segment.label.length > 8) {
        fontSize = 10;
      } else if (segment.label.length > 5) {
        fontSize = 12;
      }
      
      // Further reduce if many segments
      if (segments.length > 10) {
        fontSize = fontSize * 0.85;
      } else if (segments.length > 8) {
        fontSize = fontSize * 0.9;
      }
      
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: displayText,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '...',
      )..layout(maxWidth: segmentArcLength);

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
      ..moveTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    // Draw border/outline
    final Paint borderPaint = Paint()
      ..color = const Color(0xFF1F2937) // Dark border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw fill with gradient effect
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFBBF24), // Yellow
          Color(0xFFF59E0B), // Orange
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Draw shadow
    canvas.drawShadow(path, Colors.black.withOpacity(0.5), 6, true);
    
    // Draw fill
    canvas.drawPath(path, paint);
    
    // Draw border on top
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

