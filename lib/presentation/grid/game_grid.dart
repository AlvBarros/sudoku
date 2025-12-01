import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/application/providers.dart';
import 'package:sudoku/domain/game.dart';

class GameGridWidget extends ConsumerWidget {
  final int? selectedNumber;
  final Cell? selectedCell;
  final Function(Cell) onCellTap;
  const GameGridWidget({
    super.key,
    required this.onCellTap,
    this.selectedCell,
    this.selectedNumber,
  });

  /// Should return the border for each cell, taking into account
  /// the thicker borders for 3x3 quadrants.
  /// Reminder that row and col are 0-indexed.
  Border getCellBorder(int row, int col) {
    BorderSide topBorder = BorderSide.none,
        bottomBorder = BorderSide.none,
        leftBorder = BorderSide.none,
        rightBorder = BorderSide.none;

    final strongBorder = BorderSide(color: Colors.black, width: 0.8);
    final lightBorder = BorderSide(color: Colors.black12, width: 0.8);

    switch (col) {
      case 0:
        leftBorder = BorderSide.none;
        break;
      case 2:
      case 5:
        rightBorder = strongBorder;
        break;
      case 3:
      case 6:
        leftBorder = strongBorder;
        break;
      case 8:
        rightBorder = BorderSide.none;
        break;
      default:
        rightBorder = lightBorder;
        leftBorder = lightBorder;
        break;
    }

    switch (row) {
      case 0:
        topBorder = BorderSide.none;
        break;
      case 2:
      case 5:
        bottomBorder = strongBorder;
        break;
      case 3:
      case 6:
        topBorder = strongBorder;
        break;
      case 8:
        bottomBorder = BorderSide.none;
        break;
      default:
        topBorder = lightBorder;
        bottomBorder = lightBorder;
        break;
    }

    return Border(
      top: topBorder,
      left: leftBorder,
      right: rightBorder,
      bottom: bottomBorder,
    );
  }

  /// Basically returns a widget displaying the cell value
  /// If the user uses "pencil" to mark possible values, this function
  /// displays those values as if the cell itself was a 3x3 grid.
  /// If the user uses "pen" to mark a definite value, this function
  /// displays that value centered in the cell.
  Widget getCellValue(int row, int col, Game game) {
    final cell = game.getCell(row, col);
    if (cell.value == null && cell.defaultValue == 0 && cell.notes.isEmpty) {
      return Text('', style: TextStyle(fontSize: 20));
    }

    if (cell.notes.isNotEmpty) {
      // Display notes in a 3x3 grid
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(9, (index) {
          final noteValue = index + 1;
          return Center(
            child: Text(
              cell.notes.contains(noteValue) ? noteValue.toString() : '',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          );
        }),
      );
    }

    FontWeight fontWeight = FontWeight.normal;
    Color textColor = Colors.black;
    if (cell.value != null && cell.defaultValue == 0) {
      textColor = Colors.purpleAccent;
      fontWeight = FontWeight.bold;
    }
    if (selectedNumber != null && cell.value == selectedNumber ||
        cell.defaultValue == selectedNumber) {
      textColor = Colors.purple;
      fontWeight = FontWeight.bold;
    }

    return Text(
      cell.defaultValue == 0
          ? cell.value.toString()
          : cell.defaultValue.toString(),
      style: TextStyle(fontSize: 20, fontWeight: fontWeight, color: textColor),
    );
  }

  /// Returns the background color for the cell,
  /// highlighting the selected cell and its row/column.
  Color getCellColor(int row, int col, Game game) {
    if (game.shouldHighlightCell(row, col, selectedNumber)) {
      return Colors.purple.shade100.withAlpha(15);
    }

    if (selectedCell == null) {
      return Colors.white;
    }
    if (selectedCell!.row == row && selectedCell!.column == col) {
      return Colors.purple.shade500.withAlpha(75);
    }
    if (selectedCell!.row == row || selectedCell!.column == col) {
      return Colors.purple.shade100.withAlpha(75);
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);

    // Build a matrix for each cell value
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(9, (row) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(9, (col) {
            return Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => Container(
                  decoration: BoxDecoration(
                    border: getCellBorder(row, col),
                    color: getCellColor(row, col, game),
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onCellTap(game.getCell(row, col)),
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxWidth,
                      child: Center(child: getCellValue(row, col, game)),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
