import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/spinner_provider.dart';
import '../models/spinner_model.dart';
import '../theme/app_theme.dart';
import '../widgets/spinner_wheel.dart';

class SpinnerWheelScreen extends StatefulWidget {
  const SpinnerWheelScreen({super.key});

  @override
  State<SpinnerWheelScreen> createState() => _SpinnerWheelScreenState();
}

class _SpinnerWheelScreenState extends State<SpinnerWheelScreen> {
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
          IconButton(
            onPressed: () => _showEntriesBottomSheet(context),
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Manage Entries',
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
          child: spinnerProvider.segments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 80,
                        color: isDark
                            ? Colors.white38
                            : AppTheme.backgroundColor.withOpacity(0.3),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No Entries Yet',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tap the + icon to add entries',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? Colors.white60
                              : AppTheme.backgroundColor.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          final provider = Provider.of<SpinnerProvider>(context, listen: false);
                          _onAddButtonPressed(context, provider);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add First Entry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinnerWheel(
                              segments: spinnerProvider.segments,
                              isSpinning: spinnerProvider.isSpinning,
                              selectedSegment: spinnerProvider.selectedSegment,
                            )
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: -0.05, end: 0),
                          ],
                        ),
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
                        child: ElevatedButton.icon(
                          onPressed: spinnerProvider.isSpinning
                              ? null
                              : () => spinnerProvider.spin(),
                          icon: const Icon(Icons.casino),
                          label: const Text('Spin the Wheel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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

  void _onAddButtonPressed(BuildContext context, SpinnerProvider provider) {
    Navigator.pop(context); // Close the bottom sheet if open
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final TextEditingController labelController = TextEditingController();
    Color selectedColor = AppTheme.primaryColor;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (sbContext, setState) {
          return AlertDialog(
            backgroundColor: isDark ? AppTheme.cardColor : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Add New Entry'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: labelController,
                    decoration: InputDecoration(
                      labelText: 'Entry Name',
                      filled: true,
                      fillColor: isDark
                          ? AppTheme.surfaceColor
                          : Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'e.g., Pizza, Burger, Pasta',
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Choose Color',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: [
                      const Color(0xFF6366F1),
                      const Color(0xFFEC4899),
                      const Color(0xFFF59E0B),
                      const Color(0xFF10B981),
                      const Color(0xFF3B82F6),
                      const Color(0xFFA855F7),
                      const Color(0xFFEF4444),
                      const Color(0xFF14B8A6),
                    ]
                        .map((color) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                                border: Border.all(
                                  color: selectedColor == color
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: selectedColor == color
                                    ? [
                                        BoxShadow(
                                          color: color.withOpacity(0.5),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : [],
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(sbContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  final text = labelController.text.trim();
                  if (text.isEmpty) {
                    ScaffoldMessenger.of(sbContext).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a name'),
                        duration: Duration(milliseconds: 1500),
                      ),
                    );
                    return;
                  }
                  provider.addSegment(
                    SpinnerSegment(
                      label: text,
                      color: selectedColor.withOpacity(0.8),
                    ),
                  );
                  Navigator.pop(sbContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added: $text'),
                      duration: const Duration(milliseconds: 1500),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Entry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEntriesBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenContext = context; // Store the screen context

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: isDark ? AppTheme.cardColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Consumer<SpinnerProvider>(
          builder: (consumerContext, provider, _) {
            return StatefulBuilder(
              builder: (sbContext, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isDark
                                  ? Colors.white12
                                  : Colors.grey.shade200,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Entries (${provider.segments.length})',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDark ? Colors.white : AppTheme.backgroundColor,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _onAddButtonPressed(screenContext, provider);
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Entries List
                      if (provider.segments.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox,
                                size: 48,
                                color: isDark
                                    ? Colors.white38
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No entries yet',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: provider.segments.length,
                          itemBuilder: (context, index) {
                            final segment = provider.segments[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: isDark
                                    ? AppTheme.surfaceColor
                                    : Colors.grey.shade50,
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white10
                                      : Colors.grey.shade200,
                                ),
                              ),
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: segment.color,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            segment.color.withOpacity(0.4),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      segment.label.length > 2
                                          ? segment.label.substring(0, 2)
                                          : segment.label,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  segment.label,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : AppTheme.backgroundColor,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: provider.segments.length <= 2
                                      ? null
                                      : () {
                                          provider.removeSegment(index);
                                          setState(() {});
                                        },
                                  color: provider.segments.length <= 2
                                      ? Colors.grey
                                      : Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }


}

