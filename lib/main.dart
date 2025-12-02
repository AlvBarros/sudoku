import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sudoku/application/logger.dart';
import 'package:sudoku/application/providers.dart';
import 'package:sudoku/presentation/screens/home.screen.dart';
import 'package:sudoku/presentation/screens/loading.screen.dart';
import 'package:sudoku/presentation/screens/grid/grid.screen.dart';
import 'package:sudoku/presentation/screens/stats.screen.dart';
import 'package:sudoku/presentation/themes.dart';

void main() {
  logger.i("App started");
  runApp(ProviderScope(child: Sudokat()));
}

class Sudokat extends ConsumerWidget {
  const Sudokat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      theme: appThemes[themeMode],
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
