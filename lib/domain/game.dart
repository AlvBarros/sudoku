import 'package:sudoku/domain/sudoku.dart';

class Cell {
  final int row;
  final int column;
  final int defaultValue;
  int? value;
  List<int> notes;

  Cell({
    required this.row,
    required this.column,
    this.defaultValue = 0,
    this.value,
    this.notes = const [],
  });
}

class Game {
  final SudokuGrid grid;
  final DateTime startedAt;
  final Duration elapsedTime;

  /// A map of cell identifiers to Cell objects.
  /// The key is a string in the format "row_column",
  /// e.g., "0_0" for the cell at row 0, column 0.
  final Map<String, Cell> cells = {};

  Game({
    required this.grid,
    required this.startedAt,
    required this.elapsedTime,
    String answers = '',
    String notes = '',
  }) {
    if (answers.isNotEmpty) setAnswers(answers);
    if (notes.isNotEmpty) setNotes(notes);

    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        final cellKey = '${r}_$c';
        if (!cells.containsKey(cellKey)) {
          final defaultValue = grid.getCell(r, c);
          if (defaultValue != 0) {
            // Pre-fill given numbers as default cells
            cells[cellKey] = Cell(
              row: r,
              column: c,
              value: null,
              defaultValue: defaultValue,
            );
          }
        }
      }
    }
  }

  /// This is a factory constructor that creates a game
  /// in a "waiting" state, with an empty grid and
  /// zero elapsed time.
  factory Game.waiting() {
    return Game(
      grid: SudokuGrid.empty(),
      startedAt: DateTime.now(),
      elapsedTime: Duration.zero,
    );
  }

  Cell? getCell(int row, int column) {
    final cellKey = '${row}_$column';
    return cells[cellKey];
  }

  /// This method sets this game's answers with
  /// the provided String.
  void setAnswers(String answers) {
    final entries = answers.split(',');
    for (final entry in entries) {
      final parts = entry.split(':');
      if (parts.length != 2) continue;

      final cellKey = parts[0];
      final value = int.tryParse(parts[1]) ?? 0;
      if (value == 0) continue;

      final cellCoords = cellKey.split('_');
      if (cellCoords.length != 2) continue;

      final row = int.tryParse(cellCoords[0]) ?? 0;
      final column = int.tryParse(cellCoords[1]) ?? 0;

      if (cells.containsKey(cellKey)) {
        cells[cellKey]!.value = value;
      } else {
        cells[cellKey] = Cell(
          row: row,
          column: column,
          value: value,
          defaultValue: 0, // User can't replace given numbers
        );
      }
    }
  }

  /// This method sets this game's notes with
  /// the provided String.
  void setNotes(String notes) {
    final entries = notes.split(',');
    for (final entry in entries) {
      final parts = entry.split(':');
      if (parts.length != 2) continue;

      final cellKey = parts[0];
      final notesStr = parts[1];
      final noteValues = notesStr
          .split(';')
          .map((e) => int.tryParse(e) ?? 0)
          .where((e) => e != 0)
          .toList();
      if (noteValues.isEmpty) continue;

      final cellCoords = cellKey.split('_');
      if (cellCoords.length != 2) continue;

      final row = int.tryParse(cellCoords[0]) ?? 0;
      final column = int.tryParse(cellCoords[1]) ?? 0;

      if (cells.containsKey(cellKey)) {
        cells[cellKey]!.notes = noteValues;
      } else {
        cells[cellKey] = Cell(
          row: row,
          column: column,
          notes: noteValues,
          defaultValue: grid.getCell(row, column),
        );
      }
    }
  }

  /// This method gets this game's answers as
  /// a String.
  String getAnswers() {
    String result = '';
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        final cellKey = '${r}_$c';
        final cell = cells[cellKey];
        if (cell != null) {
          result += ',$cellKey:${cell.value ?? 0}';
        }
      }
    }
    result = result.isNotEmpty ? result.substring(1) : result;
    return result;
  }

  /// This method gets this game's notes as
  /// a String.
  String getNotes() {
    String result = '';
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        final cellKey = '${r}_$c';
        final cell = cells[cellKey];
        if (cell != null && cell.notes.isNotEmpty) {
          final notesStr = cell.notes.join(';');
          result += ',$cellKey:$notesStr';
        }
      }
    }
    result = result.isNotEmpty ? result.substring(1) : result;
    return result;
  }
}
