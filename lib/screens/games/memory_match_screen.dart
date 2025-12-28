import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';

class MemoryMatchScreen extends StatefulWidget {
  const MemoryMatchScreen({super.key});

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  List<String> cardValues = [];
  List<bool> cardFlips = [];
  List<int> flippedIndices = [];
  int moves = 0;
  int matches = 0;
  bool isChecking = false;

  final List<IconData> icons = [
    Icons.favorite,
    Icons.star,
    Icons.pets,
    Icons.emoji_emotions,
    Icons.music_note,
    Icons.sports_soccer,
    Icons.cake,
    Icons.flight,
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    cardValues = List.generate(16, (index) => (index ~/ 2).toString())
      ..shuffle();
    cardFlips = List.filled(16, false);
    flippedIndices = [];
    moves = 0;
    matches = 0;
    isChecking = false;
    setState(() {});
  }

  void _onCardTap(int index) {
    if (isChecking ||
        cardFlips[index] ||
        flippedIndices.length >= 2) {
      return;
    }
    Vibration.vibrate(duration: 20);    setState(() {
      cardFlips[index] = true;
      flippedIndices.add(index);
    });

    if (flippedIndices.length == 2) {
      setState(() {
        moves++;
        isChecking = true;
      });

      if (cardValues[flippedIndices[0]] == cardValues[flippedIndices[1]]) {
        Vibration.vibrate(duration: 50);
        setState(() {
          matches++;
          flippedIndices = [];
          isChecking = false;
        });

        if (matches == 8) {
          Vibration.vibrate(duration: 200);
          _showWinDialog();
        }
      } else {
        Vibration.vibrate(duration: 100);
        Timer(const Duration(milliseconds: 1000), () {
          setState(() {
            cardFlips[flippedIndices[0]] = false;
            cardFlips[flippedIndices[1]] = false;
            flippedIndices = [];
            isChecking = false;
          });
        });
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: Text('You won in $moves moves!'),
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundColor : AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('Memory Match'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _initializeGame,
            icon: const Icon(Icons.refresh),
            tooltip: 'Restart',
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Moves: $moves',
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
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: cardFlips[index]
                            ? Colors.purple.shade500
                            : (isDark ? AppTheme.cardColor : Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: cardFlips[index]
                            ? Icon(
                                icons[int.parse(cardValues[index])],
                                size: 40,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.help_outline,
                                size: 40,
                                color: isDark
                                    ? Colors.white38
                                    : Colors.grey.shade400,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _initializeGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'New Game',
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
