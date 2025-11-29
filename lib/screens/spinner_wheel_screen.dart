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
                            GestureDetector(
                              onTap: spinnerProvider.isSpinning
                                  ? null
                                  : () => spinnerProvider.spin(),
                              child: SpinnerWheel(
                                segments: spinnerProvider.segments,
                                isSpinning: spinnerProvider.isSpinning,
                                selectedSegment: spinnerProvider.selectedSegment,
                              ),
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
    Color selectedColor = const Color(0xFF6366F1);
    bool showAllColors = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => StatefulBuilder(
        builder: (sbContext, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardColor : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppTheme.accentGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Add New Entry',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppTheme.backgroundColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(sbContext),
                          icon: Icon(
                            Icons.close,
                            color: isDark ? Colors.white70 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Entry Name Input
                    Text(
                      'Entry Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppTheme.backgroundColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: labelController,
                      maxLength: 15,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark
                            ? AppTheme.surfaceColor
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? Colors.white10 : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        hintText: 'e.g., Pizza, John, Cinema',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white30 : Colors.grey.shade400,
                        ),
                        prefixIcon: Icon(
                          Icons.label_outline,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                        counterStyle: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : AppTheme.backgroundColor,
                        fontSize: 16,
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 24),
                    
                    // Color Selection
                    Text(
                      'Choose Color',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppTheme.backgroundColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showAllColors = !showAllColors;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: showAllColors
                            ? Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  const Color(0xFF6366F1),
                                  const Color(0xFFEC4899),
                                  const Color(0xFFF59E0B),
                                  const Color(0xFF10B981),
                                  const Color(0xFF3B82F6),
                                  const Color(0xFFA855F7),
                                  const Color(0xFFEF4444),
                                  const Color(0xFF14B8A6),
                                  const Color(0xFFF97316),
                                  const Color(0xFF8B5CF6),
                                  const Color(0xFF06B6D4),
                                  const Color(0xFFFBBF24),
                                ]
                                    .map((color) {
                                      final isSelected = selectedColor == color;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedColor = color;
                                            showAllColors = false;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          width: isSelected ? 56 : 48,
                                          height: isSelected ? 56 : 48,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color,
                                            border: Border.all(
                                              color: isSelected
                                                  ? (isDark ? Colors.white : AppTheme.backgroundColor)
                                                  : Colors.transparent,
                                              width: 3,
                                            ),
                                            boxShadow: [
                                              if (isSelected)
                                                BoxShadow(
                                                  color: color.withOpacity(0.5),
                                                  blurRadius: 12,
                                                  spreadRadius: 2,
                                                ),
                                            ],
                                          ),
                                          child: isSelected
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 24,
                                                )
                                              : null,
                                        ),
                                      );
                                    })
                                    .toList(),
                              )
                            : Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppTheme.surfaceColor
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark ? Colors.white10 : Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: selectedColor.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Tap to choose color',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.palette,
                                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(sbContext),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: isDark ? Colors.white24 : Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white70 : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final text = labelController.text.trim();
                              if (text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(Icons.error_outline, color: Colors.white),
                                        SizedBox(width: 12),
                                        Text('Please enter a name'),
                                      ],
                                    ),
                                    backgroundColor: Colors.red.shade600,
                                    duration: const Duration(milliseconds: 2000),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                                return;
                              }
                              provider.addSegment(
                                SpinnerSegment(
                                  label: text,
                                  color: selectedColor,
                                ),
                              );
                              Navigator.pop(sbContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.white),
                                      const SizedBox(width: 12),
                                      Expanded(child: Text('Added: $text')),
                                    ],
                                  ),
                                  backgroundColor: Colors.green.shade600,
                                  duration: const Duration(milliseconds: 2000),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_circle, size: 20),
                            label: const Text(
                              'Add Entry',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onEditButtonPressed(BuildContext context, SpinnerProvider provider, int index, SpinnerSegment segment) {
    Navigator.pop(context); // Close the bottom sheet if open
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final TextEditingController labelController = TextEditingController(text: segment.label);
    Color selectedColor = segment.color;
    bool showAllColors = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => StatefulBuilder(
        builder: (sbContext, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardColor : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppTheme.accentGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Edit Entry',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppTheme.backgroundColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(sbContext),
                          icon: Icon(
                            Icons.close,
                            color: isDark ? Colors.white70 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Entry Name Input
                    Text(
                      'Entry Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppTheme.backgroundColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: labelController,
                      maxLength: 15,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark
                            ? AppTheme.surfaceColor
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? Colors.white10 : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        hintText: 'e.g., Pizza, John, Cinema',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white30 : Colors.grey.shade400,
                        ),
                        prefixIcon: Icon(
                          Icons.label_outline,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                        counterStyle: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : AppTheme.backgroundColor,
                        fontSize: 16,
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 24),
                    
                    // Color Selection (same as add dialog)
                    Text(
                      'Choose Color',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppTheme.backgroundColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showAllColors = !showAllColors;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: showAllColors
                            ? Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  const Color(0xFF6366F1),
                                  const Color(0xFFEC4899),
                                  const Color(0xFFF59E0B),
                                  const Color(0xFF10B981),
                                  const Color(0xFF3B82F6),
                                  const Color(0xFFA855F7),
                                  const Color(0xFFEF4444),
                                  const Color(0xFF14B8A6),
                                  const Color(0xFFF97316),
                                  const Color(0xFF8B5CF6),
                                  const Color(0xFF06B6D4),
                                  const Color(0xFFFBBF24),
                                ]
                                    .map((color) {
                                      final isSelected = selectedColor == color;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedColor = color;
                                            showAllColors = false;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          width: isSelected ? 56 : 48,
                                          height: isSelected ? 56 : 48,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color,
                                            border: Border.all(
                                              color: isSelected
                                                  ? (isDark ? Colors.white : AppTheme.backgroundColor)
                                                  : Colors.transparent,
                                              width: 3,
                                            ),
                                            boxShadow: [
                                              if (isSelected)
                                                BoxShadow(
                                                  color: color.withOpacity(0.5),
                                                  blurRadius: 12,
                                                  spreadRadius: 2,
                                                ),
                                            ],
                                          ),
                                          child: isSelected
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 24,
                                                )
                                              : null,
                                        ),
                                      );
                                    })
                                    .toList(),
                              )
                            : Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppTheme.surfaceColor
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark ? Colors.white10 : Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: selectedColor.withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Tap to choose color',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.palette,
                                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(sbContext),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: isDark ? Colors.white24 : Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white70 : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final text = labelController.text.trim();
                              if (text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      children: [
                                        Icon(Icons.error_outline, color: Colors.white),
                                        SizedBox(width: 12),
                                        Text('Please enter a name'),
                                      ],
                                    ),
                                    backgroundColor: Colors.red.shade600,
                                    duration: const Duration(milliseconds: 2000),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                                return;
                              }
                              // Update the segment
                              provider.updateSegment(
                                index,
                                SpinnerSegment(
                                  label: text,
                                  color: selectedColor,
                                ),
                              );
                              Navigator.pop(sbContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.white),
                                      const SizedBox(width: 12),
                                      Expanded(child: Text('Updated: $text')),
                                    ],
                                  ),
                                  backgroundColor: Colors.green.shade600,
                                  duration: const Duration(milliseconds: 2000),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_circle, size: 20),
                            label: const Text(
                              'Update Entry',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
                return Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(sbContext).size.height * 0.8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header (Fixed at top)
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          MediaQuery.of(sbContext).padding.top + 12,
                          16,
                          16,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.cardColor : Colors.white,
                          border: Border(
                            bottom: BorderSide(
                              color: isDark
                                  ? Colors.white12
                                  : Colors.grey.shade200,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Entries (${provider.segments.length})',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDark ? Colors.white : AppTheme.backgroundColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                _onAddButtonPressed(screenContext, provider);
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Add'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Entries List (Scrollable)
                      Flexible(
                        child: provider.segments.isEmpty
                            ? Padding(
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
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit_outlined),
                                            onPressed: () {
                                              _onEditButtonPressed(screenContext, provider, index, segment);
                                            },
                                            color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                                          ),
                                          IconButton(
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
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
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

