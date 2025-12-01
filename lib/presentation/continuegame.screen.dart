import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/application/providers.dart';
import 'package:sudoku/domain/sudoku.dart';
import 'package:sudoku/presentation/widgets/stats_button.dart';

class ContinueGameScreen extends ConsumerStatefulWidget {
  const ContinueGameScreen({super.key});

  @override
  ConsumerState<ContinueGameScreen> createState() => _ContinueGameScreenState();
}

class _ContinueGameScreenState extends ConsumerState<ContinueGameScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final gameNotifier = ref.read(gameProvider.notifier);
    final game = ref.watch(gameProvider);
    final difficulty = game.grid.difficulty != SudokuDifficulty.unknown
        ? game.grid.difficulty
                  .toString()
                  .split('.')
                  .last
                  .substring(0, 1)
                  .toUpperCase() +
              game.grid.difficulty.toString().split('.').last.substring(1)
        : '';

    return Scaffold(
      appBar: AppBar(title: Container(), actions: [StatsButton()]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading ? Center(child: CircularProgressIndicator()) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Game in Progress',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Would you like to continue your previous game or start a new one?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                gameNotifier.loadGame().then((_) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacementNamed('/grid');
                  });
                });
              },
              child: Text('Continue $difficulty Game'),
            ),
            ElevatedButton(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed('/newgame');
                });
              },
              child: Text('Start New Game'),
            ),
          ],
        ),
      ),
    );
  }
}
