import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'dice_roller_screen.dart';
import 'coin_flip_screen.dart';
import 'number_dial_screen.dart';
import 'spinner_wheel_screen.dart';
import 'chess_timer_screen.dart';
import 'settings_screen.dart';
import 'games/games_menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedSection = 0; // 0 = Randomizer Tools, 1 = Offline Games

  Widget _buildGridToolCard(
    BuildContext context, {
    required String title,
    required String description,
    IconData? icon,
    Widget? customIcon,
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
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: customIcon ??
                  Icon(
                    icon ?? Icons.error,
                    size: 32,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? Colors.white60
                          : AppTheme.backgroundColor.withOpacity(0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark
                  ? Colors.white38
                  : AppTheme.backgroundColor.withOpacity(0.3),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms, delay: Duration(milliseconds: delay))
          .slideX(
            begin: -0.2,
            end: 0,
            duration: 400.ms,
            delay: Duration(milliseconds: delay),
            curve: Curves.easeOutBack,
          ),
    );
  }

  Widget _buildChessPieceIcon() {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        children: [
          // King piece (white)
          Positioned(
            left: 0,
            top: 0,
            child: CustomPaint(
              size: const Size(18, 32),
              painter: ChessKingPainter(Colors.white),
            ),
          ),
          // Pawn piece (white with slight transparency)
          Positioned(
            right: 0,
            bottom: 0,
            child: CustomPaint(
              size: const Size(16, 28),
              painter: ChessPawnPainter(Colors.white.withOpacity(0.85)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRandomNumberIcon() {
    return SizedBox(
      width: 32,
      height: 32,
      child: CustomPaint(
        size: const Size(32, 32),
        painter: RandomNumberIconPainter(Colors.white),
      ),
    );
  }

  Widget _buildSpinnerWheelIcon() {
    return SizedBox(
      width: 32,
      height: 32,
      child: CustomPaint(
        size: const Size(32, 32),
        painter: SpinnerWheelIconPainter(Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.backgroundColor,
                    AppTheme.surfaceColor,
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightBackground,
                    Colors.white,
                  ],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/pakida_logo.png',
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pakida',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppTheme.backgroundColor,
                            ),
                          ),
                          Text(
                            _selectedSection == 0
                                ? 'Randomizer Tools'
                                : 'Offline Games',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.white70
                                  : AppTheme.backgroundColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings_outlined),
                      color: isDark ? Colors.white : AppTheme.backgroundColor,
                      tooltip: 'Settings',
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: -0.2, end: 0, duration: 400.ms),

              // Section Tabs
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.cardColor.withOpacity(0.5)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabButton(
                          context,
                          'Randomizer Tools',
                          Icons.casino_outlined,
                          0,
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _buildTabButton(
                          context,
                          'Offline Games',
                          Icons.sports_esports_outlined,
                          1,
                          isDark,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 50.ms)
                  .slideY(begin: -0.2, end: 0, duration: 400.ms),

              // Content Area
              Expanded(
                child: _selectedSection == 0
                    ? _buildRandomizerTools(context, isDark)
                    : _buildOfflineGames(context, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    String label,
    IconData icon,
    int index,
    bool isDark,
  ) {
    final isSelected = _selectedSection == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSection = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? AppTheme.primaryGradient
              : LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                  ],
                ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        AppTheme.primaryGradient.colors.first.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Colors.white
                  : isDark
                      ? Colors.white60
                      : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : isDark
                          ? Colors.white60
                          : Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRandomizerTools(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          Expanded(
            child: _buildGridToolCard(
              context,
              title: 'Dice Roller',
              description: 'Roll multiple dice',
              icon: Icons.casino_outlined,
              gradient: AppTheme.primaryGradient,
              screen: const DiceRollerScreen(),
              delay: 100,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _buildGridToolCard(
              context,
              title: 'Chess Timer',
              description: 'Two-player timer',
              customIcon: _buildChessPieceIcon(),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF8B5CF6),
                  const Color(0xFF7C3AED),
                ],
              ),
              screen: const ChessTimerScreen(),
              delay: 200,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _buildGridToolCard(
              context,
              title: 'Coin Flip',
              description: 'Heads or tails',
              icon: Icons.monetization_on_outlined,
              gradient: AppTheme.accentGradient,
              screen: const CoinFlipScreen(),
              delay: 300,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _buildGridToolCard(
              context,
              title: 'Spinner Wheel',
              description: 'Quick random picks',
              customIcon: _buildSpinnerWheelIcon(),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFB7185),
                  const Color(0xFFF59E0B),
                ],
              ),
              screen: SpinnerWheelScreen(),
              delay: 400,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _buildGridToolCard(
              context,
              title: 'Random Number',
              description: 'Generate random',
              customIcon: _buildRandomNumberIcon(),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF10B981),
                  const Color(0xFF059669),
                ],
              ),
              screen: const NumberDialScreen(),
              delay: 500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineGames(BuildContext context, bool isDark) {
    return const GamesMenuScreen();
  }
}

// Custom painter for chess king piece
class ChessKingPainter extends CustomPainter {
  final Color color;

  ChessKingPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Base
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.85, size.width * 0.8,
          size.height * 0.12),
      paint,
    );

    // Stem
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.35, size.height * 0.55, size.width * 0.3,
          size.height * 0.35),
      paint,
    );

    // Body (circle)
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.45),
      size.width * 0.25,
      paint,
    );

    // Cross on top
    // Vertical line
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.43, size.height * 0.05, size.width * 0.14,
          size.height * 0.25),
      paint,
    );
    // Horizontal line
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.25, size.height * 0.13, size.width * 0.5,
          size.height * 0.1),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for chess pawn piece
