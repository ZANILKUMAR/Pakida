enum CoinResult {
  heads,
  tails,
}

class Coin {
  CoinResult? result;
  bool isFlipping;
  int flipCount;

  Coin({
    this.result,
    this.isFlipping = false,
    this.flipCount = 0,
  });

  Coin copyWith({
    CoinResult? result,
    bool? isFlipping,
    int? flipCount,
  }) {
    return Coin(
      result: result ?? this.result,
      isFlipping: isFlipping ?? this.isFlipping,
      flipCount: flipCount ?? this.flipCount,
    );
  }
}


