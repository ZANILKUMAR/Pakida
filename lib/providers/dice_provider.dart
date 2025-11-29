import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/dice_model.dart';

class DiceProvider with ChangeNotifier {
  late final List<Dice> _diceList;
  bool _isRolling = false;
  final Random _random = Random();
  late AudioPlayer _audioPlayer;

  DiceProvider() {
    _diceList = [];
    _initAudio();
    _ensureDefaultDice();
  }

  List<Dice> get diceList => List.unmodifiable(_diceList);
  bool get isRolling => _isRolling;
  int get diceCount => _diceList.length;
  
  int get totalSum => _diceList
      .where((dice) => dice.value != null)
      .fold(0, (sum, dice) => sum + (dice.value ?? 0));

  void _initAudio() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> _playDiceSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/dice_roll.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> _triggerVibration() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Error triggering vibration: $e');
    }
  }

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
    
    // Trigger initial vibration
    await _triggerVibration();
    
    // Set all dice to rolling state
    for (int i = 0; i < _diceList.length; i++) {
      _diceList[i] = Dice(
        type: _diceList[i].type,
        value: null,
        isRolling: true,
      );
    }
    notifyListeners();

    // Play rolling sound at start
    await _playDiceSound();

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

    // Trigger final vibration and sound
    await _triggerVibration();
    await _playDiceSound();

    _isRolling = false;
    notifyListeners();
  }

  Future<void> rollSingleDice(int index) async {
    if (index < 0 || index >= _diceList.length || _isRolling) return;

    // Trigger vibration
    await _triggerVibration();

    final currentDice = _diceList[index];
    _diceList[index] = Dice(
      type: currentDice.type,
      value: null,
      isRolling: true,
    );
    notifyListeners();

    // Play sound
    await _playDiceSound();

    await Future.delayed(const Duration(milliseconds: 800));

    final dice = _diceList[index];
    final value = _random.nextInt(dice.type.sides) + 1;
    _diceList[index] = Dice(
      type: dice.type,
      value: value,
      isRolling: false,
    );

    // Final feedback
    await _triggerVibration();

    notifyListeners();
  }
}


