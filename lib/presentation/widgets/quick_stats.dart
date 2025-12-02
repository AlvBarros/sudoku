import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokats/application/providers.dart';
import 'package:sudokats/domain/stats.dart';
import 'package:sudokats/presentation/widgets/calendar_stats.dart';

class QuickStats extends ConsumerStatefulWidget {
  const QuickStats({super.key});

  @override
  ConsumerState<QuickStats> createState() => _QuickStatsState();
}

class _QuickStatsState extends ConsumerState<QuickStats> {
  String formatDuration(Duration duration) {
    if (duration == Duration.zero) {
      return 'N/A';
    }
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final statsService = ref.read(statsServiceProvider);

    return FutureBuilder(
      future: statsService.getStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final stats = snapshot.data!;

          int perfectGames = 0;
          int totalElapsedTimeMs = 0;
          for (CompletedGame game in stats.completedGames) {
            if (game.isPerfect) {
              perfectGames++;
            }
            totalElapsedTimeMs += game.elapsedTimeMs;
          }
          Duration averageTime = stats.completedGames.isNotEmpty
              ? Duration(
                  milliseconds:
                      totalElapsedTimeMs ~/ stats.completedGames.length,
                )
              : Duration.zero;

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Games played: ${stats.totalGamesPlayed}'),
              Text('Perfect games: $perfectGames'),
              Text('Average time: ${formatDuration(averageTime)}'),
            ],
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
