import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';

class TapTheDotScreen extends StatefulWidget {
  const TapTheDotScreen({super.key});

  @override
  State<TapTheDotScreen> createState() => _TapTheDotScreenState();
}

class _TapTheDotScreenState extends State<TapTheDotScreen> {
  double dotX = 0;
  double dotY = 0;
  int score = 0;
  int timeLeft = 30;
  Timer? gameTimer;
  Timer? countdownTimer;
  bool isPlaying = false;
  final Random random = Random();

  void startGame() {
    countdownTimer?.cancel();
    countdownTimer = null;
    gameTimer?.cancel();
    gameTimer = null;
    
    setState(() {
      score = 0;
      timeLeft = 30;
      isPlaying = true;
    });
    _generateNewDot();
    
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !isPlaying) {
        timer.cancel();
        return;
      }
      setState(() {
        timeLeft--;
      });
      if (timeLeft <= 0) {
        _gameOver();
      }
    });
  }

  void _generateNewDot() {
    if (!mounted) return;
    setState(() {
      dotX = -0.8 + random.nextDouble() * 1.6;
      dotY = -0.8 + random.nextDouble() * 1.6;
    });
  }

  void _onTap(TapDownDetails details, BoxConstraints constraints) {
    if (!isPlaying) return;

    // Convert tap position to alignment coordinates (-1 to 1)
    double tapX = (details.localPosition.dx / constraints.maxWidth) * 2 - 1;
    double tapY = (details.localPosition.dy / constraints.maxHeight) * 2 - 1;

    // Check if tap is within dot radius
    double distance = sqrt(pow(tapX - dotX, 2) + pow(tapY - dotY, 2));

    if (distance < 0.15) {
      Vibration.vibrate(duration: 30);
      setState(() {
        score++;
      });
      _generateNewDot();
    } else {
      Vibration.vibrate(duration: 100);
    }
  }

  void _gameOver() {
    countdownTimer?.cancel();
    countdownTimer = null;
    gameTimer?.cancel();
    gameTimer = null;
    
    if (!mounted) return;
    
    Vibration.vibrate(duration: 200);
    setState(() {
      isPlaying = false;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time\'s Up!'),
        content: Text('You tapped $score dots!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    gameTimer = null;
    countdownTimer?.cancel();
    countdownTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundColor : AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('Tap the Dot'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              countdownTimer?.cancel();
              countdownTimer = null;
              gameTimer?.cancel();
              gameTimer = null;
              startGame();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Restart',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                'Score: $score | Time: $timeLeft',
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapDown: (details) => _onTap(details, constraints),
                  child: Container(
                    color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                    child: Stack(
                      children: [
                        if (isPlaying)
                          Align(
                            alignment: Alignment(dotX, dotY),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade600,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.indigo.withOpacity(0.5),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (!isPlaying)
                          const Center(
                            child: Text(
                              'Tap the dots as fast as you can!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
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
                  backgroundColor: Colors.indigo.shade600,
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
