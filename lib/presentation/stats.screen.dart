import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/application/providers.dart';
import 'package:sudoku/domain/game.dart';
import 'package:sudoku/domain/sudoku.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameNotifier = ref.read(gameProvider.notifier);
    final completedPuzzles = gameNotifier.getCompletedPuzzles();

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: FutureBuilder<List<dynamic>>(
        future: completedPuzzles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final puzzles = snapshot.data ?? <Game>[];
          final totalCompleted = puzzles.length;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle),
                    title: const Text('Total Completed'),
                    trailing: Text(
                      '$totalCompleted',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ...List.generate(4, (index) {
                  final difficulty = SudokuDifficulty.values
                      .map((d) => d.name)
                      .where((d) => d != SudokuDifficulty.unknown.name)
                      .toList()[index];
                  final count = puzzles
                      .where((p) => p.grid.difficulty == difficulty)
                      .length;

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.emoji_events,
                        color: [
                          Colors.green,
                          Colors.orange,
                          Colors.red,
                          Colors.purple,
                        ][index],
                      ),
                      title: Text(
                        difficulty.substring(0, 1).toUpperCase() +
                            difficulty.substring(1).toLowerCase(),
                      ),
                      trailing: Text(
                        '$count',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
