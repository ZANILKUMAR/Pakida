import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/number_dial_model.dart';

class NumberDialProvider with ChangeNotifier {
  NumberDial _numberDial = NumberDial(min: 1, max: 100, currentValue: 50);
  bool _isSpinning = false;

  NumberDial get numberDial => _numberDial;
  bool get isSpinning => _isSpinning;

  void setRange(int min, int max) {
    if (min >= max) return;
    _numberDial = _numberDial.copyWith(
      min: min,
      max: max,
      currentValue: (min + max) ~/ 2,
    );
    notifyListeners();
  }

  Future<void> spin() async {
    if (_isSpinning) return;

    _isSpinning = true;
    notifyListeners();

    // Simulate spinning animation duration
    await Future.delayed(const Duration(milliseconds: 3000));

    // Generate random value
    final random = Random();
    final newValue = _numberDial.min + random.nextInt(_numberDial.max - _numberDial.min + 1);
    
    _numberDial = _numberDial.copyWith(
      currentValue: newValue,
      isSpinning: false,
    );
    _isSpinning = false;
    notifyListeners();
  }

  void setValue(int value) {
    if (value >= _numberDial.min && value <= _numberDial.max) {
      _numberDial = _numberDial.copyWith(currentValue: value);
      notifyListeners();
    }
  }
}


