import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/number_dial_provider.dart';
import '../theme/app_theme.dart';

class NumberDialScreen extends StatefulWidget {
  const NumberDialScreen({super.key});

  @override
  State<NumberDialScreen> createState() => _NumberDialScreenState();
}

class _NumberDialScreenState extends State<NumberDialScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _minController;
  late TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<NumberDialProvider>(context, listen: false);
    _minController = TextEditingController(
      text: provider.numberDial.min.toString(),
    );
    _maxController = TextEditingController(
      text: provider.numberDial.max.toString(),
    );
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final numberDialProvider = Provider.of<NumberDialProvider>(context);
    final numberDial = numberDialProvider.numberDial;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Number'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
              // Range Configuration
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.cardColor : AppTheme.lightCard,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Range',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.backgroundColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Minimum',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? AppTheme.surfaceColor
                                  : Colors.white,
                            ),
                            onChanged: (value) {
                              final min = int.tryParse(value);
                              final max = int.tryParse(_maxController.text);
                              if (min != null && max != null && min < max) {
                                numberDialProvider.setRange(min, max);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _maxController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Maximum',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? AppTheme.surfaceColor
                                  : Colors.white,
                            ),
                            onChanged: (value) {
                              final min = int.tryParse(_minController.text);
                              final max = int.tryParse(value);
                              if (min != null && max != null && min < max) {
                                numberDialProvider.setRange(min, max);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.1, end: 0, duration: 400.ms),

              // Number Dial Display
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Circular Dial
                      GestureDetector(
                        onTap: numberDialProvider.isSpinning
                            ? null
                            : () => numberDialProvider.spin(),
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF10B981),
                                const Color(0xFF059669),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF10B981).withOpacity(0.4),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer ring
                            Container(
                              width: 260,
                              height: 260,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 3,
                                ),
                              ),
                            ),
                            // Inner circle with number
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: numberDialProvider.isSpinning
                                    ? const SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Color(0xFF10B981),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        '${numberDial.currentValue}',
                                        style: const TextStyle(
                                          fontSize: 64,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF10B981),
                                        ),
                                      )
                                        .animate()
                                        .scale(
                                          duration: 400.ms,
                                          begin: const Offset(0.5, 0.5),
                                          end: const Offset(1, 1),
                                          curve: Curves.elasticOut,
                                        )
                                        .fadeIn(duration: 400.ms),
                              ),
                            )
                                .animate(target: numberDialProvider.isSpinning ? 1 : 0)
                                .rotate(
                                  duration: 2000.ms,
                                  begin: 0,
                                  end: 2,
                                  curve: Curves.easeInOut,
                                )
                                .scale(
                                  duration: 2000.ms,
                                  begin: const Offset(1, 1),
                                  end: const Offset(1.1, 1.1),
                                  curve: Curves.easeInOut,
                                ),
                          ],
                        ),
                        )
                            .animate(target: numberDialProvider.isSpinning ? 1 : 0)
                            .shake(duration: 300.ms, hz: 4, curve: Curves.easeInOut),
                      ),
                    ],
                  ),
                ),
              ),

              // Spin Button
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
                    onPressed: numberDialProvider.isSpinning
                        ? null
                        : () {
                            numberDialProvider.spin();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: numberDialProvider.isSpinning
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Spin',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}


