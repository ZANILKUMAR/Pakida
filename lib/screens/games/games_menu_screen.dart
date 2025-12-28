import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import 'snake_game_screen.dart';
import 'memory_match_screen.dart';
import 'game_2048_screen.dart';
import 'number_puzzle_screen.dart';
import 'brick_breaker_screen.dart';
import 'flappy_bird_screen.dart';
import 'color_match_screen.dart';
import 'tower_builder_screen.dart';
import 'ping_pong_screen.dart';
import 'tap_the_dot_screen.dart';
import 'quick_math_screen.dart';

class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
        children: [
          _buildGameCard(
            context,
            title: 'Snake',
            icon: Icons.swap_calls,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green.shade600, Colors.green.shade800],
            ),
            screen: const SnakeGameScreen(),
            delay: 100,
          ),
          _buildGameCard(
            context,
            title: 'Memory Match',
            icon: Icons.grid_4x4,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade500, Colors.purple.shade700],
            ),
            screen: const MemoryMatchScreen(),
            delay: 150,
          ),
          _buildGameCard(
            context,
            title: '2048',
            icon: Icons.apps,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.orange.shade600, Colors.deepOrange.shade700],
            ),
            screen: const Game2048Screen(),
            delay: 200,
          ),
          _buildGameCard(
            context,
            title: 'Number Puzzle',
            icon: Icons.extension,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade600, Colors.blue.shade800],
            ),
            screen: const NumberPuzzleScreen(),
            delay: 250,
          ),
          _buildGameCard(
            context,
            title: 'Brick Breaker',
            icon: Icons.view_agenda,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red.shade600, Colors.red.shade800],
            ),
            screen: const BrickBreakerScreen(),
            delay: 300,
          ),
          _buildGameCard(
            context,
            title: 'Flappy Bird',
            icon: Icons.flight_takeoff,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.cyan.shade600, Colors.cyan.shade800],
            ),
            screen: const FlappyBirdScreen(),
            delay: 350,
          ),
          _buildGameCard(
            context,
            title: 'Color Match',
            icon: Icons.palette,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pink.shade500, Colors.pink.shade700],
            ),
            screen: const ColorMatchScreen(),
            delay: 400,
          ),
          _buildGameCard(
            context,
            title: 'Tower Builder',
            icon: Icons.layers,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.amber.shade600, Colors.amber.shade800],
            ),
            screen: const TowerBuilderScreen(),
            delay: 450,
          ),
          _buildGameCard(
            context,
            title: 'Ping Pong',
            icon: Icons.sports_tennis,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal.shade600, Colors.teal.shade800],
            ),
            screen: const PingPongScreen(),
            delay: 500,
          ),
          _buildGameCard(
            context,
            title: 'Tap the Dot',
            icon: Icons.touch_app,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo.shade600, Colors.indigo.shade800],
            ),
            screen: const TapTheDotScreen(),
            delay: 550,
          ),
          _buildGameCard(
            context,
            title: 'Quick Math',
            icon: Icons.calculate,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple.shade600, Colors.deepPurple.shade800],
            ),
            screen: const QuickMathScreen(),
            delay: 600,
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Gradient gradient,
    required Widget screen,
    required int delay,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: gradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.backgroundColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms, delay: Duration(milliseconds: delay))
          .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            duration: 400.ms,
            delay: Duration(milliseconds: delay),
            curve: Curves.easeOutBack,
          ),
    );
  }
}
