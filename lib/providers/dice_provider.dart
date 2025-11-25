import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/dice_model.dart';

class DiceProvider with ChangeNotifier {
  DiceProvider() {
    _ensureDefaultDice();
  }

  final List<Dice> _diceList = [];
  bool _isRolling = false;
  final Random _random = Random();

  List<Dice> get diceList => List.unmodifiable(_diceList);
  bool get isRolling => _isRolling;
  int get diceCount => _diceList.length;
  
  int get totalSum => _diceList
      .where((dice) => dice.value != null)
      .fold(0, (sum, dice) => sum + (dice.value ?? 0));

  void _ensureDefaultDice() {
    if (_diceList.isEmpty) {
      _diceList.add(Dice(type: DiceType.d6, value: null, isRolling: false));
      notifyListeners();
    }
  }

  void addDice(DiceType type) {
    _diceList.add(Dice(type: type, value: null, isRolling: false));
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
      _diceList[index] = Dice(type: type, value: null, isRolling: false);
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
    notifyListeners();
    
    // Set all dice to rolling state
    for (int i = 0; i < _diceList.length; i++) {
      _diceList[i] = Dice(
        type: _diceList[i].type,
        value: null,
        isRolling: true,
      );
    }
    notifyListeners();

    // Simulate rolling animation duration
    await Future.delayed(const Duration(milliseconds: 1200));

    // Roll each dice with random values
    for (int i = 0; i < _diceList.length; i++) {
      final dice = _diceList[i];
      final value = _random.nextInt(dice.type.sides) + 1;
      _diceList[i] = Dice(
        type: dice.type,
        value: value,
        isRolling: false,
      );
    }

    _isRolling = false;
    notifyListeners();
  }

  Future<void> rollSingleDice(int index) async {
    if (index < 0 || index >= _diceList.length || _isRolling) return;

    final currentDice = _diceList[index];
    _diceList[index] = Dice(
      type: currentDice.type,
      value: null,
      isRolling: true,
    );
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    final dice = _diceList[index];
    final value = _random.nextInt(dice.type.sides) + 1;
    _diceList[index] = Dice(
      type: dice.type,
      value: value,
      isRolling: false,
    );
    notifyListeners();
  }
}


