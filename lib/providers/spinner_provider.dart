import 'dart:math';

import 'package:flutter/material.dart';
import '../models/spinner_model.dart';

class SpinnerProvider with ChangeNotifier {
  SpinnerProvider() {
    _segments = List.from(_defaultSegments);
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

  List<SpinnerSegment> get segments => _segments;
  bool get isSpinning => _isSpinning;
  SpinnerSegment? get selectedSegment => _selectedSegment;

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

  Future<void> spin() async {
    if (_isSpinning || _segments.isEmpty) return;

    _isSpinning = true;
    _selectedSegment = null;
    notifyListeners();

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
  }
}

