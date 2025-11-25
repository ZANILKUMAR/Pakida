import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/dice_provider.dart';
import '../models/dice_model.dart';
import '../theme/app_theme.dart';
import '../widgets/dice_widget.dart';
import '../widgets/dice_shape_icon.dart';

class DiceRollerScreen extends StatefulWidget {
  const DiceRollerScreen({super.key});

  @override
  State<DiceRollerScreen> createState() => _DiceRollerScreenState();
}

class _DiceRollerScreenState extends State<DiceRollerScreen> {
  void _openDicePicker(BuildContext context) {
    final diceProvider = Provider.of<DiceProvider>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardColor : Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Dice',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Tap to add a new dice to your collection',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : AppTheme.backgroundColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: Column(
                  children: DiceType.values.map((type) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            diceProvider.addDice(type);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  duration: const Duration(milliseconds: 800),
                                  content: Text('${type.label} added'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                              ),
                            ),
                            child: Row(
                              children: [
                                DiceShapeIcon(
                                  type: type,
                                  size: 36,
                                  showValue: true,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      type.label,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : AppTheme.backgroundColor,
                                      ),
                                    ),
                                    Text(
                                      '${type.sides} sides',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? Colors.white54 : AppTheme.backgroundColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final diceProvider = Provider.of<DiceProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice Roller'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: isDark ? AppTheme.surfaceColor : Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.backgroundColor, AppTheme.surfaceColor],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.lightBackground, Colors.white],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Add Dice Button Section
              Container(
                margin: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () => _openDicePicker(context),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Add Dice'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: -0.1, end: 0, duration: 400.ms),
              ),

              // Dice Display Area
              Expanded(
                child: diceProvider.diceList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.casino_outlined,
                              size: 80,
                              color: isDark
                                  ? Colors.white24
                                  : AppTheme.backgroundColor.withOpacity(0.2),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No dice yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white54 : AppTheme.backgroundColor.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap "Add Dice" to get started',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? Colors.white38 : AppTheme.backgroundColor.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          // Dice Grid
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.92,
                              ),
                              itemCount: diceProvider.diceList.length,
                              itemBuilder: (context, index) {
                                final dice = diceProvider.diceList[index];
                                return Stack(
                                  children: [
                                    DiceWidget(
                                      dice: dice,
                                      onTap: () {
                                        diceProvider.rollSingleDice(index);
                                      },
                                      onTypeChanged: (type) {
                                        diceProvider.setDiceType(index, type);
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              duration: const Duration(milliseconds: 800),
                                              content: Text('Changed to ${type.label}'),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                      },
                                    ),
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: GestureDetector(
                                        onTap: () {
                                          diceProvider.removeDice(index);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.85),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.red.withOpacity(0.3),
                                                blurRadius: 8,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          // Total Sum Display
                          if (diceProvider.totalSum > 0)
                            Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Total Sum',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.85),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${diceProvider.totalSum}',
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .scale(duration: 300.ms)
                                .fadeIn(duration: 300.ms),
                        ],
                      ),
              ),

              // Dice Count Control
              if (diceProvider.diceList.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.surfaceColor : Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Count: ${diceProvider.diceCount}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppTheme.backgroundColor,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_rounded),
                              onPressed: diceProvider.diceCount > 1
                                  ? () => diceProvider.removeDice(diceProvider.diceCount - 1)
                                  : null,
                              iconSize: 18,
                              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_rounded),
                              onPressed: () => diceProvider.addDice(DiceType.d6),
                              iconSize: 18,
                              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms),

              // Action Buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.surfaceColor : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: diceProvider.diceList.isEmpty
                            ? null
                            : () => diceProvider.clearAllDice(),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Clear'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: diceProvider.diceList.isEmpty ||
                                diceProvider.isRolling
                            ? null
                            : () => diceProvider.rollAllDice(),
                        icon: const Icon(Icons.casino),
                        label: const Text('Roll All'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
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
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}




