import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokats/application/providers.dart';
import 'package:sudokats/domain/sudoku.dart';
import 'package:sudokats/l10n/app_localizations.dart';
import 'package:sudokats/main.dart';
import 'package:sudokats/presentation/themes.dart';

class StartGame extends ConsumerStatefulWidget {
  const StartGame({super.key});

  @override
  ConsumerState<StartGame> createState() => _StartGameState();
}

class _StartGameState extends ConsumerState<StartGame> {
  SudokuDifficulty _selectedDifficulty = SudokuDifficulty.easy;
  List<SudokuDifficulty> difficulties = SudokuDifficulty.values
      .where((difficulty) => difficulty != SudokuDifficulty.unknown)
      .toList();

  @override
  Widget build(BuildContext context) {
    final gameService = ref.watch(gameServiceProvider);

    return FutureBuilder(
      future: gameService.getInProgressGame(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data != null) {
          return _continueGame(context, ref, true);
        }
        return _continueGame(context, ref, false);
      },
    );
  }

  Widget _continueGame(BuildContext context, WidgetRef ref, bool hasGame) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final gameNotifier = ref.read(gameProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasGame) ...[
            Text(
              localizations.homeGameInProgress,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.homeContinueGamePrompt,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                gameNotifier.loadGame().then((_) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacementNamed(Routes.game);
                  });
                });
              },
              child: Text(localizations.homeButtonContinueGameButton),
            ),
          ],
          FilledButton(
            onPressed: () {
              if (hasGame) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        localizations.homeStartNewGameButton,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      content: Text(localizations.homeStartNewGamePrompt),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(localizations.cancel),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showDifficultyDialog(context, gameNotifier);
                          },
                          child: Text(localizations.homeStartNewGameButton),
                        ),
                      ],
                    );
                  },
                );
                return;
              }
              _showDifficultyDialog(context, gameNotifier);
            },
            child: Text(localizations.homeStartNewGameButton),
          ),
        ],
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context, dynamic gameNotifier) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations.homeSelectDifficulty,
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/difficulty_${_selectedDifficulty.name}.png',
                    height: 150,
                  ),
                  ...difficulties.map(
                    (difficulty) => ListTile(
                      selectedColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      selectedTileColor: Colors.transparent,
                      leading: Icon(
                        _selectedDifficulty == difficulty
                            ? Icons.emoji_events
                            : Icons.emoji_events_outlined,
                        color: difficultiesColors[difficulty],
                      ),
                      title: Text(
                        difficulty.name[0].toUpperCase() +
                            difficulty.name.substring(1),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      onTap: () {
                        setDialogState(() {
                          _selectedDifficulty = difficulty;
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () {
                gameNotifier.newGame(_selectedDifficulty).then((value) {
                  if (mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushReplacementNamed(Routes.game);
                    });
                  }
                });
              },
              child: Text(localizations.homeStartNewGameButton),
            ),
          ],
        );
      },
    );
  }
}
