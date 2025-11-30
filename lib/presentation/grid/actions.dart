import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/application/logger.dart';

import 'package:sudoku/application/providers.dart';
import 'package:sudoku/domain/sudoku.dart';

void _log(String message) => logger.i('[GridActions] $message');

class GridActions extends ConsumerWidget {
  const GridActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameNotifier = ref.read(gameProvider.notifier);
    final game = ref.watch(gameProvider);
    final hasGridsInProgress = !game.grid.isEmpty;

    if (!hasGridsInProgress) {
      return IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          _log("Starting a new game");
          gameNotifier.newGame(SudokuDifficulty.easy);
        },
      );
    } else {
      return PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'reset':
              _log("Resetting the current grid");
              gameNotifier.resetGame();
              break;
            case 'delete':
              _log("Deleting the current grid");
              gameNotifier.exitGame();
              break;
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(value: 'reset', child: Text('Reset')),
          PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      );
    }
  }
}
