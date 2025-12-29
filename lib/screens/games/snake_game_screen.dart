import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';

enum Direction { up, down, left, right }

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  static const int gridSize = 20;
  List<Point<int>> snake = [Point(10, 10)];
  Point<int> food = Point(15, 15);
  Direction direction = Direction.right;
  Direction? nextDirection;
  Timer? gameTimer;
  bool isPlaying = false;
  bool isGameOver = false;
  int score = 0;
  final Random random = Random();

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void startGame() {
    gameTimer?.cancel();
    setState(() {
      snake = [Point(10, 10)];
      food = _generateFood();
      direction = Direction.right;
      nextDirection = null;
      isPlaying = true;
      isGameOver = false;
      score = 0;
    });

    gameTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!mounted || !isPlaying) {
        timer.cancel();
        return;
      }
      if (nextDirection != null) {
        direction = nextDirection!;
        nextDirection = null;
      }
      _moveSnake();
    });
  }

  void _moveSnake() {
    if (!isPlaying || isGameOver) return;

    Point<int> newHead;
    final head = snake.first;

    switch (direction) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }

    // Check wall collision
    if (newHead.x < 0 ||
        newHead.x >= gridSize ||
        newHead.y < 0 ||
        newHead.y >= gridSize) {
      _gameOver();
      return;
    }

    // Check self collision
    if (snake.contains(newHead)) {
      _gameOver();
      return;
    }

    setState(() {
      snake.insert(0, newHead);

      // Check if snake ate food
      if (newHead == food) {
        score += 10;
        food = _generateFood();
        Vibration.vibrate(duration: 50);
      } else {
        snake.removeLast();
      }
    });
  }

  Point<int> _generateFood() {
    Point<int> newFood;
    do {
      newFood = Point(random.nextInt(gridSize), random.nextInt(gridSize));
    } while (snake.contains(newFood));
    return newFood;
  }

  void _gameOver() {
    gameTimer?.cancel();
    if (!mounted) return;
    
    Vibration.vibrate(duration: 200);
    setState(() {
      isGameOver = true;
      isPlaying = false;
    });
  }

  void _changeDirection(Direction newDirection) {
    if (!isPlaying) return;
    
    // Prevent reversing
    if ((direction == Direction.up && newDirection == Direction.down) ||
        (direction == Direction.down && newDirection == Direction.up) ||
        (direction == Direction.left && newDirection == Direction.right) ||
        (direction == Direction.right && newDirection == Direction.left)) {
      return;
    }
    Vibration.vibrate(duration: 20);
    nextDirection = newDirection;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final cellSize = (screenWidth - 48) / gridSize;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundColor : AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('Snake'),
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
            child: Center(
              child: Container(
                width: screenWidth - 48,
                height: screenWidth - 48,
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Grid
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridSize,
                        ),
                        itemCount: gridSize * gridSize,
                        itemBuilder: (context, index) {
                          final x = index % gridSize;
                          final y = index ~/ gridSize;
                          final point = Point(x, y);
                          final isSnakeBody = snake.contains(point);
                          final isSnakeHead = snake.first == point;
                          final isFood = food == point;

                          return Container(
                            decoration: BoxDecoration(
                              color: isSnakeHead
                                  ? Colors.green.shade700
                                  : isSnakeBody
                                      ? Colors.green.shade500
                                      : isFood
                                          ? Colors.red.shade500
                                          : (x + y) % 2 == 0
                                              ? (isDark
                                                  ? Colors.grey.shade800
                                                  : Colors.grey.shade100)
                                              : (isDark
                                                  ? Colors.grey.shade900
                                                  : Colors.grey.shade50),
                              borderRadius: isSnakeBody || isFood
                                  ? BorderRadius.circular(4)
                                  : null,
                            ),
                          );
                        },
                      ),
                      // Game Over Overlay
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
                      // Start Game Overlay
                      if (!isPlaying && !isGameOver)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const Center(
                            child: Text(
                              'Tap Play to Start',
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
          ),
          // Controls
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Play/Restart Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isGameOver ? 'Play Again' : 'Play',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Direction Controls
                Column(
                  children: [
                    // Up button
                    IconButton(
                      onPressed: isPlaying ? () => _changeDirection(Direction.up) : null,
                      icon: const Icon(Icons.keyboard_arrow_up),
                      iconSize: 48,
                      color: isDark ? Colors.white : AppTheme.backgroundColor,
                    ),
                    // Left, Down, Right buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: isPlaying ? () => _changeDirection(Direction.left) : null,
                          icon: const Icon(Icons.keyboard_arrow_left),
                          iconSize: 48,
                          color: isDark ? Colors.white : AppTheme.backgroundColor,
                        ),
                        const SizedBox(width: 48),
                        IconButton(
                          onPressed: isPlaying ? () => _changeDirection(Direction.down) : null,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconSize: 48,
                          color: isDark ? Colors.white : AppTheme.backgroundColor,
                        ),
                        const SizedBox(width: 48),
                        IconButton(
                          onPressed: isPlaying ? () => _changeDirection(Direction.right) : null,
                          icon: const Icon(Icons.keyboard_arrow_right),
                          iconSize: 48,
                          color: isDark ? Colors.white : AppTheme.backgroundColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
