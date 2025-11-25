import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/dice_model.dart';
import '../theme/app_theme.dart';
import 'dice_shape_icon.dart';

class DiceWidget extends StatelessWidget {
  final Dice dice;
  final VoidCallback onTap;
  final ValueChanged<DiceType>? onTypeChanged;

  const DiceWidget({
    super.key,
    required this.dice,
    required this.onTap,
    this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final _DiceVisualStyle style = _DiceVisualStyle.fromType(dice.type);
    final isRolling = dice.isRolling;

    return GestureDetector(
      onTap: isRolling ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: style.gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: style.shadowColor,
              blurRadius: isRolling ? 25 : 15,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.12),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Floating particles background
              if (!isRolling)
                ...List.generate(3, (index) {
                  final alignment = _particleAlignments[index];
                  final random = Random(dice.type.sides + index);
                  return Align(
                    alignment: alignment,
                    child: Icon(
                      Icons.auto_awesome,
                      size: 8 + random.nextInt(5).toDouble(),
                      color: style.particleColor.withOpacity(0.1),
                    )
                        .animate(onPlay: (controller) => controller.repeat(reverse: true))
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1.05, 1.05),
                          duration: const Duration(milliseconds: 1800),
                        )
                        .fadeIn(duration: const Duration(milliseconds: 800)),
                  );
                }),
              // Main content
              Container(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Header with dice type and change button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            DiceShapeIcon(
                              type: dice.type,
                              size: 32,
                              showValue: true,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                style.shortLabel,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (onTypeChanged != null && !isRolling)
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: PopupMenuButton<DiceType>(
                              tooltip: 'Change dice',
                              elevation: 12,
                              color: const Color(0xFF1F2937),
                              onSelected: onTypeChanged,
                              itemBuilder: (context) => DiceType.values
                                  .map(
                                    (type) => PopupMenuItem<DiceType>(
                                      value: type,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: DiceShapeIcon(
                                              type: type,
                                              size: 20,
                                              showValue: true,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(type.label),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.15),
                                    width: 0.5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.change_circle_outlined,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    // Center value display
                    Expanded(
                      child: Center(
                        child: isRolling
                            ? _RollingIndicator(type: dice.type)
                            : _DiceResult(value: dice.value, type: dice.type),
                      ),
                    ),
                    // Bottom status
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedOpacity(
                        opacity: dice.value == null ? 0.5 : 0.9,
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          dice.value == null ? 'Tap' : '${dice.value}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            fontWeight: dice.value != null ? FontWeight.bold : FontWeight.normal,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          .animate(target: isRolling ? 1 : 0)
          .shake(
            duration: const Duration(milliseconds: 300),
            hz: 4,
          ),
    );
  }
}

class _RollingIndicator extends StatelessWidget {
  final DiceType type;

  const _RollingIndicator({required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DiceShapeIcon(
          type: type,
          size: 56,
          isRolling: true,
          showValue: true,
        ),
        const SizedBox(height: 6),
        const Text(
          'Rolling...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fadeIn(duration: const Duration(milliseconds: 600)),
      ],
    );
  }
}

class _DiceResult extends StatelessWidget {
  final int? value;
  final DiceType type;

  const _DiceResult({this.value, required this.type});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: value == null
          ? Column(
              key: const ValueKey('ready'),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DiceShapeIcon(
                  type: type,
                  size: 56,
                  showValue: true,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Ready',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            )
          : Column(
              key: ValueKey(value),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    DiceShapeIcon(
                      type: type,
                      size: 64,
                      showValue: false,
                    ),
                    Text(
                      '$value',
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _DiceVisualStyle {
  final List<Color> gradient;
  final Color shadowColor;
  final Color particleColor;
  final String shortLabel;
  final String label;

  const _DiceVisualStyle({
    required this.gradient,
    required this.shadowColor,
    required this.particleColor,
    required this.shortLabel,
    required this.label,
  });

  factory _DiceVisualStyle.fromType(DiceType type) {
    switch (type) {
      case DiceType.d4:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF0F172A), Color(0xFF1D4ED8)],
          shadowColor: const Color(0xFF1E3A8A).withOpacity(0.4),
          particleColor: const Color(0xFF93C5FD),
          shortLabel: 'D4',
          label: 'Tetra • D4',
        );
      case DiceType.d6:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF4C1D95), Color(0xFF7C3AED)],
          shadowColor: const Color(0xFF5B21B6).withOpacity(0.4),
          particleColor: const Color(0xFFE9D5FF),
          shortLabel: 'D6',
          label: 'Classic • D6',
        );
      case DiceType.d8:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF134E4A), Color(0xFF0F766E)],
          shadowColor: const Color(0xFF115E59).withOpacity(0.4),
          particleColor: const Color(0xFF99F6E4),
          shortLabel: 'D8',
          label: 'Octa • D8',
        );
      case DiceType.d10:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF7F1D1D), Color(0xFFDC2626)],
          shadowColor: const Color(0xFF991B1B).withOpacity(0.4),
          particleColor: const Color(0xFFFECACA),
          shortLabel: 'D10',
          label: 'Deca • D10',
        );
      case DiceType.d12:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF312E81), Color(0xFF4338CA)],
          shadowColor: const Color(0xFF3730A3).withOpacity(0.4),
          particleColor: const Color(0xFFC7D2FE),
          shortLabel: 'D12',
          label: 'Dodeca • D12',
        );
      case DiceType.d20:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF065F46), Color(0xFF047857)],
          shadowColor: const Color(0xFF064E3B).withOpacity(0.45),
          particleColor: const Color(0xFFA7F3D0),
          shortLabel: 'D20',
          label: 'Mythic • D20',
        );
      case DiceType.d100:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF111827), Color(0xFF374151)],
          shadowColor: const Color(0xFF1F2937).withOpacity(0.45),
          particleColor: const Color(0xFFD1D5DB),
          shortLabel: 'D100',
          label: 'Century • D100',
        );
    }
  }
}

const List<Alignment> _particleAlignments = [
  Alignment(-0.8, -0.8),
  Alignment(0.8, -0.8),
  Alignment(0, 0.9),
];

