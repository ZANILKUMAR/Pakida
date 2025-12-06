enum PlayerSide {
  player1,
  player2,
}

class ChessTimer {
  Duration player1Time;
  Duration player2Time;
  PlayerSide? activePlayer;
  bool isRunning;
  bool isPaused;
  bool isGameOver;
  PlayerSide? winner;

  ChessTimer({
    required this.player1Time,
    required this.player2Time,
    this.activePlayer,
    this.isRunning = false,
    this.isPaused = false,
    this.isGameOver = false,
    this.winner,
  });

  ChessTimer copyWith({
    Duration? player1Time,
    Duration? player2Time,
    PlayerSide? activePlayer,
    bool? isRunning,
    bool? isPaused,
    bool? isGameOver,
    PlayerSide? winner,
    bool clearActivePlayer = false,
    bool clearWinner = false,
  }) {
    return ChessTimer(
      player1Time: player1Time ?? this.player1Time,
      player2Time: player2Time ?? this.player2Time,
      activePlayer:
          clearActivePlayer ? null : (activePlayer ?? this.activePlayer),
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      isGameOver: isGameOver ?? this.isGameOver,
      winner: clearWinner ? null : (winner ?? this.winner),
    );
  }
}
