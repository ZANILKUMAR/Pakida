import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../theme/app_theme.dart';

class TowerBuilderScreen extends StatefulWidget {
  const TowerBuilderScreen({super.key});

  @override
  State<TowerBuilderScreen> createState() => _TowerBuilderScreenState();
}

class _TowerBuilderScreenState extends State<TowerBuilderScreen> {
  List<double> towerBlocks = [];
  List<double> blockWidths = [];
  double blockX = -0.8;
  double blockDirection = 0.02;
  double blockWidth = 0.4;
  Timer? gameTimer;
  bool isPlaying = false;
  bool isGameOver = false;
  int score = 0;

  void startGame() {
    gameTimer?.cancel();
    gameTimer = null;
    
    setState(() {
      towerBlocks = [0];
      blockWidths = [0.4];
      blockX = -0.8;
      blockDirection = 0.02;
      blockWidth = 0.4;
      isPlaying = true;
      isGameOver = false;
      score = 0;
    });

    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted || !isPlaying) {
        timer.cancel();
        return;
      }
      setState(() {
        blockX += blockDirection;
        if (blockX >= 1 - blockWidth / 2 || blockX <= -1 + blockWidth / 2) {
          blockDirection = -blockDirection;
        }
      });
    });
  }

  void _placeBlock() {
    if (!isPlaying || isGameOver) return;

    double lastBlockX = towerBlocks.last;
    double lastBlockWidth = blockWidths.last;
    double offset = (blockX - lastBlockX).abs();
    
    // Check if there's enough overlap
    double minOverlap = 0.05;
    if (offset > (blockWidth + lastBlockWidth) / 2 - minOverlap) {
      _gameOver();
      return;
    }

    Vibration.vibrate(duration: 50);
    setState(() {
      // Calculate the overlap region
      double leftEdgeCurrent = blockX - blockWidth / 2;
      double rightEdgeCurrent = blockX + blockWidth / 2;
      double leftEdgeLast = lastBlockX - lastBlockWidth / 2;
      double rightEdgeLast = lastBlockX + lastBlockWidth / 2;
      
      // Find the overlap boundaries
      double overlapLeft = leftEdgeCurrent > leftEdgeLast ? leftEdgeCurrent : leftEdgeLast;
      double overlapRight = rightEdgeCurrent < rightEdgeLast ? rightEdgeCurrent : rightEdgeLast;
      
      // New block position is centered in the overlap area
      double newBlockX = (overlapLeft + overlapRight) / 2;
      double newWidth = (overlapRight - overlapLeft).clamp(0.05, 0.4);
      
      towerBlocks.add(newBlockX);
      blockX = newBlockX; // Update current position to new block position
      blockWidth = newWidth;
      blockWidths.add(blockWidth);
      score++;
      // Increase speed slightly, maintaining direction
      blockDirection = blockDirection * 1.02;
    });

    if (score >= 30) {
      _youWin();
    }
  }

  void _gameOver() {
    gameTimer?.cancel();
    gameTimer = null;
    if (!mounted) return;
    Vibration.vibrate(duration: 200);
    setState(() {
      isGameOver = true;
      isPlaying = false;
    });
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Text('You built a tower with $score blocks!'),
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

  void _youWin() {
    gameTimer?.cancel();
    gameTimer = null;
    if (!mounted) return;
    Vibration.vibrate(duration: 200);
    setState(() {
      isPlaying = false;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Amazing!'),
        content: Text('You built a tower with $score blocks!'),
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
    gameTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundColor : AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('Tower Builder'),
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
              onTap: _placeBlock,
              child: Container(
                color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                child: Stack(
                  children: [
                    // Tower blocks
                    ...List.generate(towerBlocks.length, (index) {
                      double blockY = 0.9 - (index * 0.08);
                      // Use the stored width for each block
                      double width = blockWidths[index];
                      return Align(
                        alignment: Alignment(towerBlocks[index], blockY),
                        child: Container(
                          width: MediaQuery.of(context).size.width * width / 2,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade700,
                                Colors.amber.shade500,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.amber.shade800,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    // Moving block
                    if (isPlaying && !isGameOver)
                      Align(
                        alignment: Alignment(
                          blockX,
                          0.9 - (towerBlocks.length * 0.08),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * blockWidth / 2,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade300,
                                Colors.amber.shade400,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.amber.shade600,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
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
                            'Tap to Place Blocks',
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
                  backgroundColor: Colors.amber.shade600,
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
