import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/dice_provider.dart';
import '../models/dice_model.dart';
import '../theme/app_theme.dart';

class DiceRollerScreen extends StatefulWidget {
  const DiceRollerScreen({Key? key}) : super(key: key);

  @override
  State<DiceRollerScreen> createState() => _DiceRollerScreenState();
}

class _DiceRollerScreenState extends State<DiceRollerScreen> {
  DiceType _selectedDiceType = DiceType.d6;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice Roller'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.backgroundColor,
                    AppTheme.surfaceColor,
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightBackground,
                    Colors.white,
                  ],
                ),
        ),
        child: SafeArea(
          child: Consumer<DiceProvider>(
            builder: (context, diceProvider, child) {
              return Column(
                children: [
                  // Dice Selector Section
                  _buildDiceSelectorSection(context, isDark, diceProvider),

                  // Large Dice Display Section
                  Expanded(
                    child: _buildLargeDiceDisplay(
                        context, diceProvider, isDark),
                  ),

                  // Action Buttons Section
                  if (diceProvider.diceList.isNotEmpty)
                    _buildActionButtonsSection(context, diceProvider, isDark),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDiceSelectorSection(
      BuildContext context, bool isDark, DiceProvider diceProvider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardColor : AppTheme.lightCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dice Type',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white70
                            : AppTheme.backgroundColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showDiceSelectionDialog(context, isDark),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: _getGradientColors(_selectedDiceType),
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.casino,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_selectedDiceType.label} (D${_selectedDiceType.sides})',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: -0.2, end: 0, duration: 400.ms),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Quantity Control
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white70
                          : AppTheme.backgroundColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.surfaceColor : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 34,
                          height: 34,
                          child: IconButton(
                            onPressed: diceProvider.diceCount > 0
                                ? () {
                                    diceProvider.removeDice(diceProvider.diceList.length - 1);
                                  }
                                : null,
                            icon: const Icon(Icons.remove),
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${diceProvider.diceCount}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 34,
                          height: 34,
                          child: IconButton(
                            onPressed: diceProvider.diceCount < 20
                                ? () {
                                    diceProvider.addDice(_selectedDiceType);
                                  }
                                : null,
                            icon: const Icon(Icons.add),
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.1, end: 0, duration: 400.ms);
  }

  Widget _buildLargeDiceDisplay(
      BuildContext context, DiceProvider diceProvider, bool isDark) {
    if (diceProvider.diceList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.casino,
              size: 100,
              color: isDark ? Colors.white24 : AppTheme.backgroundColor.withOpacity(0.2),
            ),
            const SizedBox(height: 20),
            Text(
              'No Dice Added',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white60 : AppTheme.backgroundColor.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Use + to add dice',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white.withOpacity(0.4) : AppTheme.backgroundColor.withOpacity(0.4),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.95,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: diceProvider.diceList.length,
              itemBuilder: (context, index) {
                return _buildLargeDiceCard(
                    context, diceProvider, index, isDark);
              },
            ),
          ),
          const SizedBox(height: 16),
          if (diceProvider.totalSum > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Sum: ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    '${diceProvider.totalSum}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .scale(duration: 400.ms, curve: Curves.elasticOut)
                .fadeIn(duration: 400.ms),
        ],
      ),
    );
  }

  Widget _buildLargeDiceCard(
      BuildContext context, DiceProvider diceProvider, int index, bool isDark) {
    final dice = diceProvider.diceList[index];
    return GestureDetector(
      onTap: diceProvider.isRolling
          ? null
          : () => diceProvider.rollSingleDice(index),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getGradientColors(dice.type),
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content - centered
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dice.type.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (dice.isRolling)
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    Text(
                      dice.value?.toString() ?? '-',
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    dice.isRolling ? 'Rolling...' : 'Tap to roll',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Remove button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => diceProvider.removeDice(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          .animate(target: dice.isRolling ? 1 : 0)
          .scale(
            duration: 300.ms,
            begin: const Offset(1, 1),
            end: const Offset(1.05, 1.05),
          ),
    );
  }

  Widget _buildActionButtonsSection(
      BuildContext context, DiceProvider diceProvider, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => diceProvider.clearAllDice(),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Clear'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: diceProvider.isRolling ? null : () => diceProvider.rollAllDice(),
              icon: const Icon(Icons.casino),
              label: const Text('Roll All'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 300.ms)
        .slideY(begin: 0.1, end: 0, duration: 400.ms);
  }

  void _showDiceSelectionDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppTheme.cardColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Dice Type',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.backgroundColor,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: DiceType.values.map((diceType) {
                  final isSelected = _selectedDiceType == diceType;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDiceType = diceType;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _getGradientColors(diceType),
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? _getGradientColors(diceType)[0].withOpacity(0.6)
                                : Colors.black.withOpacity(0.15),
                            blurRadius: isSelected ? 16 : 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              diceType.label,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'D${diceType.sides}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            if (isSelected)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                        .animate(target: isSelected ? 1 : 0)
                        .scale(
                          duration: 300.ms,
                          begin: const Offset(1, 1),
                          end: const Offset(1.08, 1.08),
                        ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(DiceType type) {
    switch (type) {
      case DiceType.d4:
        return [const Color(0xFF1D4ED8), const Color(0xFF0F172A)];
      case DiceType.d6:
        return [const Color(0xFF7C3AED), const Color(0xFF4C1D95)];
      case DiceType.d8:
        return [const Color(0xFF0F766E), const Color(0xFF134E4A)];
      case DiceType.d10:
        return [const Color(0xFFDC2626), const Color(0xFF7F1D1D)];
      case DiceType.d12:
        return [const Color(0xFF4338CA), const Color(0xFF312E81)];
      case DiceType.d20:
        return [const Color(0xFF047857), const Color(0xFF065F46)];
      case DiceType.d100:
        return [const Color(0xFF374151), const Color(0xFF111827)];
    }
  }
}




