enum DiceType {
  d4(4, 'D4'),
  d6(6, 'D6'),
  d8(8, 'D8'),
  d10(10, 'D10'),
  d12(12, 'D12'),
  d20(20, 'D20'),
  d100(100, 'D100');

  final int sides;
  final String label;

  const DiceType(this.sides, this.label);
}

class Dice {
  final DiceType type;
  int? value;
  bool isRolling;

  Dice({
    required this.type,
    this.value,
    this.isRolling = false,
  });

  Dice copyWith({
    DiceType? type,
    int? value,
    bool? isRolling,
  }) {
    return Dice(
      type: type ?? this.type,
      value: value ?? this.value,
      isRolling: isRolling ?? this.isRolling,
    );
  }
}


