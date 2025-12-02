import 'dart:convert';

import 'package:sudokats/domain/stats.dart';
import 'package:sudokats/infra/storage/interface.dart';

class StatsStorageKey {
  static const String totalGamesPlayedKey = 'stats_total_games_played';
  static const String totalGamesWonKey = 'stats_total_games_won';
  static const String fastestWinTimeKey = 'stats_fastest_win_time';
  static const String currentWinStreakKey = 'stats_current_win_streak';
  static const String longestWinStreakKey = 'stats_longest_win_streak';
  static const String completedGamesKey = 'stats_completed_games';
}

class StatsService {
  final StorageService storageService;

  StatsService({required this.storageService});

  Future<Stats> getStats() async {
    final totalGamesPlayed =
        await storageService.load(StatsStorageKey.totalGamesPlayedKey) ?? '0';
    final totalGamesWon =
        await storageService.load(StatsStorageKey.totalGamesWonKey) ?? '0';
    final fastestWinTimeMs =
        await storageService.load(StatsStorageKey.fastestWinTimeKey) ?? '0';
    final currentWinStreak =
        await storageService.load(StatsStorageKey.currentWinStreakKey) ?? '0';
    final longestWinStreak =
        await storageService.load(StatsStorageKey.longestWinStreakKey) ?? '0';
    final completedGamesStr =
        await storageService.load(StatsStorageKey.completedGamesKey) ?? '[]';

    final completedGames = completedGamesStr.isNotEmpty
        ? (jsonDecode(completedGamesStr) as List<dynamic>)
              .map((e) => CompletedGame.fromMap(e as Map<String, dynamic>))
              .toList()
        : <CompletedGame>[];

    return Stats(
      totalGamesPlayed: int.parse(totalGamesPlayed),
      totalGamesWon: int.parse(totalGamesWon),
      fastestWinTimeMs: int.parse(fastestWinTimeMs),
      currentWinStreak: int.parse(currentWinStreak),
      longestWinStreak: int.parse(longestWinStreak),
      completedGames: completedGames,
    );
  }

  Future<Stats> saveStats(Stats stats) {
    return Future.wait([
      storageService.save(
        StatsStorageKey.totalGamesPlayedKey,
        stats.totalGamesPlayed.toString(),
      ),
      storageService.save(
        StatsStorageKey.totalGamesWonKey,
        stats.totalGamesWon.toString(),
      ),
      storageService.save(
        StatsStorageKey.fastestWinTimeKey,
        stats.fastestWinTimeMs.toString(),
      ),
      storageService.save(
        StatsStorageKey.currentWinStreakKey,
        stats.currentWinStreak.toString(),
      ),
      storageService.save(
        StatsStorageKey.longestWinStreakKey,
        stats.longestWinStreak.toString(),
      ),
    ]).then((_) => stats);
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  Future<void> addCompletedGame(CompletedGame completedGame) async {
    final stats = await getStats();
    final totalGamesPlayed = stats.totalGamesPlayed + 1;
    final totalGamesWon = stats.totalGamesWon + 1;
    final currentWinStreak = stats.currentWinStreak + 1;
    var longestWinStreak = stats.longestWinStreak;
    if (currentWinStreak > longestWinStreak) {
      longestWinStreak = currentWinStreak;
    }
    var fastestWinTimeMs = stats.fastestWinTimeMs;
    if (fastestWinTimeMs == 0 ||
        completedGame.elapsedTimeMs < fastestWinTimeMs) {
      fastestWinTimeMs = completedGame.elapsedTimeMs;
    }
    stats.completedGames.add(completedGame);
    await saveStats(
      Stats(
        totalGamesPlayed: totalGamesPlayed,
        totalGamesWon: totalGamesWon,
        fastestWinTimeMs: fastestWinTimeMs,
        currentWinStreak: currentWinStreak,
        longestWinStreak: longestWinStreak,
        completedGames: stats.completedGames,
      ),
    );
  }

  Future<List<CompletedGame>> getCompletedGames() async {
    final completedGamesStr =
        await storageService.load(StatsStorageKey.completedGamesKey) ?? '[]';
    final completedGames = completedGamesStr.isNotEmpty
        ? (jsonDecode(completedGamesStr) as List<dynamic>)
              .map((e) => CompletedGame.fromMap(e as Map<String, dynamic>))
              .toList()
        : <CompletedGame>[];
    return completedGames;
  }
}
