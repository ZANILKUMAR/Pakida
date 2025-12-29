import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';

class FlappyBirdScreen extends StatefulWidget {
  const FlappyBirdScreen({super.key});

  @override
  State<FlappyBirdScreen> createState() => _FlappyBirdScreenState();
}

class _FlappyBirdScreenState extends State<FlappyBirdScreen> {
  double birdY = 0;
  double velocity = 0;
  double gravity = 0.0015;
  double jumpStrength = -0.065;
  double pipeX = 1.5;
  double pipeGap = 0.7;  // Increased gap size
  double pipeHeight = 0.3;  // Reduced pipe height
  Timer? gameTimer;
  bool isPlaying = false;
  bool isGameOver = false;
  int score = 0;
  bool scoredForCurrentPipe = false;

  @override
  void dispose() {
    gameTimer?.cancel();
    gameTimer = null;
    super.dispose();
  }

  void startGame() {
    gameTimer?.cancel();
    gameTimer = null;
    
    setState(() {
      birdY = 0;
      velocity = 0;
      pipeX = 1.5;
      score = 0;
      isPlaying = true;
      isGameOver = false;
      scoredForCurrentPipe = false;
    });

    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _updateGame();
    });
  }

  void _jump() {
    if (isGameOver) return;
    
    if (!isPlaying) {
      startGame();
      return;
    }
    
    Vibration.vibrate(duration: 30);
    setState(() {
      velocity = jumpStrength;
    });
  }

  void _updateGame() {
    if (!mounted) return;
    if (!isPlaying || isGameOver) {
      gameTimer?.cancel();
      return;
    }
    
    setState(() {
      velocity += gravity;
      velocity = velocity.clamp(-0.1, 0.1); // Limit velocity
      birdY += velocity;
      pipeX -= 0.015;

      // Score when bird passes pipe
      if (pipeX < -0.15 && !scoredForCurrentPipe) {
        score++;
        Vibration.vibrate(duration: 50);
        scoredForCurrentPipe = true;
      }

      // Reset pipe and scoring flag
      if (pipeX < -1.5) {
        pipeX = 1.5;
        scoredForCurrentPipe = false;
      }

      // Check collision with ground/ceiling
      if (birdY > 0.9 || birdY < -0.9) {
        _gameOver();
        return;
      }

      // Check pipe collision
      double birdSize = 0.05;  // Reduced bird collision size
      if (pipeX < 0.2 && pipeX > -0.3) {
        double topPipeEnd = -1 + (1 - pipeHeight - pipeGap / 2);
        double bottomPipeStart = 1 - (1 - pipeHeight - pipeGap / 2);
        
        if (birdY - birdSize < topPipeEnd || birdY + birdSize > bottomPipeStart) {
          _gameOver();
        }
      }
    });
  }

  void _gameOver() {
    if (!mounted) return;
    gameTimer?.cancel();
    gameTimer = null;
    Vibration.vibrate(duration: 200);
    setState(() {
      isGameOver = true;
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundColor : const Color(0xFF87CEEB),
      appBar: AppBar(
        title: const Text('Flappy Bird'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: startGame,
            icon: const Icon(Icons.refresh),
            tooltip: 'Restart',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                'Score: $score',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _jump,
              child: Container(
                color: isDark ? Colors.grey.shade900 : const Color(0xFF87CEEB),
                child: Stack(
                  children: [
                    // Bird
                    Align(
                      alignment: Alignment(0, birdY),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: velocity * 3),
                        duration: const Duration(milliseconds: 100),
                        builder: (context, rotation, child) {
                          return Transform.rotate(
                            angle: rotation.clamp(-0.5, 0.5),
                            child: child,
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: CustomPaint(
                            painter: BirdPainter(),
                          ),
                        ),
                      ),
                    ),
                    // Top Pipe
                    Align(
                      alignment: Alignment(pipeX, -1 + (1 - pipeHeight - pipeGap / 2) / 2),
                      child: Container(
                        width: 80,
                        height: MediaQuery.of(context).size.height *
                            (1 - pipeHeight - pipeGap / 2) /
                            2,
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    // Bottom Pipe
                    Align(
                      alignment: Alignment(pipeX, 1 - (1 - pipeHeight - pipeGap / 2) / 2),
                      child: Container(
                        width: 80,
                        height: MediaQuery.of(context).size.height *
                            (1 - pipeHeight - pipeGap / 2) /
                            2,
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    if (isGameOver)
                      Container(
                        color: Colors.black.withOpacity(0.7),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Game Over!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Score: $score',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (!isPlaying && !isGameOver)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: Text(
                            'Tap to Start',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  isGameOver ? 'Play Again' : 'Start',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the bird
class BirdPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Body (yellow oval)
    paint.color = Colors.yellow.shade700;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.5),
        width: size.width * 0.8,
        height: size.height * 0.65,
      ),
      paint,
    );

    // Wing (orange)
    paint.color = Colors.orange.shade700;
    final wingPath = Path();
    wingPath.moveTo(size.width * 0.3, size.height * 0.5);
    wingPath.lineTo(size.width * 0.15, size.height * 0.35);
    wingPath.lineTo(size.width * 0.25, size.height * 0.6);
    wingPath.close();
    canvas.drawPath(wingPath, paint);

    // Beak (orange)
    paint.color = Colors.orange.shade800;
    final beakPath = Path();
    beakPath.moveTo(size.width * 0.75, size.height * 0.5);
    beakPath.lineTo(size.width * 0.95, size.height * 0.45);
    beakPath.lineTo(size.width * 0.95, size.height * 0.55);
    beakPath.close();
    canvas.drawPath(beakPath, paint);

    // Eye white
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.35),
      size.width * 0.12,
      paint,
    );

    // Eye pupil
    paint.color = Colors.black;
    canvas.drawCircle(
      Offset(size.width * 0.68, size.height * 0.35),
      size.width * 0.06,
      paint,
    );

    // Tail (darker yellow)
    paint.color = Colors.yellow.shade900;
    final tailPath = Path();
    tailPath.moveTo(size.width * 0.15, size.height * 0.5);
    tailPath.lineTo(size.width * 0.05, size.height * 0.4);
    tailPath.lineTo(size.width * 0.05, size.height * 0.6);
    tailPath.close();
    canvas.drawPath(tailPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
