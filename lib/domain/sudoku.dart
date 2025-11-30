enum SudokuDifficulty { unknown, easy, medium, hard, expert }

enum SudokuSectionType { row, column, quadrant }

class SudokuSection {
  final SudokuSectionType type;
  final int index;

  SudokuSection(this.type, this.index);
}

class SudokuGrid {
  final String? id;
  final SudokuDifficulty difficulty;

  /// This grid is a 9x9 matrix representing a Sudoku puzzle.
  /// Each cell contains an integer from 0-9, where 0 represents an empty cell.
  /// Consider the first list as rows and the second list as columns.
  final List<List<int>> grid;

  /// Checks if the grid is empty (all cells are 0).
  bool get isEmpty {
    for (final row in grid) {
      if (row.any((cell) => cell != 0)) {
        return false;
      }
    }
    return true;
  }

  /// Gets the 3x3 quadrant based on the quadrant index (0-8).
  /// Consider quadrants indexed from left to right, top to bottom.
  /// For example:
  /// 0 | 1 | 2
  /// 3 | 4 | 5
  /// 6 | 7 | 8
  List<List<int>> getQuadrant(int quadrantIndex) {
    if (quadrantIndex < 0 || quadrantIndex > 8) {
      throw ArgumentError('Quadrant index must be between 0 and 8.');
    }

    final startRow = (quadrantIndex ~/ 3) * 3;
    final startCol = (quadrantIndex % 3) * 3;
    final quadrant = <List<int>>[];

    for (var i = 0; i < 3; i++) {
      final row = <int>[];
      for (var j = 0; j < 3; j++) {
        row.add(getCell(startRow + i, startCol + j));
      }
      quadrant.add(row);
    }
    return quadrant;
  }

  List<int> getRow(int rowIndex) => grid[rowIndex];
  List<int> getColumn(int colIndex) =>
      grid.map((row) => row[colIndex]).toList();
  int getCell(int rowIndex, int colIndex) => grid[rowIndex][colIndex];

  SudokuGrid(this.id, this.difficulty, this.grid) {
    if (grid.length != 9 || grid.any((row) => row.length != 9)) {
      throw ArgumentError('Grid must be a 9x9 matrix.');
    }
  }

  bool _isListUnique(List<int> numbers) {
    final seen = <int>{};
    for (var num in numbers) {
      if (num != 0) {
        if (seen.contains(num)) return false;
        seen.add(num);
      }
    }
    return true;
  }

  bool isRowValid(int rowIndex) {
    final row = getRow(rowIndex);
    return _isListUnique(row);
  }

  bool isColumnValid(int colIndex) {
    final column = getColumn(colIndex);
    return _isListUnique(column);
  }

  bool isQuadrantValid(int quadrantIndex) {
    final quadrant = getQuadrant(quadrantIndex);
    final numbers = <int>[];
    for (var row in quadrant) {
      numbers.addAll(row);
    }
    return _isListUnique(numbers);
  }

  /// Returns a list of invalid sections (rows, columns, quadrants).
  /// If earlyReturn is true, it stops checking after finding the first invalid section.
  List<SudokuSection> getErrors({bool earlyReturn = false}) {
    final invalidSections = <SudokuSection>[];
    for (var i = 0; i < 9; i++) {
      if (!isRowValid(i)) {
        invalidSections.add(SudokuSection(SudokuSectionType.row, i));
        if (earlyReturn) return invalidSections;
      }
      if (!isColumnValid(i)) {
        invalidSections.add(SudokuSection(SudokuSectionType.column, i));
        if (earlyReturn) return invalidSections;
      }
      if (!isQuadrantValid(i)) {
        invalidSections.add(SudokuSection(SudokuSectionType.quadrant, i));
        if (earlyReturn) return invalidSections;
      }
    }
    return invalidSections;
  }

  /// Checks if the Sudoku grid is completely solved (no errors).
  /// Meant to be a quicker check than getting all errors.
  bool isSolved() => getErrors(earlyReturn: true).isEmpty;

  factory SudokuGrid.empty() {
    return SudokuGrid(
      null,
      SudokuDifficulty.unknown,
      List.generate(9, (_) => List.filled(9, 0)),
    );
  }

  /// Creates a new SudokuGrid by copying the original and updating a specific cell.
  /// The original grid remains unchanged.
  /// [row] and [col] are zero-based indices.
  /// [value] is the new value to set in the specified cell.
  factory SudokuGrid.copyWithCell(
    SudokuGrid original,
    int row,
    int col,
    int value,
  ) {
    final newGrid = List<List<int>>.generate(
      9,
      (i) => List<int>.from(original.grid[i]),
    );
    newGrid[row][col] = value;
    return SudokuGrid(original.id, original.difficulty, newGrid);
  }
}
