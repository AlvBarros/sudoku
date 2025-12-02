import 'package:flutter/material.dart';
import 'package:sudokats/domain/sudoku.dart';

enum AppTheme { light, dark, system }

final _lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  primaryColor: Colors.orange,
  colorScheme: ColorScheme.light(
    primary: Colors.orange,
    onPrimary: Colors.white,
    secondary: Colors.orangeAccent,
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.orange[50],
  textTheme: TextTheme(
    titleMedium: TextStyle(fontSize: 16, color: Colors.black),
    titleSmall: TextStyle(fontSize: 12, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 8,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange[200],
      foregroundColor: Colors.white,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
    ),
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    borderColor: Colors.orange,
    selectedBorderColor: Colors.orange,
    fillColor: Colors.orange,
    selectedColor: Colors.white,
    color: Colors.orange,
    splashColor: Colors.orange[200],
  ),
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
);

final _darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  primaryColor: Colors.purple,
  colorScheme: ColorScheme.dark(
    primary: Colors.purple,
    onPrimary: Colors.white,
    secondary: Colors.purpleAccent,
    onSecondary: Colors.white,
    tertiary: Colors.purple[200]!,
    surface: Colors.grey[800]!,
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.grey[900],
  textTheme: TextTheme(
    titleMedium: TextStyle(fontSize: 16, color: Colors.white),
    titleSmall: TextStyle(fontSize: 12, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
  ),
  cardTheme: CardThemeData(
    color: Colors.grey[850],
    elevation: 8,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.purple[200],
      foregroundColor: Colors.white,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      backgroundColor: Colors.purple,
      foregroundColor: Colors.white,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: Colors.purple,
      foregroundColor: Colors.white,
    ),
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    borderColor: Colors.purple,
    selectedBorderColor: Colors.purple,
    fillColor: Colors.purple,
    selectedColor: Colors.white,
    color: Colors.purple,
    splashColor: Colors.purple[200],
  ),
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
);

final appThemes = {Brightness.light: _lightTheme, Brightness.dark: _darkTheme};

const difficultiesColors = {
  SudokuDifficulty.easy: Colors.green,
  SudokuDifficulty.medium: Colors.orange,
  SudokuDifficulty.hard: Colors.red,
  SudokuDifficulty.expert: Colors.purple,
};
