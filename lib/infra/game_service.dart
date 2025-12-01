import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sudoku/application/logger.dart';
import 'package:sudoku/domain/game.dart';
import 'package:sudoku/domain/sudoku.dart';
import 'package:sudoku/infra/storage_service.dart';

void _log(String message) => logger.i('[GameService] $message');

class GameStorageKeys {
  static const String currentGridIdKey = 'current_grid_id';
  static const String currentGridDifficultyKey = 'current_grid_difficulty';
  static const String currentGridKey = 'current_grid';
  static const String currentSolutionKey = 'current_game_solution';
  static const String currentGameStartedAtKey = 'current_game_started_at';
  static const String currentGameElapsedTimeKey = 'current_game_elapsed_time';
  static const String currentGameAnswersKey = 'current_game_answers';
  static const String currentGameNotesKey = 'current_game_notes';
  static const String completedGamesKey = 'completed_games';
}

class GameService {
  final StorageService storageService;

  GameService({required this.storageService});

  Future<SudokuGrid> fetchRandomGrid(SudokuDifficulty difficulty) async {
    final randomFile =
        (1 + (9 * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000))
            .toInt();
    final randomPuzzle =
        (1 + (100 * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000))
            .toInt();

    // Construct the URL for the JSON file
    final url = Uri.parse(
      'https://raw.githubusercontent.com/AlvBarros/sudoku/main/data/${difficulty.name.toLowerCase()}_${randomFile}.json',
    );

    try {
      // Make the HTTP GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final puzzles = jsonDecode(response.body) as List<dynamic>;
        if (randomPuzzle - 1 < puzzles.length) {
          final puzzleData = puzzles[randomPuzzle - 1];

          final gridNumbers = (puzzleData['puzzle'] as String).split('').map((
            char,
          ) {
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

          final solutionNumbers = (puzzleData['solution'] as String)
              .split('')
              .map((char) {
                return int.parse(char);
              })
              .toList();

          final solution = <List<int>>[];
          for (var r = 0; r < 9; r++) {
            final row = <int>[];
            for (var c = 0; c < 9; c++) {
              final index = r * 9 + c;
              final cellValue = solutionNumbers[index];
              row.add(cellValue);
            }
            solution.add(row);
          }

          return SudokuGrid(
            puzzleData['id'].toString(),
            difficulty,
            grid,
            solution,
          );
        } else {
          throw Exception('Puzzle index out of range');
        }
      } else {
        throw Exception('Failed to fetch puzzle file: ${response.statusCode}');
      }
    } catch (e) {
      _log('Error fetching puzzle: $e');
      rethrow;
    }
  }

  Future<void> deleteGame() async {
    await storageService.delete(GameStorageKeys.currentGridIdKey);
    await storageService.delete(GameStorageKeys.currentGridDifficultyKey);
    await storageService.delete(GameStorageKeys.currentGridKey);
    await storageService.delete(GameStorageKeys.currentSolutionKey);
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

    final solutionStr = grid.solution.expand((row) => row).join();
    await storageService.save(GameStorageKeys.currentSolutionKey, solutionStr);

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
    final storedSolution = await storageService.load(
      GameStorageKeys.currentSolutionKey,
    );
    if (id == null ||
        storedDifficuly == null ||
        storedGrid == null ||
        storedSolution == null) {
      return null;
    }

    final difficulty = SudokuDifficulty.values.firstWhere(
      (d) => d.toString() == storedDifficuly,
    );

    // Deserialize the grid from storage
    return SudokuGrid(
      id,
      difficulty,
      _deserializeGrid(storedGrid),
      _deserializeGrid(storedSolution),
    );
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

  Future<void> finishGame(Game game) async {
    final completedGamesStr =
        await storageService.load(GameStorageKeys.completedGamesKey) ?? '[]';
    final completedGames = completedGamesStr.isNotEmpty
        ? jsonDecode(completedGamesStr) as List<dynamic>
        : <dynamic>[];
    final now = DateTime.now().toIso8601String();
    final completedGame = {
      'gridId': game.grid.id,
      'difficulty': game.grid.difficulty.toString(),
      'startedAt': game.startedAt.toIso8601String(),
      'elapsedTime': game.elapsedTime.inMilliseconds,
      'completedAt': now,
    };
    completedGames.add(completedGame);
    await storageService.save(
      GameStorageKeys.completedGamesKey,
      jsonEncode(completedGames),
    );
    _log('Game for grid ${game.grid.id} marked as completed');
  }

  Future<List<Game>> getCompletedGames() async {
    final completedGamesStr =
        await storageService.load(GameStorageKeys.completedGamesKey) ?? '[]';
    final completedGames = completedGamesStr.isNotEmpty
        ? jsonDecode(completedGamesStr) as List<dynamic>
        : <dynamic>[];

    final games = <Game>[];
    for (var gameData in completedGames) {
      final gridId = gameData['gridId'] as String;
      final difficultyStr = gameData['difficulty'] as String;
      final startedAtStr = gameData['startedAt'] as String;
      final elapsedTimeMs = gameData['elapsedTime'] as int;

      final game = Game(
        grid: SudokuGrid(
          gridId,
          SudokuDifficulty.values.firstWhere(
            (d) => d.toString() == difficultyStr,
            orElse: () => SudokuDifficulty.unknown,
          ),
          List.generate(9, (_) => List.filled(9, 0)),
          List.generate(9, (_) => List.filled(9, 0)),
        ),
        startedAt: DateTime.parse(startedAtStr),
        elapsedTime: Duration(milliseconds: elapsedTimeMs),
      );
      games.add(game);
    }

    return games;
  }
}
