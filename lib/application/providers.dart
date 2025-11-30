import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/domain/game.dart';

import 'package:sudoku/domain/sudoku.dart';

import 'package:sudoku/infra/game_service.dart';
import 'package:sudoku/infra/storage_service.dart';

// Notifier for managing the Game state
class GameNotifier extends Notifier<Game> {
  late final GameService gameService;

  @override
  Game build() {
    gameService = ref.read(gameServiceProvider);
    return Game.waiting();
  }

  Future<void> loadGame() async {
    final game = await gameService.getInProgressGame();
    state = game ?? Game.waiting();
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
    await gameService.deleteGame();
    final game = Game.waiting();
    state = game; 
  }
}

// Global provider for the current Sudoku game
final gameProvider = NotifierProvider<GameNotifier, Game>(() => GameNotifier());

// Global provider for the GameService
final gameServiceProvider = Provider<GameService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return GameService(storageService: storageService);
});

// Global provider for the StorageService
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageServiceFactory.create();
});
