import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/coin_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/coin_widget.dart';

class CoinFlipScreen extends StatelessWidget {
  const CoinFlipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coinProvider = Provider.of<CoinProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Flip'),
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
          child: Column(
            children: [
              // Main Coin Display
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: CoinWidget(
                      coin: coinProvider.selectedCoin,
                      onTap: () {
                        coinProvider.flipCoin();
                      },
                    )
                        .animate()
                        .scale(duration: 400.ms, curve: Curves.elasticOut)
                        .fadeIn(duration: 400.ms),
                  ),
                ),
              ),

              // Statistics
              if (coinProvider.headsCount > 0 || coinProvider.tailsCount > 0)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.cardColor : AppTheme.lightCard,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Heads',
                        coinProvider.headsCount,
                        Icons.face,
                        Colors.amber,
                        isDark,
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: isDark
                            ? Colors.white24
                            : AppTheme.backgroundColor.withOpacity(0.2),
                      ),
                      _buildStatItem(
                        'Tails',
                        coinProvider.tailsCount,
                        Icons.face_outlined,
                        Colors.blue,
                        isDark,
                      ),
                    ],
                  ),
                )
                    .animate()
                    .scale(duration: 300.ms)
                    .fadeIn(duration: 300.ms),

              // Action Buttons
              Container(
                padding: const EdgeInsets.all(16),
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
                        onPressed: () {
                          coinProvider.resetCoin();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
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
                        onPressed: coinProvider.isFlipping
                            ? null
                            : () {
                                coinProvider.flipCoin();
                              },
                        icon: const Icon(Icons.flip),
                        label: const Text('Flip Coin'),
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
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    int count,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 36),
        const SizedBox(height: 12),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.backgroundColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark
                ? Colors.white70
                : AppTheme.backgroundColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

