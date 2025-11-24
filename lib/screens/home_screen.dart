import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/tool_card.dart';
import '../theme/app_theme.dart';
import 'dice_roller_screen.dart';
import 'coin_flip_screen.dart';
import 'number_dial_screen.dart';
import 'spinner_wheel_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.casino,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pakida',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppTheme.backgroundColor,
                            ),
                          ),
                          Text(
                            'Randomizer Tools',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.white70
                                  : AppTheme.backgroundColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings_outlined),
                      color: isDark ? Colors.white : AppTheme.backgroundColor,
                      tooltip: 'Settings',
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: -0.2, end: 0, duration: 400.ms),

              // Tools Grid
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    ToolCard(
                      title: 'Dice Roller',
                      description: 'Roll multiple dice with different shapes',
                      icon: Icons.casino_outlined,
                      gradient: AppTheme.primaryGradient,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DiceRollerScreen(),
                          ),
                        );
                      },
                      delay: 100,
                    ),
                    ToolCard(
                      title: 'Coin Flip',
                      description: 'Flip coins and get heads or tails',
                      icon: Icons.monetization_on_outlined,
                      gradient: AppTheme.accentGradient,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CoinFlipScreen(),
                          ),
                        );
                      },
                      delay: 200,
                    ),
                    ToolCard(
                      title: 'Number Dial',
                      description: 'Spin to get a random number',
                      icon: Icons.dialpad_outlined,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF10B981),
                          const Color(0xFF059669),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NumberDialScreen(),
                          ),
                        );
                      },
                      delay: 300,
                    ),
                    ToolCard(
                      title: 'Spinner Wheel',
                      description: 'Colorful wheel for quick random picks',
                      icon: Icons.refresh_outlined,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFFB7185),
                          const Color(0xFFF59E0B),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpinnerWheelScreen(),
                          ),
                        );
                      },
                      delay: 400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


