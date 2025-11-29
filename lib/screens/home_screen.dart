import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'dice_roller_screen.dart';
import 'coin_flip_screen.dart';
import 'number_dial_screen.dart';
import 'spinner_wheel_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildGridToolCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required Widget screen,
    required int delay,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 36,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.backgroundColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? Colors.white60
                      : AppTheme.backgroundColor.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms, delay: Duration(milliseconds: delay))
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            duration: 400.ms,
            delay: Duration(milliseconds: delay),
            curve: Curves.easeOutBack,
          ),
    );
  }

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
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/pakida_logo.png',
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
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

              // Tools Grid - 2x2 Layout
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.95,
                    children: [
                      _buildGridToolCard(
                        context,
                        title: 'Dice Roller',
                        description: 'Roll multiple dice',
                        icon: Icons.casino_outlined,
                        gradient: AppTheme.primaryGradient,
                        screen: const DiceRollerScreen(),
                        delay: 100,
                      ),
                      _buildGridToolCard(
                        context,
                        title: 'Coin Flip',
                        description: 'Heads or tails',
                        icon: Icons.monetization_on_outlined,
                        gradient: AppTheme.accentGradient,
                        screen: const CoinFlipScreen(),
                        delay: 200,
                      ),
                      _buildGridToolCard(
                        context,
                        title: 'Random Number',
                        description: 'Generate random',
                        icon: Icons.dialpad_outlined,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF10B981),
                            const Color(0xFF059669),
                          ],
                        ),
                        screen: const NumberDialScreen(),
                        delay: 300,
                      ),
                      _buildGridToolCard(
                        context,
                        title: 'Spinner Wheel',
                        description: 'Quick random picks',
                        icon: Icons.refresh_outlined,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFFB7185),
                            const Color(0xFFF59E0B),
                          ],
                        ),
                        screen: SpinnerWheelScreen(),
                        delay: 400,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


