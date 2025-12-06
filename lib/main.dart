import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/dice_provider.dart';
import 'providers/coin_provider.dart';
import 'providers/number_dial_provider.dart';
import 'providers/spinner_provider.dart';
import 'providers/chess_timer_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProxyProvider<SettingsProvider, DiceProvider>(
          create: (context) => DiceProvider(
            Provider.of<SettingsProvider>(context, listen: false),
          ),
          update: (context, settings, previous) =>
              previous ?? DiceProvider(settings),
        ),
        ChangeNotifierProvider(create: (_) => CoinProvider()),
        ChangeNotifierProxyProvider<SettingsProvider, NumberDialProvider>(
          create: (context) => NumberDialProvider(
            Provider.of<SettingsProvider>(context, listen: false),
          ),
          update: (context, settings, previous) =>
              previous ?? NumberDialProvider(settings),
        ),
        ChangeNotifierProxyProvider<SettingsProvider, SpinnerProvider>(
          create: (context) => SpinnerProvider(
            Provider.of<SettingsProvider>(context, listen: false),
          ),
          update: (context, settings, previous) =>
              previous ?? SpinnerProvider(settings),
        ),
        ChangeNotifierProvider(create: (_) => ChessTimerProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Pakida - Randomizer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
