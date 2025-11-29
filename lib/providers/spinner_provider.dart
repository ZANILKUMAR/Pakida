import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import '../models/spinner_model.dart';
import 'settings_provider.dart';

class SpinnerProvider with ChangeNotifier {
  late AudioPlayer _audioPlayer;
  final SettingsProvider _settingsProvider;

  SpinnerProvider(this._settingsProvider) {
    _segments = List.from(_defaultSegments);
    _audioPlayer = AudioPlayer();
  }

  static final List<SpinnerSegment> _defaultSegments = [
    const SpinnerSegment(label: '1', color: Color(0xFF6366F1)),
    const SpinnerSegment(label: '2', color: Color(0xFFEC4899)),
    const SpinnerSegment(label: '3', color: Color(0xFFF59E0B)),
    const SpinnerSegment(label: '4', color: Color(0xFF10B981)),
    const SpinnerSegment(label: '5', color: Color(0xFF3B82F6)),
    const SpinnerSegment(label: '-2', color: Color(0xFFA855F7)),
    const SpinnerSegment(label: '-3', color: Color(0xFFEF4444)),
    const SpinnerSegment(label: '-4', color: Color(0xFF14B8A6)),
    const SpinnerSegment(label: '-5', color: Color(0xFFF97316)),
  ];

  late List<SpinnerSegment> _segments;
  bool _isSpinning = false;
  SpinnerSegment? _selectedSegment;
  Function? _onSpinStart;
  Function? _onSpinEnd;

  List<SpinnerSegment> get segments => _segments;
  bool get isSpinning => _isSpinning;
  SpinnerSegment? get selectedSegment => _selectedSegment;

  void setSpinCallbacks(Function onSpinStart, Function onSpinEnd) {
    _onSpinStart = onSpinStart;
    _onSpinEnd = onSpinEnd;
  }

  void resetToDefault() {
    _segments = List.from(_defaultSegments);
    _selectedSegment = null;
    notifyListeners();
  }

  void addSegment(SpinnerSegment segment) {
    _segments.add(segment);
    notifyListeners();
  }

  void removeSegment(int index) {
    if (_segments.length <= 2) return;
    if (index >= 0 && index < _segments.length) {
      _segments.removeAt(index);
      if (_selectedSegment != null &&
          index < _segments.length &&
          _segments[index] == _selectedSegment) {
        _selectedSegment = null;
      }
      notifyListeners();
    }
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
    if (_isSpinning || _segments.isEmpty) return;

    _isSpinning = true;
    _selectedSegment = null;
    notifyListeners();

    _onSpinStart?.call();
    await _playSound('spin_start.wav');
    await _playVibration();

    // Spin for 2.8 seconds
    await Future.delayed(const Duration(milliseconds: 2800));

    // Select a random segment
    // The wheel will spin 6 full rotations + random partial rotation
    // to end with this segment at the pointer
    final random = Random();
    final segmentIndex = random.nextInt(_segments.length);
    
    _selectedSegment = _segments[segmentIndex];
    _isSpinning = false;
    notifyListeners();

    await _playSound('spin_end.wav');
    await _playVibration();
    _onSpinEnd?.call(_selectedSegment);
  }
}



