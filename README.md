# sudoku

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## MVP 1 - Play a Sudoku Game

This first MVP should be able to simply fetch a Grid to play.

- UI, state mgmt, local persistence, clean code.
- Load one puzzle (or random puzzle) from a pre-baked JSON.
- Editable grid, pencil marks, highlight row/col/box, keyboard navigation.
- Persist current grid in localStorage keyed by puzzle ID.
- Reset and Exit buttons
- Undo button

- [Source](https://www.kaggle.com/datasets/radcliffe/3-million-sudoku-puzzles-with-ratings) for Sudoku Grids