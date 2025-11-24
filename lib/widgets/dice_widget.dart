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

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: style.gradient,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: style.shadowColor,
              blurRadius: 25,
              spreadRadius: 1,
              offset: const Offset(0, 14),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1.2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // floating particles / glow
              ...List.generate(_particleAlignments.length, (index) {
                final alignment = _particleAlignments[index];
                final random = Random(dice.type.sides + index);
                final double particleSize =
                    (12 + random.nextInt(8)).toDouble();
                return Align(
                  alignment: alignment,
                  child: Icon(
                    Icons.auto_awesome,
                    size: particleSize,
                    color: style.particleColor.withOpacity(0.18),
                  )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .scale(
                        begin: const Offset(0.7, 0.7),
                        end: const Offset(1.2, 1.2),
                        duration: const Duration(milliseconds: 2200),
                      )
                      .fadeIn(
                        duration: const Duration(milliseconds: 1200),
                      ),
                );
              }),
              // Content
              Container(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            DiceShapeIcon(
                              type: dice.type,
                              size: 38,
                              showValue: false,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              style.label,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (onTypeChanged != null)
                          PopupMenuButton<DiceType>(
                            tooltip: 'Change dice shape',
                            elevation: 12,
                            color: const Color(0xFF111928),
                            onSelected: onTypeChanged,
                            itemBuilder: (context) {
                              return DiceType.values
                                  .map(
                                    (type) => PopupMenuItem<DiceType>(
                                      value: type,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.view_in_ar_outlined,
                                            color: AppTheme.primaryColor,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(type.label),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.25),
                                  width: 1,
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.change_circle_outlined,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Shape',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: dice.isRolling
                            ? _RollingIndicator(
                                color: style.particleColor,
                                type: dice.type,
                              )
                            : _DiceResult(
                                value: dice.value,
                                type: dice.type,
                              ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedOpacity(
                        opacity: dice.value == null ? 0.6 : 1,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          dice.value == null
                              ? 'Tap to roll'
                              : 'Total ${dice.type.label}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            letterSpacing: 0.6,
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
          .animate(target: dice.isRolling ? 1 : 0)
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(0.92, 0.92),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          )
          .rotate(
            begin: 0,
            end: 0.02,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
          )
          .shake(
            duration: const Duration(milliseconds: 400),
            hz: 3,
            curve: Curves.easeInOut,
          ),
    );
  }
}

class _RollingIndicator extends StatelessWidget {
  final Color color;
  final DiceType type;

  const _RollingIndicator({required this.color, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DiceShapeIcon(
          type: type,
          size: 70,
          isRolling: true,
          showValue: false,
        ),
        const SizedBox(height: 12),
        const Text(
          'Rolling...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fadeIn(duration: const Duration(milliseconds: 800)),
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
      duration: const Duration(milliseconds: 450),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: value == null
          ? Column(
              key: const ValueKey('ready'),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DiceShapeIcon(
                  type: type,
                  size: 72,
                  showValue: false,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ready',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
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
                      size: 80,
                      showValue: false,
                    ),
                    Text(
                      '$value',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Result',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
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
  final String label;

  const _DiceVisualStyle({
    required this.gradient,
    required this.shadowColor,
    required this.particleColor,
    required this.label,
  });

  factory _DiceVisualStyle.fromType(DiceType type) {
    switch (type) {
      case DiceType.d4:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF0F172A), Color(0xFF1D4ED8)],
          shadowColor: const Color(0xFF1E3A8A).withOpacity(0.45),
          particleColor: const Color(0xFF93C5FD),
          label: 'Tetra • D4',
        );
      case DiceType.d6:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF4C1D95), Color(0xFF7C3AED)],
          shadowColor: const Color(0xFF5B21B6).withOpacity(0.5),
          particleColor: const Color(0xFFE9D5FF),
          label: 'Classic • D6',
        );
      case DiceType.d8:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF134E4A), Color(0xFF0F766E)],
          shadowColor: const Color(0xFF115E59).withOpacity(0.5),
          particleColor: const Color(0xFF99F6E4),
          label: 'Octa • D8',
        );
      case DiceType.d10:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF7F1D1D), Color(0xFFDC2626)],
          shadowColor: const Color(0xFF991B1B).withOpacity(0.5),
          particleColor: const Color(0xFFFECACA),
          label: 'Deca • D10',
        );
      case DiceType.d12:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF312E81), Color(0xFF4338CA)],
          shadowColor: const Color(0xFF3730A3).withOpacity(0.5),
          particleColor: const Color(0xFFC7D2FE),
          label: 'Dodeca • D12',
        );
      case DiceType.d20:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF065F46), Color(0xFF047857)],
          shadowColor: const Color(0xFF064E3B).withOpacity(0.55),
          particleColor: const Color(0xFFA7F3D0),
          label: 'Mythic • D20',
        );
      case DiceType.d100:
        return _DiceVisualStyle(
          gradient: const [Color(0xFF111827), Color(0xFF374151)],
          shadowColor: const Color(0xFF1F2937).withOpacity(0.55),
          particleColor: const Color(0xFFD1D5DB),
          label: 'Century • D100',
        );
    }
  }
}

const List<Alignment> _particleAlignments = [
  Alignment(-0.8, -0.9),
  Alignment(0.7, -0.6),
  Alignment(-0.6, 0.2),
  Alignment(0.4, 0.9),
  Alignment(-0.2, -0.3),
];

