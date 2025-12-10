import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokats/application/logger.dart';
import 'package:sudokats/presentation/screens/home.screen.dart';
import 'package:sudokats/presentation/screens/loading.screen.dart';
import 'package:sudokats/presentation/screens/game/game.screen.dart';
import 'package:sudokats/presentation/screens/stats.screen.dart';
import 'package:sudokats/presentation/themes.dart';

import 'l10n/app_localizations.dart';

class Routes {
  static final loading = '/loading';
  static final home = '/home';
  static final stats = '/stats';
  static final game = '/game';
}

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
  Routes.loading: (context) => const LoadingScreen(),
  Routes.home: (context) => const HomeScreen(),
  Routes.stats: (context) => const StatsScreen(),
  Routes.game: (context) => const GameScreen(),
};

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
      routes: routes,
      initialRoute: Routes.loading,
    );
  }
}
