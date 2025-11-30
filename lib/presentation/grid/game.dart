import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/application/providers.dart';
import 'package:sudoku/domain/game.dart';

class GameWidget extends ConsumerWidget {
  const GameWidget({super.key});

  Border getCellBorder(int row, int col) {
    return Border(
      top: BorderSide(
        color: (row % 3 == 0) ? Colors.black : Colors.black12,
        width: (row % 3 == 0) ? 2.0 : 1.0,
      ),
      left: BorderSide(
        color: (col % 3 == 0) ? Colors.black : Colors.black12,
        width: (col % 3 == 0) ? 2.0 : 1.0,
      ),
      right: BorderSide(
        color: (col == 8) ? Colors.black : Colors.black12,
        width: (col == 8) ? 2.0 : 1.0,
      ),
      bottom: BorderSide(
        color: (row == 8) ? Colors.black : Colors.black12,
        width: (row == 8) ? 2.0 : 1.0,
      ),
    );
  }

  /// Basically returns a widget displaying the cell value
  /// If the user uses "pencil" to mark possible values, this function
  /// displays those values as if the cell itself was a 3x3 grid.
  /// If the user uses "pen" to mark a definite value, this function
  /// displays that value centered in the cell.
  Widget getCellValue(int row, int col, Game game) {
    final cell = game.getCell(row, col);
    if (cell == null) {
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

    return Text(
      cell.defaultValue == 0
          ? cell.value.toString()
          : cell.defaultValue.toString(),
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
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
                  decoration: BoxDecoration(border: getCellBorder(row, col)),
                  child: GestureDetector(
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
