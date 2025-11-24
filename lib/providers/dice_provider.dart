import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/dice_model.dart';

class DiceProvider with ChangeNotifier {
  DiceProvider() {
    _ensureDefaultDice();
  }

  final List<Dice> _diceList = [];
  bool _isRolling = false;

  List<Dice> get diceList => _diceList;
  bool get isRolling => _isRolling;
  
  int get totalSum => _diceList
      .where((dice) => dice.value != null)
      .fold(0, (sum, dice) => sum + (dice.value ?? 0));

  void _ensureDefaultDice() {
    if (_diceList.isEmpty) {
      _diceList.add(Dice(type: DiceType.d6));
    }
  }

  void addDice(DiceType type) {
    _diceList.add(Dice(type: type));
    notifyListeners();
  }

  void removeDice(int index) {
    if (index >= 0 && index < _diceList.length) {
      _diceList.removeAt(index);
      _ensureDefaultDice();
      notifyListeners();
    }
  }

  void setDiceType(int index, DiceType type) {
    if (index >= 0 && index < _diceList.length) {
      _diceList[index] = _diceList[index].copyWith(
        type: type,
        value: null,
        isRolling: false,
      );
      notifyListeners();
    }
  }

  void clearAllDice() {
    _diceList.clear();
    _ensureDefaultDice();
    notifyListeners();
  }

  Future<void> rollAllDice() async {
    if (_diceList.isEmpty || _isRolling) return;

    _isRolling = true;
    
    // Set all dice to rolling state
    for (int i = 0; i < _diceList.length; i++) {
      _diceList[i] = _diceList[i].copyWith(isRolling: true, value: null);
    }
    notifyListeners();

    // Simulate rolling animation duration
    await Future.delayed(const Duration(milliseconds: 1500));

    // Roll each dice
    final random = Random();
    for (int i = 0; i < _diceList.length; i++) {
      final dice = _diceList[i];
      final value = random.nextInt(dice.type.sides) + 1;
      _diceList[i] = dice.copyWith(
        value: value,
        isRolling: false,
      );
    }

    _isRolling = false;
    notifyListeners();
  }

  void rollSingleDice(int index) async {
    if (index < 0 || index >= _diceList.length || _isRolling) return;

    _diceList[index] = _diceList[index].copyWith(isRolling: true, value: null);
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    final random = Random();
    final dice = _diceList[index];
    final value = random.nextInt(dice.type.sides) + 1;
    _diceList[index] = dice.copyWith(
      value: value,
      isRolling: false,
    );
    notifyListeners();
  }
}


