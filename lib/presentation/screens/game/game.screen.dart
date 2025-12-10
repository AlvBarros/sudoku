import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sudokats/application/logger.dart';
import 'package:sudokats/application/providers.dart';
import 'package:sudokats/application/utils.dart';
import 'package:sudokats/domain/game.dart';
import 'package:sudokats/domain/sudoku.dart';
import 'package:sudokats/l10n/app_localizations.dart';
import 'package:sudokats/main.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

import 'widgets.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  TapState tapState = TapState.pen;
  int? selectedNumber;
  Cell? selectedCell;

  @override
  void initState() {
    super.initState();
  }

  void handleConfirm(
    BuildContext context,
    GameNotifier gameNotifier,
    Game game,
  ) {
    final localizations = AppLocalizations.of(context)!;
    final wrongCells = game.checkAndResetIncorrectCells();
    game.isPerfect = false;
    gameNotifier.saveGame(game);
    setState(() {
      selectedCell = null;
      selectedNumber = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.gameIncorrectCellsAmount(wrongCells)),
      ),
    );
  }

  void handleReset(GameNotifier gameNotifier) {
    gameNotifier.resetGame();
    setState(() {
      selectedCell = null;
      selectedNumber = null;
    });
  }

  void handleExit(GameNotifier gameNotifier) {
    gameNotifier.exitGame();
    setState(() {
      selectedCell = null;
      selectedNumber = null;
    });
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    }
  }

  void handleCellTap(BuildContext context, Cell cell, Game game) {
    logger.i('Cell tapped: Row ${cell.row}, Column ${cell.column}');
    if (selectedCell == null && selectedNumber != null) {
      logger.i('Number hightlighted: $selectedNumber');
      final intValue = selectedNumber!;
      if (intValue >= 1 && intValue <= 9) {
        game.handleCellInput(cell, tapState, intValue);
        setState(() {});
      }
      checkGameCompleted(context);
      return;
    }
    if (selectedCell != null &&
        selectedCell!.row == cell.row &&
        selectedCell!.column == cell.column) {
      setState(() {
        selectedNumber = null;
        selectedCell = null;
      });
      checkGameCompleted(context);
      return;
    }
    setState(() {
      selectedNumber = null;
      selectedCell = cell;
    });
    checkGameCompleted(context);
    return;
  }

  void handleErase(Game game) {
    logger.i('Erase action triggered');
    if (selectedCell != null) {
      final updatedCell = game.handleCellErase(selectedCell!);
      setState(() {
        selectedCell = updatedCell;
      });
    }
  }

  void handleUndo(Game game, GameNotifier gameNotifier) {
    game.runUndoCell();
    gameNotifier.saveGame(game);
    setState(() {
      if (selectedCell != null) {
        selectedCell = game.getCell(selectedCell!.row, selectedCell!.column);
      }
    });
  }

  Future<void> handleNumberSelection(
    BuildContext context,
    int? value,
    TapDownDetails details,
    Game game,
  ) async {
    if (selectedCell == null) {
      logger.i('Number hightlighted: $value');

      final catArmNotifier = ref.read(catArmProvider.notifier);
      catArmNotifier.tap(details.globalPosition);
      await vibrationFeedback();

      if (selectedNumber == value) {
        setState(() {
          selectedNumber = null;
        });
        checkGameCompleted(context);
        return;
      }
      setState(() {
        selectedCell = null;
        selectedNumber = value;
      });
      checkGameCompleted(context);
      return;
    }
    logger.i('Value submitted: $value');
    final intValue = value ?? 0;
    if (selectedCell != null) {
      if (intValue >= 0 && intValue <= 9) {
        final updatedCell = game.handleCellInput(
          selectedCell!,
          tapState,
          intValue,
        );
        setState(() {
          selectedNumber = null;
          selectedCell = updatedCell;
        });
      }
    }

    checkGameCompleted(context);
    return;
  }

  Future<void> checkGameCompleted(BuildContext context) async {
    final gameNotifier = ref.read(gameProvider.notifier);
    final game = ref.watch(gameProvider);

    if (!game.isGridCompleted()) {
      return;
    }

    final localizations = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    final correct = game.isGameCorrect();
    if (!correct) {
      await Vibration.vibrate(preset: VibrationPreset.dramaticNotification);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.gameMistakesExisted)),
      );
      return;
    }
    await Vibration.vibrate(preset: VibrationPreset.longAlarmBuzz);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            localizations.gameCongratulations,
            style: TextStyle(color: themeData.colorScheme.onSurface),
          ),
          content: Column(
            children: [
              Image.asset('assets/images/white_cat_2.png'),
              Text(
                localizations.gameCompletedMessage(
                  formatElapsedTime(game.elapsedTime),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                gameNotifier.finishGame();
                setState(() {
                  selectedCell = null;
                  selectedNumber = null;
                });
                if (mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(Routes.home, (route) => false);
                }
              },
              child: Text(localizations.gameButtonExit),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final gameNotifier = ref.read(gameProvider.notifier);
    final game = ref.watch(gameProvider);
    return Scaffold(
      body: CatArmOverlay(
        child: Container(
          color: themeData.scaffoldBackgroundColor,
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          game.grid.difficulty != SudokuDifficulty.unknown
                              ? game.grid.difficulty
                                    .toString()
                                    .split('.')
                                    .last
                                    .toUpperCase()
                              : '',
                          style: themeData.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    Expanded(child: Center(child: ElapsedTime())),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GameGridWidget(
                    selectedNumber: selectedNumber,
                    selectedCell: selectedCell,
                    onCellTap: (cell) => handleCellTap(context, cell, game),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: VerifyButton(
                          onConfirm: () =>
                              handleConfirm(context, gameNotifier, game),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ResetButton(
                          onReset: () => handleReset(gameNotifier),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ExitButton(
                          onExit: () => handleExit(gameNotifier),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: UndoButton(
                          onUndo: () => handleUndo(game, gameNotifier),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Center(
                          child: ToggleButtons(
                            borderRadius: BorderRadius.circular(32.0),
                            isSelected: [
                              tapState == TapState.pencil,
                              tapState == TapState.pen,
                            ],
                            onPressed: (index) async {
                              await vibrationFeedback();
                              setState(() {
                                tapState = index == 0
                                    ? TapState.pencil
                                    : TapState.pen;
                              });
                            },
                            children: [
                              Icon(Icons.create_outlined),
                              Icon(Icons.create),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: DeleteButton(
                          onDelete: () {
                            handleErase(game);
                            gameNotifier.saveGame(game);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Numpad(
                      selectedNumber: selectedNumber,
                      onNumberSelection: (number, details) async =>
                          await handleNumberSelection(
                            context,
                            number,
                            details,
                            game,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatElapsedTime(Duration elapsedTime) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(elapsedTime.inMinutes.remainder(60));
    final seconds = twoDigits(elapsedTime.inSeconds.remainder(60));
    return '${minutes}m ${seconds}s';
  }
}
