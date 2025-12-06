import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/chess_timer_model.dart';

class ChessTimerProvider with ChangeNotifier {
  ChessTimer _timer = ChessTimer(
    player1Time: const Duration(minutes: 10),
    player2Time: const Duration(minutes: 10),
  );

  Timer? _countdownTimer;
  Duration _initialDuration = const Duration(minutes: 10);
  Function? _onGameEnd;

  ChessTimer get timer => _timer;

  void setGameEndCallback(Function onGameEnd) {
    _onGameEnd = onGameEnd;
  }

  void setInitialTime(Duration duration) {
    // Allow setting time only when timer is not actively running
    if (_timer.isRunning && !_timer.isPaused && !_timer.isGameOver) return;

    _initialDuration = duration;
    _timer = ChessTimer(
      player1Time: duration,
      player2Time: duration,
    );
    notifyListeners();
  }

  void startTimer(PlayerSide player) {
    if (_timer.isGameOver) return;

    _timer = _timer.copyWith(
      activePlayer: player,
      isRunning: true,
      isPaused: false,
    );

    _startCountdown();
    notifyListeners();
  }

  void switchPlayer() {
    if (!_timer.isRunning || _timer.isPaused || _timer.isGameOver) return;

    final newActivePlayer = _timer.activePlayer == PlayerSide.player1
        ? PlayerSide.player2
        : PlayerSide.player1;

    _timer = _timer.copyWith(activePlayer: newActivePlayer);
    notifyListeners();
  }

  void pauseTimer() {
    if (!_timer.isRunning || _timer.isGameOver) return;

    _countdownTimer?.cancel();
    _timer = _timer.copyWith(isPaused: true);
    notifyListeners();
  }

  void resumeTimer() {
    if (!_timer.isPaused || _timer.isGameOver) return;

    _timer = _timer.copyWith(isPaused: false);
    _startCountdown();
    notifyListeners();
  }

  void resetTimer() {
    _countdownTimer?.cancel();

    _timer = ChessTimer(
      player1Time: _initialDuration,
      player2Time: _initialDuration,
    );
    notifyListeners();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();

    _countdownTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_timer.isPaused || _timer.isGameOver) {
        timer.cancel();
        return;
      }

      Duration newTime;

      if (_timer.activePlayer == PlayerSide.player1) {
        newTime = _timer.player1Time - const Duration(milliseconds: 100);

        if (newTime.isNegative || newTime == Duration.zero) {
          _timer = _timer.copyWith(player1Time: Duration.zero);
          notifyListeners();
          _endGame(PlayerSide.player2);
          return;
        }

        _timer = _timer.copyWith(player1Time: newTime);
      } else {
        newTime = _timer.player2Time - const Duration(milliseconds: 100);

        if (newTime.isNegative || newTime == Duration.zero) {
          _timer = _timer.copyWith(player2Time: Duration.zero);
          notifyListeners();
          _endGame(PlayerSide.player1);
          return;
        }

        _timer = _timer.copyWith(player2Time: newTime);
      }

      notifyListeners();
    });
  }

  void _endGame(PlayerSide winner) {
    _countdownTimer?.cancel();

    _timer = _timer.copyWith(
      isRunning: false,
      isGameOver: true,
      winner: winner,
    );

    // Call the game end callback if set
    _onGameEnd?.call();

    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
