import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokats/application/logger.dart';
import 'package:sudokats/presentation/screens/home.screen.dart';
import 'package:sudokats/presentation/screens/loading.screen.dart';
import 'package:sudokats/presentation/screens/game/grid.screen.dart';
import 'package:sudokats/presentation/screens/stats.screen.dart';
import 'package:sudokats/presentation/themes.dart';

import 'l10n/app_localizations.dart';

void main() {
  logger.i("App started");
  runApp(ProviderScope(child: Sudokat()));
}

class Sudokat extends ConsumerWidget {
  const Sudokat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightnessMode = MediaQuery.of(context).platformBrightness;

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: appThemes[brightnessMode],
      routes: {
        '/loading': (context) => const LoadingScreen(),
        '/home': (context) => const HomeScreen(),
        '/stats': (context) => const StatsScreen(),
        '/grid': (context) => const GridScreen(),
      },
      initialRoute: '/loading',
    );
  }
}
