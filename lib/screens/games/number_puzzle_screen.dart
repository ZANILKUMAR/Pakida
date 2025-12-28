import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';

class NumberPuzzleScreen extends StatefulWidget {
  const NumberPuzzleScreen({super.key});

  @override
  State<NumberPuzzleScreen> createState() => _NumberPuzzleScreenState();
}

class _NumberPuzzleScreenState extends State<NumberPuzzleScreen> {
  List<int> tiles = [];
  int moves = 0;
  int emptyIndex = 15;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    tiles = List.generate(15, (index) => index + 1)..add(0);
    do {
      tiles.shuffle();
      emptyIndex = tiles.indexOf(0);
    } while (!_isSolvable() || _isWon());
    moves = 0;
    setState(() {});
  }

  bool _isSolvable() {
    int inversions = 0;
    for (int i = 0; i < tiles.length; i++) {
      for (int j = i + 1; j < tiles.length; j++) {
        if (tiles[i] != 0 && tiles[j] != 0 && tiles[i] > tiles[j]) {
          inversions++;
        }
      }
    }
    int emptyRow = emptyIndex ~/ 4;
    return (inversions + emptyRow) % 2 == 0;
  }

  bool _isWon() {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) return false;
    }
    return tiles[15] == 0;
  }

  void _moveTile(int index) {
    int row = index ~/ 4;
    int col = index % 4;
    int emptyRow = emptyIndex ~/ 4;
    int emptyCol = emptyIndex % 4;

    if ((row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1)) {
      Vibration.vibrate(duration: 30);
      setState(() {
        tiles[emptyIndex] = tiles[index];
        tiles[index] = 0;
        emptyIndex = index;
        moves++;
      });

      if (_isWon()) {
        Vibration.vibrate(duration: 200);
        _showWinDialog();
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: Text('You solved it in $moves moves!'),
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundColor : AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('Number Puzzle'),
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
                  fontSize: 18,
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
              child: Container(
                width: screenWidth - 48,
                height: screenWidth - 48,
                padding: const EdgeInsets.all(8),
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
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    // Check if tile is in correct position
                    bool isCorrectPosition = tiles[index] == index + 1;
                    
                    return GestureDetector(
                      onTap: tiles[index] == 0 ? null : () => _moveTile(index),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: tiles[index] == 0
                              ? null
                              : LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isCorrectPosition
                                      ? [
                                          Colors.green.shade500,
                                          Colors.green.shade700,
                                        ]
                                      : [
                                          Colors.blue.shade500,
                                          Colors.blue.shade700,
                                        ],
                                ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: tiles[index] == 0
                              ? null
                              : [
                                  BoxShadow(
                                    color: (isCorrectPosition ? Colors.green : Colors.blue).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: tiles[index] == 0
                              ? null
                              : Text(
                                  tiles[index].toString(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
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
                onPressed: _initializeGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
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
