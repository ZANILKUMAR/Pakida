import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';

class BrickBreakerScreen extends StatefulWidget {
  const BrickBreakerScreen({super.key});

  @override
  State<BrickBreakerScreen> createState() => _BrickBreakerScreenState();
}

class _BrickBreakerScreenState extends State<BrickBreakerScreen> {
  double ballX = 0;
  double ballY = 0;
  double ballSpeedX = 0.02;
  double ballSpeedY = -0.02;
  double paddleX = 0;
  double paddleWidth = 0.3;
  List<List<bool>> bricks = [];
  Timer? gameTimer;
  bool isPlaying = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    gameTimer = null;
    super.dispose();
  }

  void _initializeGame() {
    gameTimer?.cancel();
    gameTimer = null;
    setState(() {
      ballX = 0;
      ballY = 0.7;
      ballSpeedX = 0.02;
      ballSpeedY = -0.02;
      paddleX = 0;
      score = 0;
      bricks = List.generate(5, (_) => List.filled(6, true));
      isPlaying = false;
    });
  }

  void startGame() {
    if (isPlaying) return;
    gameTimer?.cancel();
    gameTimer = null;
    
    setState(() {
      isPlaying = true;
    });
    
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted || !isPlaying) {
        timer.cancel();
        return;
      }
      _updateGame();
    });
  }

  void _updateGame() {
    if (!isPlaying || !mounted) return;
    
    setState(() {
      ballX += ballSpeedX;
      ballY += ballSpeedY;

      // Wall collision (left and right)
      if (ballX <= -0.98 || ballX >= 0.98) {
        ballSpeedX = -ballSpeedX;
        ballX = ballX.clamp(-0.98, 0.98);
      }
      
      // Top wall collision
      if (ballY <= -0.98) {
        ballSpeedY = -ballSpeedY;
        ballY = -0.98;
      }

      // Paddle collision
      if (ballY >= 0.85 &&
          ballY <= 0.92 &&
          ballX >= paddleX - paddleWidth / 2 - 0.05 &&
          ballX <= paddleX + paddleWidth / 2 + 0.05) {
        Vibration.vibrate(duration: 30);
        ballSpeedY = -ballSpeedY.abs(); // Always bounce upward
        ballY = 0.85; // Reset position to prevent getting stuck
        double hitPosition = (ballX - paddleX) / (paddleWidth / 2);
        ballSpeedX = hitPosition * 0.03;
      }

      // Bottom collision (game over)
      if (ballY >= 1) {
        _gameOver();
      }

      // Brick collision
      bool hitBrick = false;
      for (int i = 0; i < bricks.length && !hitBrick; i++) {
        for (int j = 0; j < bricks[i].length && !hitBrick; j++) {
          if (bricks[i][j]) {
            double brickX = -0.9 + j * 0.3;
            double brickY = -0.9 + i * 0.15;
            double brickWidth = 0.28;
            double brickHeight = 0.12;

            // Check collision with brick
            if (ballX + 0.02 >= brickX &&
                ballX - 0.02 <= brickX + brickWidth &&
                ballY + 0.02 >= brickY &&
                ballY - 0.02 <= brickY + brickHeight) {
              bricks[i][j] = false;
              Vibration.vibrate(duration: 50);
              ballSpeedY = -ballSpeedY;
              score += 10;
              hitBrick = true; // Only hit one brick per frame
              
              // Check win
              if (_allBricksDestroyed()) {
                _youWin();
                return;
              }
            }
          }
        }
      }
    });
  }

  void _gameOver() {
    gameTimer?.cancel();
    gameTimer = null;
    Vibration.vibrate(duration: 200);
    if (!mounted) return;
    setState(() {
      isPlaying = false;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Text('Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _youWin() {
    gameTimer?.cancel();
    gameTimer = null;
    Vibration.vibrate(duration: 200);
    if (!mounted) return;
    setState(() {
      isPlaying = false;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('You Win!'),
        content: Text('Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  bool _allBricksDestroyed() {
    for (var row in bricks) {
      if (row.contains(true)) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundColor : AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('Brick Breaker'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              gameTimer?.cancel();
              _initializeGame();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Restart',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                'Score: $score',
                style: const TextStyle(
                  fontSize: 14,
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
              onHorizontalDragUpdate: (details) {
                if (!isPlaying) return;
                setState(() {
                  paddleX += details.delta.dx / 200;
                  paddleX = paddleX.clamp(-0.85, 0.85);
                });
              },
              onTap: () {
                if (!isPlaying) {
                  startGame();
                }
              },
              child: Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    // Bricks
                    ...bricks.asMap().entries.expand((entry) {
                      int i = entry.key;
                      return entry.value.asMap().entries.map((innerEntry) {
                        int j = innerEntry.key;
                        if (!innerEntry.value) return Container();
                        return Align(
                          alignment: Alignment(
                            -0.9 + j * 0.3 + 0.14,
                            -0.9 + i * 0.15 + 0.06,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.primaries[i % Colors.primaries.length],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        );
                      });
                    }),
                    // Ball
                    Align(
                      alignment: Alignment(ballX, ballY),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Paddle
                    Align(
                      alignment: Alignment(paddleX, 0.9),
                      child: Container(
                        width: MediaQuery.of(context).size.width * paddleWidth / 2,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(8),
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
                onPressed: isPlaying ? null : startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  isPlaying ? 'Playing...' : 'Start Game',
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
