import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sudoku/application/logger.dart';
import 'package:sudoku/presentation/continuegame.screen.dart';
import 'package:sudoku/presentation/loading.screen.dart';
import 'package:sudoku/presentation/newgame.screen.dart';
import 'package:sudoku/presentation/grid/grid.screen.dart';
import 'package:sudoku/presentation/stats.screen.dart';

void main() {
  logger.i("App started");
  runApp(
    ProviderScope(
      child: MaterialApp(
        routes: {
          '/loading': (context) => const LoadingScreen(),
          '/newgame': (context) => const NewGameScreen(),
          '/continuegame': (context) => const ContinueGameScreen(),
          '/stats': (context) => const StatsScreen(),
          '/grid': (context) => const GridScreen(),
        },
        initialRoute: '/loading',
      ),
    ),
  );
}
