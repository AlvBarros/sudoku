import 'package:sudoku/domain/sudoku.dart';

class Stats {
  final int totalGamesPlayed;
  final int totalGamesWon;
  final int fastestWinTimeMs;
  final int currentWinStreak;
  final int longestWinStreak;
  final List<CompletedGame> completedGames;

  Stats({
    required this.totalGamesPlayed,
    required this.totalGamesWon,
    required this.fastestWinTimeMs,
    required this.currentWinStreak,
    required this.longestWinStreak,
    required this.completedGames,
  });

  String formatFastestWinTime() {
    final seconds = (fastestWinTimeMs / 1000).round();
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }
}

class CompletedGame {
  final String gridId;
  final SudokuDifficulty difficulty;
  final DateTime startedAt;
  final int elapsedTimeMs;
  final DateTime completedAt;
  final bool isPerfect;

  CompletedGame({
    required this.gridId,
    required this.difficulty,
    required this.startedAt,
    required this.elapsedTimeMs,
    required this.completedAt,
    required this.isPerfect,
  });

  Map<String, dynamic> toMap() {
    return {
      'gridId': gridId,
      'difficulty': difficulty.toString(),
      'startedAt': startedAt.toIso8601String(),
      'elapsedTimeMs': elapsedTimeMs,
      'completedAt': completedAt.toIso8601String(),
      'perfect': isPerfect,
    };
  }

  factory CompletedGame.fromMap(Map<String, dynamic> map) {
    return CompletedGame(
      gridId: map['gridId'] as String,
      difficulty: SudokuDifficulty.values.firstWhere(
        (d) => d.toString() == map['difficulty'],
        orElse: () => SudokuDifficulty.unknown,
      ),
      startedAt: DateTime.parse(map['startedAt'] as String),
      elapsedTimeMs: map['elapsedTimeMs'] as int,
      completedAt: DateTime.parse(map['completedAt'] as String),
      isPerfect: map['perfect'] as bool,
    );
  }
}
