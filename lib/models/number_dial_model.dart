class NumberDial {
  final int min;
  final int max;
  int currentValue;
  bool isSpinning;

  NumberDial({
    required this.min,
    required this.max,
    required this.currentValue,
    this.isSpinning = false,
  });

  NumberDial copyWith({
    int? min,
    int? max,
    int? currentValue,
    bool? isSpinning,
  }) {
    return NumberDial(
      min: min ?? this.min,
      max: max ?? this.max,
      currentValue: currentValue ?? this.currentValue,
      isSpinning: isSpinning ?? this.isSpinning,
    );
  }
}

