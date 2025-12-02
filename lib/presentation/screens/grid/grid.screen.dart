import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/application/logger.dart';
import 'package:sudoku/application/providers.dart';
import 'package:sudoku/domain/game.dart';
import 'package:sudoku/domain/sudoku.dart';
import 'package:sudoku/presentation/screens/grid/delete.button.dart';

import 'package:sudoku/presentation/screens/grid/exit.button.dart';
import 'package:sudoku/presentation/screens/grid/ellapsed_time.widget.dart';
import 'package:sudoku/presentation/screens/grid/game_grid.widget.dart';
import 'package:sudoku/presentation/screens/grid/numpad.widget.dart';
import 'package:sudoku/presentation/screens/grid/reset.button.dart';
import 'package:sudoku/presentation/screens/grid/undo.button.dart';

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

  bool handleCellTap(Cell cell, Game game) {
    logger.i('Cell tapped: Row ${cell.row}, Column ${cell.column}');
    if (selectedCell == null && selectedNumber != null) {
      logger.i('Number hightlighted: $selectedNumber');
      final intValue = selectedNumber!;
      if (intValue >= 1 && intValue <= 9) {
        game.handleCellInput(cell, tapState, intValue);
        setState(() {});
      }
      return game.isGridCompleted();
    }
    if (selectedCell != null &&
        selectedCell!.row == cell.row &&
        selectedCell!.column == cell.column) {
      setState(() {
        selectedNumber = null;
        selectedCell = null;
      });
      return game.isGridCompleted();
    }
    setState(() {
      selectedNumber = null;
      selectedCell = cell;
    });
    return game.isGridCompleted();
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

  bool handleValueSubmit(int? value, Game game) {
    if (selectedCell == null) {
      logger.i('Number hightlighted: $value');
      if (selectedNumber == value) {
        setState(() {
          selectedNumber = null;
        });
        return game.isGridCompleted();
      }
      setState(() {
        selectedCell = null;
        selectedNumber = value;
      });
      return game.isGridCompleted();
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

    return game.isGridCompleted();
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
                        ResetButton(
                          onReset: () {
                            gameNotifier.resetGame();
                            setState(() {
                              selectedCell = null;
                              selectedNumber = null;
                            });
                          },
                        ),
                        ExitButton(
                          onExit: () {
                            gameNotifier.exitGame();
                            setState(() {
                              selectedCell = null;
                              selectedNumber = null;
                            });
                            if (mounted) {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed('/home');
                            }
                          },
                        ),
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
                  onCellTap: (cell) => handleCellTap(cell, game),
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
                    onNumberSelection: (number) {
                      final completed = handleValueSubmit(number, game);
                      gameNotifier.saveGame(game);
                      if (completed) {
                        final correct = game.isGameCorrect();
                        if (!correct) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'There are mistakes in the puzzle.',
                              ),
                            ),
                          );
                          return;
                        }
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (!mounted) return;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Congratulations!',
                                style: TextStyle(
                                  color: themeData.colorScheme.onSurface,
                                ),
                              ),
                              content: Column(
                                children: [
                                  Image.asset('assets/images/white_cat_2.png'),
                                  Text('You have completed the puzzle.'),
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
                                      ).pushNamedAndRemoveUntil(
                                        '/home',
                                        (route) => false,
                                      );
                                    }
                                  },
                                  child: Text('Wohoo!'),
                                ),
                              ],
                            ),
                          );
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
