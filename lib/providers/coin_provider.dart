import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/coin_model.dart';

class CoinProvider with ChangeNotifier {
  late Coin _selectedCoin;
  bool _isFlipping = false;
  Function? _onFlipStart;
  Function? _onFlipEnd;

  CoinProvider() {
    _ensureDefaultCoin();
  }

  Coin get selectedCoin => _selectedCoin;
  bool get isFlipping => _isFlipping;

  int get headsCount => _selectedCoin.headsCount;
  int get tailsCount => _selectedCoin.tailsCount;

  void setFlipCallbacks(Function onFlipStart, Function onFlipEnd) {
    _onFlipStart = onFlipStart;
    _onFlipEnd = onFlipEnd;
  }

  void _ensureDefaultCoin() {
    _selectedCoin = Coin();
    notifyListeners();
  }

  void resetCoin() {
    _selectedCoin = _selectedCoin.copyWith(
      result: null,
      flipCount: 0,
      headsCount: 0,
      tailsCount: 0,
    );
    notifyListeners();
  }

  Future<void> flipCoin() async {
    if (_isFlipping) return;

    _isFlipping = true;
    _selectedCoin = _selectedCoin.copyWith(
      isFlipping: true,
      result: null,
      flipCount: _selectedCoin.flipCount + 1,
    );
    notifyListeners();

    _onFlipStart?.call();

    // Simulate flipping animation duration
    await Future.delayed(const Duration(milliseconds: 1800));

    final random = Random();
    final result = random.nextBool() ? CoinResult.heads : CoinResult.tails;
    
    int newHeads = _selectedCoin.headsCount;
    int newTails = _selectedCoin.tailsCount;
    if (result == CoinResult.heads) {
      newHeads++;
    } else {
      newTails++;
    }
    
    _selectedCoin = _selectedCoin.copyWith(
      result: result,
      isFlipping: false,
      headsCount: newHeads,
      tailsCount: newTails,
    );

    _isFlipping = false;
    notifyListeners();

    _onFlipEnd?.call(result);
  }
}


