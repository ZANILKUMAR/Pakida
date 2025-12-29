import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';

class Game2048Screen extends StatefulWidget {
  const Game2048Screen({super.key});

  @override
  State<Game2048Screen> createState() => _Game2048ScreenState();
}

class _Game2048ScreenState extends State<Game2048Screen> {
  List<List<int>> grid = List.generate(4, (_) => List.filled(4, 0));
  int score = 0;
  bool isGameOver = false;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    grid = List.generate(4, (_) => List.filled(4, 0));
    score = 0;
    isGameOver = false;
    _addRandomTile();
    _addRandomTile();
    setState(() {});
  }

  void _addRandomTile() {
    List<Point<int>> emptyCells = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] == 0) {
          emptyCells.add(Point(i, j));
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      final cell = emptyCells[random.nextInt(emptyCells.length)];
      grid[cell.x][cell.y] = random.nextDouble() < 0.9 ? 2 : 4;
    }
  }

  void _move(Direction direction) {
    bool moved = false;

    switch (direction) {
      case Direction.left:
        moved = _moveLeft();
        break;
      case Direction.right:
        moved = _moveRight();
        break;
      case Direction.up:
        moved = _moveUp();
        break;
      case Direction.down:
        moved = _moveDown();
        break;
    }

    if (moved) {
      Vibration.vibrate(duration: 30);
      _addRandomTile();
      setState(() {});
      _checkGameOver();
    }
  }

  bool _moveLeft() {
    bool moved = false;
    bool merged = false;
    for (int i = 0; i < 4; i++) {
      List<int> row = grid[i].where((val) => val != 0).toList();
      for (int j = 0; j < row.length - 1; j++) {
        if (row[j] == row[j + 1]) {
          row[j] *= 2;
          score += row[j];
          row.removeAt(j + 1);
          moved = true;
          merged = true;
        }
      }
      row.addAll(List.filled(4 - row.length, 0));
      if (grid[i].toString() != row.toString()) moved = true;
      grid[i] = row;
    }
    if (merged) {
      Vibration.vibrate(duration: 50);
    }
    return moved;
  }

  bool _moveRight() {
    _reverseGrid();
    bool moved = _moveLeft();
    _reverseGrid();
    return moved;
  }

  bool _moveUp() {
    _transposeGrid();
    bool moved = _moveLeft();
    _transposeGrid();
    return moved;
  }

  bool _moveDown() {
    _transposeGrid();
    bool moved = _moveRight();
    _transposeGrid();
    return moved;
  }

  void _transposeGrid() {
    List<List<int>> newGrid = List.generate(4, (_) => List.filled(4, 0));
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        newGrid[j][i] = grid[i][j];
      }
    }
    grid = newGrid;
  }

  void _reverseGrid() {
    for (int i = 0; i < 4; i++) {
      grid[i] = grid[i].reversed.toList();
    }
  }

  void _checkGameOver() {
    // Check if any move is possible
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] == 0) return;
        if (j < 3 && grid[i][j] == grid[i][j + 1]) return;
        if (i < 3 && grid[i][j] == grid[i + 1][j]) return;
      }
    }
    Vibration.vibrate(duration: 200);
    setState(() {
      isGameOver = true;
    });
  }

  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return const Color(0xFFEEE4DA);
      case 4:
        return const Color(0xFFEDE0C8);
      case 8:
        return const Color(0xFFF2B179);
      case 16:
        return const Color(0xFFF59563);
      case 32:
        return const Color(0xFFF67C5F);
      case 64:
        return const Color(0xFFF65E3B);
      case 128:
        return const Color(0xFFEDCF72);
      case 256:
        return const Color(0xFFEDCC61);
      case 512:
        return const Color(0xFFEDC850);
      case 1024:
        return const Color(0xFFEDC53F);
      case 2048:
        return const Color(0xFFEDC22E);
      default:
        return const Color(0xFF3C3A32);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundColor : AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('2048'),
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
                'Score: $score',
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
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    _move(Direction.right);
                  } else if (details.primaryVelocity! < 0) {
                    _move(Direction.left);
                  }
                },
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    _move(Direction.down);
                  } else if (details.primaryVelocity! < 0) {
                    _move(Direction.up);
                  }
                },
                child: Container(
                  width: screenWidth - 48,
                  height: screenWidth - 48,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : const Color(0xFFBBADA0),
                    borderRadius: BorderRadius.circular(12),
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
                      int row = index ~/ 4;
                      int col = index % 4;
                      int value = grid[row][col];

                      return Container(
                        decoration: BoxDecoration(
                          color: value == 0
                              ? const Color(0xFFCDC1B4)
                              : _getTileColor(value),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: value == 0
                              ? null
                              : Text(
                                  value.toString(),
                                  style: TextStyle(
                                    fontSize: value < 100
                                        ? 32
                                        : value < 1000
                                            ? 28
                                            : 24,
                                    fontWeight: FontWeight.bold,
                                    color: value <= 4
                                        ? const Color(0xFF776E65)
                                        : Colors.white,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          if (isGameOver)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Game Over!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade600,
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
                  backgroundColor: Colors.orange.shade600,
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

enum Direction { up, down, left, right }
