enum CoinResult {
  heads,
  tails,
}

class Coin {
  CoinResult? result;
  bool isFlipping;
  int flipCount;
  int headsCount;
  int tailsCount;

  Coin({
    this.result,
    this.isFlipping = false,
    this.flipCount = 0,
    this.headsCount = 0,
    this.tailsCount = 0,
  });

  Coin copyWith({
    CoinResult? result,
    bool? isFlipping,
    int? flipCount,
    int? headsCount,
    int? tailsCount,
    bool clearResult = false,
  }) {
    return Coin(
      result: clearResult ? null : (result ?? this.result),
      isFlipping: isFlipping ?? this.isFlipping,
      flipCount: flipCount ?? this.flipCount,
      headsCount: headsCount ?? this.headsCount,
      tailsCount: tailsCount ?? this.tailsCount,
    );
  }
}


