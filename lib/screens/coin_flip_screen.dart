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
              // Add Coin Section
              Container(
                margin: const EdgeInsets.all(16),
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
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Coins',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppTheme.backgroundColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${coinProvider.coins.length} coin(s)',
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
                    ElevatedButton.icon(
                      onPressed: () {
                        coinProvider.addCoin();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Coin'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.1, end: 0, duration: 400.ms),

              // Coins Display
              Expanded(
                child: coinProvider.coins.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.monetization_on_outlined,
                              size: 80,
                              color: isDark
                                  ? Colors.white38
                                  : AppTheme.backgroundColor.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Add a coin to get started',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark
                                    ? Colors.white54
                                    : AppTheme.backgroundColor.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Coins Grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1,
                            ),
                            itemCount: coinProvider.coins.length,
                            itemBuilder: (context, index) {
                              final coin = coinProvider.coins[index];
                              return CoinWidget(
                                coin: coin,
                                onTap: () {
                                  coinProvider.flipSingleCoin(index);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // Statistics
                          if (coinProvider.headsCount > 0 ||
                              coinProvider.tailsCount > 0)
                            Container(
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
                                    height: 40,
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
                        ],
                      ),
              ),

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
                      child: OutlinedButton(
                        onPressed: coinProvider.coins.isEmpty
                            ? null
                            : () {
                                coinProvider.clearAllCoins();
                              },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Clear All'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: coinProvider.coins.isEmpty ||
                                coinProvider.isFlipping
                            ? null
                            : () {
                                coinProvider.flipAllCoins();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: coinProvider.isFlipping
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.flip),
                                  SizedBox(width: 8),
                                  Text(
                                    'Flip All',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.backgroundColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? Colors.white70
                : AppTheme.backgroundColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

