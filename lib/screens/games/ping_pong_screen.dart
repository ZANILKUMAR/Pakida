import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';

class PingPongScreen extends StatefulWidget {
  const PingPongScreen({super.key});

  @override
  State<PingPongScreen> createState() => _PingPongScreenState();
}

class _PingPongScreenState extends State<PingPongScreen> {
  double ballX = 0;
  double ballY = 0;
  double ballSpeedX = 0.02;
  double ballSpeedY = 0.02;
  double paddle1Y = 0;
  double paddleHeight = 0.3;
  Timer? gameTimer;
  bool isPlaying = false;
  int score = 0;
  int bestScore = 0;

  void startGame() {
    gameTimer?.cancel();
    gameTimer = null;
    
    setState(() {
      ballX = 0;
      ballY = 0;
      ballSpeedX = 0.02;
      ballSpeedY = -0.02;  // Start going upward
      paddle1Y = 0;
      score = 0;
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
    if (!mounted || !isPlaying) return;
    
    setState(() {
      ballX += ballSpeedX;
      ballY += ballSpeedY;

      // Wall collision (left and right)
      if (ballX <= -1 || ballX >= 1) {
        ballSpeedX = -ballSpeedX;
        ballX = ballX.clamp(-1, 1);
      }

      // Top wall bounce (automatic)
      if (ballY <= -0.95) {
        Vibration.vibrate(duration: 30);
        ballSpeedY = -ballSpeedY;
        ballY = -0.95;
        score++;
      }

      // Player Paddle collision (bottom)
      if (ballY >= 0.85 && ballY <= 0.95 &&
          ballX >= paddle1Y - paddleHeight / 2 &&
          ballX <= paddle1Y + paddleHeight / 2) {
        Vibration.vibrate(duration: 30);
        ballSpeedY = -ballSpeedY.abs();
        ballSpeedY = (ballSpeedY * 1.02).clamp(-0.05, -0.01);
        // Add spin based on where ball hits paddle
        double hitPosition = (ballX - paddle1Y) / (paddleHeight / 2);
        ballSpeedX += hitPosition * 0.01;
        score++;
      }

      // Clamp ball speed X
      ballSpeedX = ballSpeedX.clamp(-0.03, 0.03);

      // Game over if ball goes past player paddle (bottom)
      if (ballY >= 1.1) {
        _gameOver();
      }
    });
  }

  void _gameOver() {
    gameTimer?.cancel();
    gameTimer = null;
    if (!mounted) return;
    
    Vibration.vibrate(duration: 200);
    
    if (score > bestScore) {
      bestScore = score;
    }
    
    setState(() {
      isPlaying = false;
    });
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Text(
          'Score: $score\nBest: $bestScore',
          style: const TextStyle(fontSize: 18),
        ),
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
              startGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundColor : AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('Ping Pong'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              gameTimer?.cancel();
              Navigator.pop(context);
              startGame();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Restart',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                'Score: $score | Best: $bestScore',
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
                  paddle1Y += details.delta.dx / 200;
                  paddle1Y = paddle1Y.clamp(-0.7, 0.7);
                });
              },
              child: Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    // Ball
                    Align(
                      alignment: Alignment(ballX, ballY),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Player Paddle
                    Align(
                      alignment: Alignment(paddle1Y, 0.95),
                      child: Container(
                        width: MediaQuery.of(context).size.width * paddleHeight / 2,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.teal.shade500,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    if (!isPlaying)
                      Container(
                        color: Colors.black.withOpacity(0.7),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Ping Pong',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Drag to move your paddle',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Keep the ball alive!',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
                  backgroundColor: Colors.teal.shade600,
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
