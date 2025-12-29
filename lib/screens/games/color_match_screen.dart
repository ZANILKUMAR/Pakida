import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';

class ColorMatchScreen extends StatefulWidget {
  const ColorMatchScreen({super.key});

  @override
  State<ColorMatchScreen> createState() => _ColorMatchScreenState();
}

class _ColorMatchScreenState extends State<ColorMatchScreen> {
  final List<String> colorNames = [
    'Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange', 'Pink', 'Teal'
  ];
  final List<Color> colors = [
    Colors.red.shade700,
    Colors.blue.shade700,
    Colors.green.shade700,
    Colors.amber.shade800,  // Darker yellow for better visibility
    Colors.purple.shade700,
    Colors.deepOrange.shade700,
    Colors.pink.shade700,
    Colors.teal.shade700,
  ];

  String currentColorName = '';
  Color currentTextColor = Colors.black;
  int correctCount = 0;
  int wrongCount = 0;
  int timeLeft = 30;
  Timer? gameTimer;
  bool isPlaying = false;
  final Random random = Random();

  void startGame() {
    gameTimer?.cancel();  // Cancel any existing timer
    setState(() {
      correctCount = 0;
      wrongCount = 0;
      timeLeft = 30;
      isPlaying = true;
    });
    _generateNewChallenge();
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && isPlaying) {
        setState(() {
          timeLeft--;
        });
        if (timeLeft <= 0) {
          _gameOver();
        }
      }
    });
  }

  void _generateNewChallenge() {
    if (!mounted || !isPlaying) return;
    setState(() {
      currentColorName = colorNames[random.nextInt(colorNames.length)];
      currentTextColor = colors[random.nextInt(colors.length)];
    });
  }

  void _checkAnswer(bool matches) {
    if (!isPlaying) return;
    
    bool correctAnswer =
        (colorNames.indexOf(currentColorName) == colors.indexOf(currentTextColor));

    if (matches == correctAnswer) {
      Vibration.vibrate(duration: 50);
      setState(() {
        correctCount++;
      });
    } else {
      Vibration.vibrate(duration: 100);
      setState(() {
        wrongCount++;
      });
    }
    _generateNewChallenge();
  }

  void _gameOver() {
    gameTimer?.cancel();
    if (!mounted) return;
    
    Vibration.vibrate(duration: 200);
    setState(() {
      isPlaying = false;
    });
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Time\'s Up!'),
        content: Text('Correct: $correctCount\nWrong: $wrongCount'),
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
        title: const Text('Color Match'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              if (isPlaying) {
                gameTimer?.cancel();
                startGame();
              }
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Restart',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                '✓$correctCount ✗$wrongCount | $timeLeft\"',
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isPlaying)
                    const Text(
                      'Match the color name with the text color!',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.cardColor : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        currentColorName,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: currentTextColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isPlaying)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () => _checkAnswer(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Match',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () => _checkAnswer(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'No Match',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (!isPlaying)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Start Game',
                    style: TextStyle(
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
