import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('Appearance', isDark),
            _SettingsTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'Give the app a sleek dark appearance',
              value: settings.darkMode,
              onChanged: settings.toggleDarkMode,
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Interactions', isDark),
            _SettingsTile(
              icon: Icons.volume_up_outlined,
              title: 'Enable Sound Effects',
              subtitle: 'Play gentle chimes when rolling or spinning',
              value: settings.soundEnabled,
              onChanged: settings.toggleSound,
            ),
            _SettingsTile(
              icon: Icons.vibration,
              title: 'Enable Vibration',
              subtitle: 'Haptic feedback on dice rolls and flips',
              value: settings.vibrationEnabled,
              onChanged: settings.toggleVibration,
            ),
            const SizedBox(height: 40),
            _buildSectionTitle('About', isDark),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: AppTheme.primaryColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pakida - Randomizer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppTheme.backgroundColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Version 1.0.0+3',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? Colors.white54
                                    : AppTheme.backgroundColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'About the App',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppTheme.backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pakida is a comprehensive randomizer toolkit designed to make decisions fun and fair. Whether you need to roll dice for games, flip a coin, spin a wheel, generate random numbers, or time chess matches, Pakida has you covered with beautiful animations and intuitive controls.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark
                          ? Colors.white70
                          : AppTheme.backgroundColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppTheme.backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    '🎲 Dice Roller - Roll multiple dice with various types',
                    isDark,
                  ),
                  _buildFeatureItem(
                    '⏱️ Chess Timer - Competitive two-player timer',
                    isDark,
                  ),
                  _buildFeatureItem(
                    '🪙 Coin Flip - Classic heads or tails decision maker',
                    isDark,
                  ),
                  _buildFeatureItem(
                    '🎡 Spinner Wheel - Customizable option selector',
                    isDark,
                  ),
                  _buildFeatureItem(
                    '🔢 Random Number - Generate numbers in any range',
                    isDark,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Development Team',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppTheme.backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Developed with ❤️ using Flutter\n\nMade to bring simplicity and joy to random decision-making. We hope Pakida makes your choices easier and more enjoyable!',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark
                          ? Colors.white70
                          : AppTheme.backgroundColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppTheme.backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 18,
                        color: isDark
                            ? Colors.white70
                            : AppTheme.backgroundColor.withOpacity(0.7),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'contact.aktechsource@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: isDark
                                ? Colors.white70
                                : AppTheme.backgroundColor.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : AppTheme.backgroundColor,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? Colors.white70
                  : AppTheme.backgroundColor.withOpacity(0.7),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark
                    ? Colors.white70
                    : AppTheme.backgroundColor.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppTheme.backgroundColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? Colors.white60
                        : AppTheme.backgroundColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }
}
