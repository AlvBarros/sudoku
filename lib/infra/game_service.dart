import 'package:sudoku/application/logger.dart';
import 'package:sudoku/domain/game.dart';
import 'package:sudoku/domain/sudoku.dart';
import 'package:sudoku/infra/storage_service.dart';

void _log(String message) => logger.i('[GameService] $message');

class GameStorageKeys {
  static const String currentGridIdKey = 'current_grid_id';
  static const String currentGridDifficultyKey = 'current_grid_difficulty';
  static const String currentGridKey = 'current_grid';
  static const String currentGameStartedAtKey = 'current_game_started_at';
  static const String currentGameElapsedTimeKey = 'current_game_elapsed_time';
  static const String currentGameAnswersKey = 'current_game_answers';
  static const String currentGameNotesKey = 'current_game_notes';
}

class GameService {
  final StorageService storageService;

  GameService({required this.storageService});

  Future<SudokuGrid> fetchRandomGrid(SudokuDifficulty difficulty) async {
    _log('MOCKED - For now, returning a fixed grid');
    final mockedGrid =
        '1..5.37..6.3..8.9......98...1.......8761..........6...........7.8.9.76.47...6.312';
    final gridNumbers = mockedGrid.split('').map((char) {
      if (char == '.') return 0;
      return int.parse(char);
    }).toList();
    final grid = <List<int>>[];
    for (var r = 0; r < 9; r++) {
      final row = <int>[];
      for (var c = 0; c < 9; c++) {
        final index = r * 9 + c;
        final cellValue = gridNumbers[index];
        row.add(cellValue);
      }
      grid.add(row);
    }
    return SudokuGrid('mocked_id', difficulty, grid);
  }

  Future<void> deleteGame() async {
    await storageService.delete(GameStorageKeys.currentGridIdKey);
    await storageService.delete(GameStorageKeys.currentGridDifficultyKey);
    await storageService.delete(GameStorageKeys.currentGridKey);
    await storageService.delete(GameStorageKeys.currentGameStartedAtKey);
    await storageService.delete(GameStorageKeys.currentGameElapsedTimeKey);
    await storageService.delete(GameStorageKeys.currentGameAnswersKey);
    await storageService.delete(GameStorageKeys.currentGameNotesKey);

    _log('Game deleted from storage');
  }

  Future<void> saveGame(Game game) async {
    final grid = game.grid;

    // Save grid info
    await storageService.save(GameStorageKeys.currentGridIdKey, grid.id ?? '');
    await storageService.save(
      GameStorageKeys.currentGridDifficultyKey,
      grid.difficulty.toString(),
    );
    final gridStr = grid.grid.expand((row) => row).join();
    await storageService.save(GameStorageKeys.currentGridKey, gridStr);

    // Save game info
    await storageService.save(
      GameStorageKeys.currentGameStartedAtKey,
      game.startedAt.toIso8601String(),
    );
    await storageService.save(
      GameStorageKeys.currentGameElapsedTimeKey,
      game.elapsedTime.inMilliseconds.toString(),
    );
    await storageService.save(
      GameStorageKeys.currentGameAnswersKey,
      game.getAnswers(),
    );
    await storageService.save(
      GameStorageKeys.currentGameNotesKey,
      game.getNotes(),
    );

    _log('Game saved for grid ${grid.id}');
  }

  Future<void> updateElapsedTime() async {
    final elapsedTimeStr = await storageService.load(
      GameStorageKeys.currentGameElapsedTimeKey,
    );
    if (elapsedTimeStr == null) {
      _log('No elapsed time found to update');
      return;
    }
    final elapsedTime =
        Duration(milliseconds: int.parse(elapsedTimeStr)) +
        Duration(seconds: 1);
    await storageService.save(
      GameStorageKeys.currentGameElapsedTimeKey,
      elapsedTime.inMilliseconds.toString(),
    );
  }

  /// Get the game in progress from storage.
  /// Returns null if no game is in progress.
  Future<Game?> getInProgressGame() async {
    final grid = await getGridFromStorage();
    if (grid == null) {
      _log('No grid found in storage');
      return null;
    }

    final startedAtStr = await storageService.load(
      GameStorageKeys.currentGameStartedAtKey,
    );
    final elapsedTimeStr = await storageService.load(
      GameStorageKeys.currentGameElapsedTimeKey,
    );
    final answers = await storageService.load(
      GameStorageKeys.currentGameAnswersKey,
    );
    final notes = await storageService.load(
      GameStorageKeys.currentGameNotesKey,
    );
    if (startedAtStr == null || elapsedTimeStr == null) {
      return null;
    }

    _log('Resuming game ${grid.id}');
    return Game(
      grid: grid,
      startedAt: DateTime.parse(startedAtStr),
      elapsedTime: Duration(milliseconds: int.parse(elapsedTimeStr)),
      answers: answers ?? '',
      notes: notes ?? '',
    );
  }

  Future<SudokuGrid?> getGridFromStorage() async {
    final id = await storageService.load(GameStorageKeys.currentGridIdKey);
    final storedDifficuly = await storageService.load(
      GameStorageKeys.currentGridDifficultyKey,
    );
    final storedGrid = await storageService.load(
      GameStorageKeys.currentGridKey,
    );
    if (id == null || storedDifficuly == null || storedGrid == null) {
      return null;
    }

    final difficulty = SudokuDifficulty.values.firstWhere(
      (d) => d.toString() == storedDifficuly,
    );

    // Deserialize the grid from storage
    return SudokuGrid(id, difficulty, _deserializeGrid(storedGrid));
  }

  List<List<int>> _deserializeGrid(String gridStr) {
    final numbers = gridStr.split('').map(int.parse).toList();
    final grid = <List<int>>[];
    for (var r = 0; r < 9; r++) {
      final row = <int>[];
      for (var c = 0; c < 9; c++) {
        final index = r * 9 + c;
        final cellValue = numbers[index];
        row.add(cellValue);
      }
      grid.add(row);
    }
    return grid;
  }
}
