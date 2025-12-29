import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';

class QuickMathScreen extends StatefulWidget {
  const QuickMathScreen({super.key});

  @override
  State<QuickMathScreen> createState() => _QuickMathScreenState();
}

class _QuickMathScreenState extends State<QuickMathScreen> {
  int num1 = 0;
  int num2 = 0;
  String operator = '+';
  int correctAnswer = 0;
  List<int> options = [];
  int correctCount = 0;
  int wrongCount = 0;
  int timeLeft = 60;
  Timer? gameTimer;
  bool isPlaying = false;
  final Random random = Random();

  final List<String> operators = ['+', '-', '×'];

  void startGame() {
    setState(() {
      correctCount = 0;
      wrongCount = 0;
      timeLeft = 60;
      isPlaying = true;
    });
    _generateNewQuestion();
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
      });
      if (timeLeft <= 0) {
        _gameOver();
      }
    });
  }

  void _generateNewQuestion() {
    operator = operators[random.nextInt(operators.length)];

    switch (operator) {
      case '+':
        num1 = random.nextInt(50) + 1;
        num2 = random.nextInt(50) + 1;
        correctAnswer = num1 + num2;
        break;
      case '-':
        num1 = random.nextInt(50) + 20;
        num2 = random.nextInt(num1);
        correctAnswer = num1 - num2;
        break;
      case '×':
        num1 = random.nextInt(12) + 1;
        num2 = random.nextInt(12) + 1;
        correctAnswer = num1 * num2;
        break;
    }

    // Generate options
    options = [correctAnswer];
    while (options.length < 4) {
      int offset = random.nextInt(20) - 10;
      int wrongAnswer = correctAnswer + offset;
      if (wrongAnswer != correctAnswer &&
          wrongAnswer > 0 &&
          !options.contains(wrongAnswer)) {
        options.add(wrongAnswer);
      }
    }
    options.shuffle();
    setState(() {});
  }

  void _checkAnswer(int answer) {
    if (answer == correctAnswer) {
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
    _generateNewQuestion();
  }

  void _gameOver() {
    gameTimer?.cancel();
    Vibration.vibrate(duration: 200);
    setState(() {
      isPlaying = false;
    });
    showDialog(
      context: context,
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
        title: const Text('Quick Math'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              gameTimer?.cancel();
              startGame();
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
                      'Solve as many problems as you can!',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    )
                  else
                    Column(
                      children: [
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
                            '$num1 $operator $num2 = ?',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppTheme.backgroundColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 2,
                            ),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return ElevatedButton(
                                onPressed: () => _checkAnswer(options[index]),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple.shade600,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: Text(
                                  options[index].toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
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
                    backgroundColor: Colors.deepPurple.shade600,
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
