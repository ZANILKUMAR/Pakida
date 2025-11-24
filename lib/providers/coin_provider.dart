import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/coin_model.dart';

class CoinProvider with ChangeNotifier {
  final List<Coin> _coins = [];
  bool _isFlipping = false;

  List<Coin> get coins => _coins;
  bool get isFlipping => _isFlipping;

  int get headsCount => _coins.where((c) => c.result == CoinResult.heads).length;
  int get tailsCount => _coins.where((c) => c.result == CoinResult.tails).length;

  void addCoin() {
    _coins.add(Coin());
    notifyListeners();
  }

  void removeCoin(int index) {
    if (index >= 0 && index < _coins.length) {
      _coins.removeAt(index);
      notifyListeners();
    }
  }

  void clearAllCoins() {
    _coins.clear();
    notifyListeners();
  }

  Future<void> flipAllCoins() async {
    if (_coins.isEmpty || _isFlipping) return;

    _isFlipping = true;
    
    // Set all coins to flipping state
    for (int i = 0; i < _coins.length; i++) {
      _coins[i] = _coins[i].copyWith(
        isFlipping: true,
        result: null,
        flipCount: _coins[i].flipCount + 1,
      );
    }
    notifyListeners();

    // Simulate flipping animation duration
    await Future.delayed(const Duration(milliseconds: 2000));

    // Flip each coin
    final random = Random();
    for (int i = 0; i < _coins.length; i++) {
      final result = random.nextBool() ? CoinResult.heads : CoinResult.tails;
      _coins[i] = _coins[i].copyWith(
        result: result,
        isFlipping: false,
      );
    }

    _isFlipping = false;
    notifyListeners();
  }

  Future<void> flipSingleCoin(int index) async {
    if (index < 0 || index >= _coins.length || _isFlipping) return;

    _coins[index] = _coins[index].copyWith(
      isFlipping: true,
      result: null,
      flipCount: _coins[index].flipCount + 1,
    );
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    final random = Random();
    final result = random.nextBool() ? CoinResult.heads : CoinResult.tails;
    _coins[index] = _coins[index].copyWith(
      result: result,
      isFlipping: false,
    );
    notifyListeners();
  }
}


