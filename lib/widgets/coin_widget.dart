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
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.accentGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              alignment: Alignment.center,
              child: coin.isFlipping
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
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
                            size: 40,
                          ),
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .rotate(
                              duration: 500.ms,
                              begin: 0,
                              end: 0.5,
                              curve: Curves.easeInOut,
                            )
                            .scale(
                              duration: 500.ms,
                              begin: const Offset(1, 1),
                              end: const Offset(1.1, 0.9),
                              curve: Curves.easeInOut,
                            ),
                        const SizedBox(height: 12),
                        Text(
                          'Flipping...',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    )
                  : coin.result == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                Icons.monetization_on,
                                color: Colors.white.withOpacity(0.7),
                                size: 50,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tap to flip',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
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
                                size: 50,
                              ),
                            )
                                .animate()
                                .scale(
                                  duration: 400.ms,
                                  begin: const Offset(0.5, 0.5),
                                  end: const Offset(1, 1),
                                  curve: Curves.elasticOut,
                                )
                                .fadeIn(duration: 400.ms),
                            const SizedBox(height: 12),
                            Text(
                              coin.result == CoinResult.heads
                                  ? 'Heads'
                                  : 'Tails',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 300.ms, delay: 200.ms)
                                .slideY(
                                  begin: 0.2,
                                  end: 0,
                                  duration: 300.ms,
                                  delay: 200.ms,
                                ),
                          ],
                        ),
            ),
          ),
        ),
      )
          .animate(target: coin.isFlipping ? 1 : 0)
          .shake(duration: 300.ms, hz: 6, curve: Curves.easeInOut),
    );
  }
}


