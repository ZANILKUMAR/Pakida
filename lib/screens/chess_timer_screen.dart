import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/chess_timer_provider.dart';
import '../providers/settings_provider.dart';
import '../models/chess_timer_model.dart';
import '../theme/app_theme.dart';

class ChessTimerScreen extends StatefulWidget {
  const ChessTimerScreen({super.key});

  @override
  State<ChessTimerScreen> createState() => _ChessTimerScreenState();
}

class _ChessTimerScreenState extends State<ChessTimerScreen> {
  final List<int> _presetMinutes = [1, 3, 5, 10, 15, 30, 60];
  int _selectedPreset = 10;

  @override
  void initState() {
    super.initState();
    // No sound callback needed - only tap sounds play
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<ChessTimerProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timer = timerProvider.timer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Timer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showTimeSettings(context),
          ),
        ],
      ),
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
              // Player 2 Timer (Top - Rotated)
              Expanded(
                child: _buildPlayerTimer(
                  context,
                  PlayerSide.player2,
                  timer.player2Time,
                  timer.activePlayer == PlayerSide.player2,
                  timer.winner == PlayerSide.player2,
                  timer.winner == PlayerSide.player1,
                  isRotated: true,
                  onTap: () {
                    if (!timer.isRunning && !timer.isGameOver) {
                      timerProvider.startTimer(PlayerSide.player2);
                      settingsProvider.playSound('chessTimer.wav');
                      settingsProvider.playVibration();
                    } else if (timer.isRunning &&
                        timer.activePlayer == PlayerSide.player1 &&
                        !timer.isPaused) {
                      timerProvider.switchPlayer();
                      settingsProvider.playSound('chessTimer.wav');
                      settingsProvider.playVibration();
                    }
                  },
                ),
              ),

              // Control Bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.surfaceColor : Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Reset Button
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 32),
                      color: AppTheme.primaryColor,
                      onPressed: () {
                        timerProvider.resetTimer();
                        settingsProvider.playVibration();
                      },
                    ),

                    // Pause/Resume Button
                    if (timer.isRunning && !timer.isGameOver)
                      IconButton(
                        icon: Icon(
                          timer.isPaused ? Icons.play_arrow : Icons.pause,
                          size: 32,
                        ),
                        color: AppTheme.secondaryColor,
                        onPressed: () {
                          if (timer.isPaused) {
                            timerProvider.resumeTimer();
                          } else {
                            timerProvider.pauseTimer();
                          }
                          settingsProvider.playVibration();
                        },
                      ),
                  ],
                ),
              ),

              // Player 1 Timer (Bottom)
              Expanded(
                child: _buildPlayerTimer(
                  context,
                  PlayerSide.player1,
                  timer.player1Time,
                  timer.activePlayer == PlayerSide.player1,
                  timer.winner == PlayerSide.player1,
                  timer.winner == PlayerSide.player2,
                  isRotated: false,
                  onTap: () {
                    if (!timer.isRunning && !timer.isGameOver) {
                      timerProvider.startTimer(PlayerSide.player1);
                      settingsProvider.playSound('chessTimer.wav');
                      settingsProvider.playVibration();
                    } else if (timer.isRunning &&
                        timer.activePlayer == PlayerSide.player2 &&
                        !timer.isPaused) {
                      timerProvider.switchPlayer();
                      settingsProvider.playSound('chessTimer.wav');
                      settingsProvider.playVibration();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerTimer(
    BuildContext context,
    PlayerSide player,
    Duration time,
    bool isActive,
    bool isWinner,
    bool isLoser, {
    required bool isRotated,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final playerNumber = player == PlayerSide.player1 ? 1 : 2;
    final isPlayer1 = player == PlayerSide.player1;

    // Define color themes for each player
    final Color player1BaseColor = const Color(0xFF3B82F6); // Blue
    final Color player2BaseColor = const Color(0xFFEF4444); // Red
    final Color playerThemeColor =
        isPlayer1 ? player1BaseColor : player2BaseColor;

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    Color labelColor;

    if (isWinner) {
      backgroundColor = Colors.green.withOpacity(0.3);
      borderColor = Colors.green;
      textColor = isDark ? Colors.white : Colors.black87;
      labelColor = isDark ? Colors.white70 : Colors.black54;
    } else if (isLoser) {
      backgroundColor = Colors.red.withOpacity(0.3);
      borderColor = Colors.red;
      textColor = Colors.red;
      labelColor = Colors.red.withOpacity(0.7);
    } else if (isActive) {
      backgroundColor = isDark
          ? playerThemeColor.withOpacity(0.25)
          : playerThemeColor.withOpacity(0.12);
      borderColor = playerThemeColor;
      textColor = isDark ? Colors.white : playerThemeColor;
      labelColor = isDark ? Colors.white70 : playerThemeColor.withOpacity(0.8);
    } else {
      backgroundColor =
          isDark ? AppTheme.surfaceColor : playerThemeColor.withOpacity(0.05);
      borderColor = Colors.transparent;
      textColor = isDark ? Colors.white60 : Colors.black54;
      labelColor = isDark ? Colors.white38 : Colors.black38;
    }

    Widget content = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: isActive ? borderColor : Colors.transparent,
          width: isActive ? 4 : 0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: playerThemeColor.withOpacity(isActive ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Player $playerNumber',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isActive ? playerThemeColor : labelColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _formatTime(time),
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    color: textColor,
                  ),
                ),
                if (isWinner) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'WINNER!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ] else if (isLoser) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'TIME OUT',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    if (isRotated) {
      content = Transform.rotate(
        angle: 3.14159, // 180 degrees in radians
        child: content,
      );
    }

    return content;
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final centiseconds = (duration.inMilliseconds.remainder(1000) ~/ 10)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds.$centiseconds';
  }

  void _showTimeSettings(BuildContext context) {
    final timerProvider =
        Provider.of<ChessTimerProvider>(context, listen: false);
    final timer = timerProvider.timer;

    if (timer.isRunning && !timer.isPaused) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot change time while timer is running'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppTheme.surfaceColor
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Time',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: _presetMinutes.map((minutes) {
                      final isSelected = _selectedPreset == minutes;
                      return InkWell(
                        onTap: () {
                          setModalState(() {
                            _selectedPreset = minutes;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$minutes min',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? Colors.white : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showCustomTimeInput(context);
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Custom Time'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        timerProvider.setInitialTime(
                          Duration(minutes: _selectedPreset),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Set Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCustomTimeInput(BuildContext context) {
    final timerProvider =
        Provider.of<ChessTimerProvider>(context, listen: false);
    final minutesController = TextEditingController();
    final secondsController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppTheme.surfaceColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Custom Time',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Minutes',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: minutesController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            hintText: '0',
                            filled: true,
                            fillColor: isDark
                                ? AppTheme.backgroundColor
                                : Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seconds',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: secondsController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            hintText: '0',
                            filled: true,
                            fillColor: isDark
                                ? AppTheme.backgroundColor
                                : Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Dismiss keyboard first
                    FocusScope.of(context).unfocus();

                    final minutes = int.tryParse(minutesController.text) ?? 0;
                    final seconds = int.tryParse(secondsController.text) ?? 0;

                    if (minutes == 0 && seconds == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid time'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    if (seconds >= 60) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Seconds must be less than 60'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    final totalDuration =
                        Duration(minutes: minutes, seconds: seconds);

                    if (totalDuration.inSeconds > 3600) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Maximum time is 60 minutes'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    timerProvider.setInitialTime(totalDuration);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Set Custom Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
