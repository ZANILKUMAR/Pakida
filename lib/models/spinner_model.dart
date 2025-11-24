import 'package:flutter/material.dart';

class SpinnerSegment {
  final String label;
  final Color color;

  const SpinnerSegment({
    required this.label,
    required this.color,
  });

  SpinnerSegment copyWith({
    String? label,
    Color? color,
  }) {
    return SpinnerSegment(
      label: label ?? this.label,
      color: color ?? this.color,
    );
  }
}

