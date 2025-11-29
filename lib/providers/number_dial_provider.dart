import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import '../models/number_dial_model.dart';
import 'settings_provider.dart';

class NumberDialProvider with ChangeNotifier {
  NumberDial _numberDial = NumberDial(min: 1, max: 100, currentValue: 0);
  bool _isSpinning = false;
  late AudioPlayer _audioPlayer;
  final SettingsProvider _settingsProvider;
  Function? _onSpinStart;
  Function? _onSpinEnd;

  NumberDialProvider(this._settingsProvider) {
    _audioPlayer = AudioPlayer();
  }

  NumberDial get numberDial => _numberDial;
  bool get isSpinning => _isSpinning;

  void setSpinCallbacks(Function onSpinStart, Function onSpinEnd) {
    _onSpinStart = onSpinStart;
    _onSpinEnd = onSpinEnd;
  }

  void setRange(int min, int max) {
    if (min >= max) return;
    _numberDial = _numberDial.copyWith(
      min: min,
      max: max,
      currentValue: 0,
    );
    notifyListeners();
  }

  Future<void> _playSound(String soundFile) async {
    if (!_settingsProvider.soundEnabled) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/$soundFile'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playVibration() async {
    if (!_settingsProvider.vibrationEnabled) return;
    try {
      if (defaultTargetPlatform == TargetPlatform.android || 
          defaultTargetPlatform == TargetPlatform.iOS) {
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator == true) {
          await Vibration.vibrate(duration: 50);
        } else {
          await HapticFeedback.mediumImpact();
        }
      }
    } catch (e) {
      debugPrint('Error playing vibration: $e');
      try {
        await HapticFeedback.mediumImpact();
      } catch (_) {}
    }
  }

  Future<void> spin() async {
    if (_isSpinning) return;

    _isSpinning = true;
    notifyListeners();

    _onSpinStart?.call();
    await _playSound('dial_spin.wav');
    await _playVibration();

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

    await _playSound('dial_land.wav');
    await _playVibration();
    _onSpinEnd?.call(newValue);
  }

  void setValue(int value) {
    if (value >= _numberDial.min && value <= _numberDial.max) {
      _numberDial = _numberDial.copyWith(currentValue: value);
      notifyListeners();
    }
  }
}




