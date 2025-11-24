import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/spinner_provider.dart';
import '../models/spinner_model.dart';
import '../theme/app_theme.dart';
import '../widgets/spinner_wheel.dart';

class SpinnerWheelScreen extends StatelessWidget {
  SpinnerWheelScreen({super.key});

  final TextEditingController _labelController =
      TextEditingController(text: 'New Entry');

  @override
  Widget build(BuildContext context) {
    final spinnerProvider = Provider.of<SpinnerProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spinner Wheel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () => spinnerProvider.resetToDefault(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.backgroundColor,
                    AppTheme.surfaceColor,
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightBackground,
                    Colors.white,
                  ],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              SpinnerWheel(
                segments: spinnerProvider.segments,
                isSpinning: spinnerProvider.isSpinning,
                selectedSegment: spinnerProvider.selectedSegment,
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.05, end: 0),
              const SizedBox(height: 16),
              Text(
                spinnerProvider.isSpinning
                    ? 'Spinning...'
                    : spinnerProvider.selectedSegment != null
                        ? 'Result: ${spinnerProvider.selectedSegment!.label}'
                        : 'Tap spin to start',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : AppTheme.backgroundColor,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _labelController,
                        decoration: InputDecoration(
                          labelText: 'Add new entry',
                          filled: true,
                          fillColor: isDark
                              ? AppTheme.surfaceColor
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        final text = _labelController.text.trim();
                        if (text.isEmpty) return;
                        spinnerProvider.addSegment(
                          SpinnerSegment(
                            label: text,
                            color: AppTheme.primaryColor
                                .withOpacity(0.7),
                          ),
                        );
                        _labelController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: spinnerProvider.segments.length,
                  itemBuilder: (context, index) {
                    final segment = spinnerProvider.segments[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: segment.color,
                        child: Text(
                          segment.label.characters.first.toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(segment.label),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            spinnerProvider.removeSegment(index),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.surfaceColor : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: spinnerProvider.isSpinning
                        ? null
                        : () => spinnerProvider.spin(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: spinnerProvider.isSpinning
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Spin the Wheel',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.05, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