class ChessPawnPainter extends CustomPainter {
  final Color color;

  ChessPawnPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Base
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.85, size.width * 0.8,
          size.height * 0.12),
      paint,
    );

    // Stem
    final stemPath = Path();
    stemPath.moveTo(size.width * 0.4, size.height * 0.5);
    stemPath.lineTo(size.width * 0.35, size.height * 0.85);
    stemPath.lineTo(size.width * 0.65, size.height * 0.85);
    stemPath.lineTo(size.width * 0.6, size.height * 0.5);
    stemPath.close();
    canvas.drawPath(stemPath, paint);

    // Head (circle)
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.35),
      size.width * 0.22,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for random number icon (digital display style)
class RandomNumberIconPainter extends CustomPainter {
  final Color color;

  RandomNumberIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw digital display frame
    final framePath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.15, size.width, size.height * 0.7),
        const Radius.circular(4),
      ));
    canvas.drawPath(framePath, strokePaint);

    // Draw stylized numbers "123" in digital/segmented style
    // Number "1"
    _drawDigitalOne(canvas, size.width * 0.15, size.height * 0.35,
        size.width * 0.15, size.height * 0.35, paint);

    // Number "2"
    _drawDigitalTwo(canvas, size.width * 0.42, size.height * 0.35,
        size.width * 0.15, size.height * 0.35, paint);

    // Number "3"
    _drawDigitalThree(canvas, size.width * 0.69, size.height * 0.35,
        size.width * 0.15, size.height * 0.35, paint);

    // Add random/shuffle arrows at corners
    final arrowPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Top right arrow
    final arrow1 = Path()
      ..moveTo(size.width * 0.85, size.height * 0.05)
      ..lineTo(size.width * 0.95, size.height * 0.1)
      ..lineTo(size.width * 0.85, size.height * 0.15)
      ..close();
    canvas.drawPath(arrow1, arrowPaint);

    // Bottom left arrow
    final arrow2 = Path()
      ..moveTo(size.width * 0.15, size.height * 0.85)
      ..lineTo(size.width * 0.05, size.height * 0.9)
      ..lineTo(size.width * 0.15, size.height * 0.95)
      ..close();
    canvas.drawPath(arrow2, arrowPaint);
  }

  void _drawDigitalOne(
      Canvas canvas, double x, double y, double w, double h, Paint paint) {
    // Vertical right segment
    canvas.drawRect(Rect.fromLTWH(x + w * 0.6, y, w * 0.25, h), paint);
  }

  void _drawDigitalTwo(
      Canvas canvas, double x, double y, double w, double h, Paint paint) {
    final segmentHeight = h * 0.15;
    // Top horizontal
    canvas.drawRect(Rect.fromLTWH(x, y, w, segmentHeight), paint);
    // Right top vertical
    canvas.drawRect(
        Rect.fromLTWH(x + w - w * 0.25, y, w * 0.25, h * 0.42), paint);
    // Middle horizontal
    canvas.drawRect(Rect.fromLTWH(x, y + h * 0.42, w, segmentHeight), paint);
    // Left bottom vertical
    canvas.drawRect(Rect.fromLTWH(x, y + h * 0.42, w * 0.25, h * 0.58), paint);
    // Bottom horizontal
    canvas.drawRect(
        Rect.fromLTWH(x, y + h - segmentHeight, w, segmentHeight), paint);
  }

  void _drawDigitalThree(
      Canvas canvas, double x, double y, double w, double h, Paint paint) {
    final segmentHeight = h * 0.15;
    // Top horizontal
    canvas.drawRect(Rect.fromLTWH(x, y, w, segmentHeight), paint);
    // Right top vertical
    canvas.drawRect(
        Rect.fromLTWH(x + w - w * 0.25, y, w * 0.25, h * 0.42), paint);
    // Middle horizontal
    canvas.drawRect(Rect.fromLTWH(x, y + h * 0.42, w, segmentHeight), paint);
    // Right bottom vertical
    canvas.drawRect(
        Rect.fromLTWH(x + w - w * 0.25, y + h * 0.42, w * 0.25, h * 0.58),
        paint);
    // Bottom horizontal
    canvas.drawRect(
        Rect.fromLTWH(x, y + h - segmentHeight, w, segmentHeight), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for spinner wheel icon
class SpinnerWheelIconPainter extends CustomPainter {
  final Color color;

  SpinnerWheelIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = size.width * 0.42;

    // Draw outer circle
    canvas.drawCircle(center, radius, strokePaint);

    // Draw wheel segments (8 segments)
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * math.pi / 180;
      final endX = center.dx + radius * 0.9 * math.cos(angle);
      final endY = center.dy + radius * 0.9 * math.sin(angle);

      canvas.drawLine(
        center,
        Offset(endX, endY),
        strokePaint..strokeWidth = 1.5,
      );
    }

    // Draw alternating filled segments for visual interest
    for (int i = 0; i < 8; i += 2) {
      final startAngle = (i * 45 - 90) * math.pi / 180;
      final sweepAngle = 45 * math.pi / 180;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, paint..color = color.withOpacity(0.3));
    }

    // Draw center hub
    canvas.drawCircle(center, size.width * 0.12, paint..color = color);

    // Draw pointer/arrow at top
    final arrowPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.02)
      ..lineTo(size.width * 0.42, size.height * 0.12)
      ..lineTo(size.width * 0.58, size.height * 0.12)
      ..close();
    canvas.drawPath(arrowPath, paint..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
