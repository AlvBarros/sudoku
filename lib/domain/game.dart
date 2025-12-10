import 'package:sudokats/domain/sudoku.dart';

/// Enum to represent tap state pencil or pen.
/// Pencil mode: Numbers are added to notes.
/// Pen mode: Numbers are added to the cell directly.
enum TapState { pencil, pen }

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

  String getKey() => '${row}_$column';
}

class Game {
  final SudokuGrid grid;
  final DateTime startedAt;
  final Duration elapsedTime;
  bool isPerfect = true;

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
    this.isPerfect = true,
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

  final _previousCells = <Cell>[];
  void setUndoCell(Cell cell) {
    _previousCells.add(
      Cell(
        row: cell.row,
        column: cell.column,
        defaultValue: cell.defaultValue,
        value: cell.value,
        notes: List<int>.from(cell.notes),
      ),
    );
  }

  void runUndoCell() {
    if (_previousCells.isNotEmpty) {
      final previousCell = _previousCells.removeLast();
      cells[previousCell.getKey()] = previousCell;
    }
  }

  Cell getCell(int row, int column) {
    final cellKey = '${row}_$column';
    return cells[cellKey] ?? Cell(row: row, column: column);
  }

  Cell handleCellInput(Cell cell, TapState tapState, int value) {
    final cellKey = cell.getKey();
    setUndoCell(
      cells[cellKey] ??
          Cell(
            row: cell.row,
            column: cell.column,
            defaultValue: 0,
            value: null,
            notes: List<int>.from(cell.notes),
          ),
    );
    if (tapState == TapState.pen) {
      // In pen mode, set the cell's value directly
      final updatedCell = Cell(
        row: cell.row,
        column: cell.column,
        defaultValue: cell.defaultValue,
        value: value == 0 ? null : value,
        notes: [],
      );
      cells[cellKey] = updatedCell;
      return updatedCell;
    } else {
      // In pencil mode, toggle the note
      final currentNotes = List<int>.from(cell.notes);
      if (currentNotes.contains(value)) {
        currentNotes.remove(value);
      } else {
        currentNotes.add(value);
      }
      final updatedCell = Cell(
        row: cell.row,
        column: cell.column,
        defaultValue: cell.defaultValue,
        value: cell.value,
        notes: currentNotes,
      );
      cells[cellKey] = updatedCell;
      return updatedCell;
    }
  }

  Cell handleCellErase(Cell cell) {
    final cellKey = cell.getKey();
    setUndoCell(cells[cellKey]!);
    final updatedCell = Cell(
      row: cell.row,
      column: cell.column,
      defaultValue: cell.defaultValue,
      value: null,
      notes: [],
    );
    cells[cellKey] = updatedCell;
    return updatedCell;
  }

  bool shouldHighlightCell(int row, int col, int? selectedNumber) {
    if (selectedNumber == null) return false;
    final cell = getCell(row, col);
    if (cell.value == selectedNumber || cell.defaultValue == selectedNumber) {
      return true;
    }
    for (var c = 0; c < 9; c++) {
      final rowCell = getCell(row, c);
      if (rowCell.value == selectedNumber ||
          rowCell.defaultValue == selectedNumber) {
        return true;
      }
    }
    for (var r = 0; r < 9; r++) {
      final colCell = getCell(r, col);
      if (colCell.value == selectedNumber ||
          colCell.defaultValue == selectedNumber) {
        return true;
      }
    }
    final quadrantIndex = grid.getQuadrantIndex(row, col);
    for (var c = 0; c < 3; c++) {
      for (var r = 0; r < 3; r++) {
        final cellRow = (quadrantIndex ~/ 3) * 3 + r;
        final cellCol = (quadrantIndex % 3) * 3 + c;
        final quadCell = getCell(cellRow, cellCol);
        if (quadCell.value == selectedNumber ||
            quadCell.defaultValue == selectedNumber) {
          return true;
        }
      }
    }
    return false;
  }

  int amountOfNumbersFilled(int value) {
    int count = 0;
    for (var cell in cells.values) {
      if (cell.value == value || cell.defaultValue == value) {
        count++;
      }
    }
    return count;
  }

  bool isGridCompleted() {
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        final cellKey = '${r}_$c';
        final cell = cells[cellKey];
        if (cell == null || cell.value == null && cell.defaultValue == 0) {
          return false;
        }
      }
    }
    return true;
  }

  bool isGameCorrect() {
    final solved = grid.isSolved();
    if (isPerfect && !solved) {
      isPerfect = false;
    }
    return solved;
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

  int checkAndResetIncorrectCells() {
    int wrongCellsCount = 0;
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        final cellKey = '${r}_$c';
        final cell = cells[cellKey];
        if (cell != null &&
            cell.value != null &&
            cell.value != grid.getCellFromSolution(r, c)) {
          cell.value = null;
          wrongCellsCount++;
        }
      }
    }
    return wrongCellsCount;
  }
}
