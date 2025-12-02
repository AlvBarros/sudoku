import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/domain/game.dart';

import 'package:sudoku/domain/sudoku.dart';

import 'package:sudoku/infra/game.service.dart';
import 'package:sudoku/infra/stats.service.dart';
import 'package:sudoku/infra/storage.service.dart';

// Notifier for managing the Game state
class GameNotifier extends Notifier<Game> {
  late final GameService gameService;

  @override
  Game build() {
    gameService = ref.read(gameServiceProvider);
    return Game.waiting();
  }

  Future<Game> loadGame() async {
    final game = await gameService.getInProgressGame();
    state = game ?? Game.waiting();
    return state;
  }

  Future<void> saveGame(Game game) async {
    await gameService.saveGame(game);
  }

  Future<void> newGame(SudokuDifficulty difficulty) async {
    // Fetch a new random grid
    final grid = await gameService.fetchRandomGrid(difficulty);

    final game = Game(
      grid: grid,
      startedAt: DateTime.now(),
      elapsedTime: Duration.zero,
    );

    await saveGame(game);

    state = game;
  }

  void updateCellAnswer(int row, int col, int value) {
    final cellKey = '${row}_$col';
    if (state.cells.containsKey(cellKey)) {
      state.cells[cellKey]!.value = value;
    } else {
      state.cells[cellKey] = Cell(row: row, column: col, value: value);
    }
  }

  void addCellNote(int row, int col, int note) {
    final cellKey = '${row}_$col';
    if (state.cells.containsKey(cellKey)) {
      final cell = state.cells[cellKey]!;
      if (!cell.notes.contains(note)) {
        cell.notes.add(note);
      }
    } else {
      state.cells[cellKey] = Cell(row: row, column: col, notes: [note]);
    }
  }

  Future<void> resetGame() async {
    final resetGame = Game(
      grid: state.grid,
      startedAt: DateTime.now(),
      elapsedTime: Duration.zero,
    );
    await saveGame(resetGame);
    state = resetGame;
  }

  Future<void> exitGame() async {
    final game = Game.waiting();
    state = game;
  }

  Future<void> finishGame() async {
    await gameService.finishGame(state);
    final game = Game.waiting();
    state = game;
  }
}

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setLightTheme() {
    state = ThemeMode.light;
  }

  void setDarkTheme() {
    state = ThemeMode.dark;
  }
}

// Global provider for the StorageService
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageServiceFactory.create();
});

final statsServiceProvider = Provider<StatsService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return StatsService(storageService: storageService);
});

// Global provider for the current Sudoku game
final gameProvider = NotifierProvider<GameNotifier, Game>(() => GameNotifier());
final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  () => ThemeNotifier(),
);
// Global provider for the GameService
final gameServiceProvider = Provider<GameService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  final statsService = ref.watch(statsServiceProvider);
  return GameService(
    storageService: storageService,
    statsService: statsService,
  );
});
