import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/coin_model.dart';
import '../theme/app_theme.dart';

class CoinWidget extends StatelessWidget {
  final Coin coin;
  final VoidCallback onTap;

  const CoinWidget({
    super.key,
    required this.coin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: coin.isFlipping ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.accentGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.3),
              blurRadius: coin.isFlipping ? 25 : 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: coin.isFlipping ? null : onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              alignment: Alignment.center,
              child: coin.isFlipping
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.flip,
                            color: Colors.white,
                            size: 50,
                          ),
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .rotate(
                              duration: 600.ms,
                              begin: 0,
                              end: 0.5,
                              curve: Curves.easeInOut,
                            )
                            .scale(
                              duration: 600.ms,
                              begin: const Offset(1, 1),
                              end: const Offset(1.15, 0.85),
                              curve: Curves.easeInOut,
                            ),
                        const SizedBox(height: 16),
                        Text(
                          'Flipping...',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.95),
                          ),
                        ),
                      ],
                    )
                  : coin.result == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.amber.shade400,
                                    Colors.amber.shade600,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.currency_exchange,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Flip the Coin',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to flip',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                coin.result == CoinResult.heads
                                    ? Icons.face
                                    : Icons.face_outlined,
                                color: coin.result == CoinResult.heads
                                    ? Colors.amber.shade700
                                    : Colors.blue.shade700,
                                size: 55,
                              ),
                            )
                                .animate()
                                .scale(
                                  duration: 500.ms,
                                  begin: const Offset(0.4, 0.4),
                                  end: const Offset(1, 1),
                                  curve: Curves.elasticOut,
                                )
                                .fadeIn(duration: 400.ms),
                            const SizedBox(height: 16),
                            Text(
                              coin.result == CoinResult.heads
                                  ? 'Heads'
                                  : 'Tails',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 300.ms, delay: 200.ms)
                                .slideY(
                                  begin: 0.3,
                                  end: 0,
                                  duration: 300.ms,
                                  delay: 200.ms,
                                ),
                            const SizedBox(height: 4),
                            Text(
                              'Flip #${coin.flipCount}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ),
      )
          .animate(target: coin.isFlipping ? 1 : 0)
          .shake(duration: 400.ms, hz: 5, curve: Curves.easeInOut),
    );
  }
}
