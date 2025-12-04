import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokats/application/logger.dart';
import 'package:sudokats/application/providers.dart';
import 'package:sudokats/domain/game.dart';
import 'package:sudokats/domain/sudoku.dart';
import 'package:sudokats/l10n/app_localizations.dart';
import 'package:sudokats/presentation/screens/grid/delete.button.dart';

import 'package:sudokats/presentation/screens/grid/exit.button.dart';
import 'package:sudokats/presentation/screens/grid/ellapsed_time.widget.dart';
import 'package:sudokats/presentation/screens/grid/game_grid.widget.dart';
import 'package:sudokats/presentation/screens/grid/numpad.widget.dart';
import 'package:sudokats/presentation/screens/grid/reset.button.dart';
import 'package:sudokats/presentation/screens/grid/undo.button.dart';
import 'package:sudokats/presentation/screens/grid/verify.button.dart';

class GridScreen extends ConsumerStatefulWidget {
  const GridScreen({super.key});

  @override
  ConsumerState<GridScreen> createState() => _GridScreenState();
}

class _GridScreenState extends ConsumerState<GridScreen> {
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
      Navigator.of(context).pushReplacementNamed('/home');
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

  void handleValueSubmit(BuildContext context, int? value, Game game) {
    if (selectedCell == null) {
      logger.i('Number hightlighted: $value');
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

  void checkGameCompleted(BuildContext context) {
    final gameNotifier = ref.read(gameProvider.notifier);
    final game = ref.watch(gameProvider);

    if (!game.isGridCompleted()) {
      return;
    }

    final localizations = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    final correct = game.isGameCorrect();
    if (!correct) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.gameMistakesExisted)),
      );
      return;
    }
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
                  ).pushNamedAndRemoveUntil('/home', (route) => false);
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
      body: Container(
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
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        VerifyButton(
                          onConfirm: () =>
                              handleConfirm(context, gameNotifier, game),
                        ),
                        ResetButton(onReset: () => handleReset(gameNotifier)),
                        ExitButton(onExit: () => handleExit(gameNotifier)),
                      ],
                    ),
                  ),
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
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: UndoButton(
                          onUndo: () {
                            game.runUndoCell();
                            gameNotifier.saveGame(game);
                            setState(() {
                              if (selectedCell != null) {
                                selectedCell = game.getCell(
                                  selectedCell!.row,
                                  selectedCell!.column,
                                );
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ToggleButtons(
                          borderRadius: BorderRadius.circular(32.0),
                          isSelected: [
                            tapState == TapState.pencil,
                            tapState == TapState.pen,
                          ],
                          onPressed: (index) {
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DeleteButton(
                          onDelete: () {
                            handleErase(game);
                            gameNotifier.saveGame(game);
                          },
                        ),
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
                    onNumberSelection: (number) =>
                        handleValueSubmit(context, number, game),
                  ),
                ),
              ),
            ],
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
