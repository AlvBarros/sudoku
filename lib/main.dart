import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sudoku/application/logger.dart';
import 'package:sudoku/presentation/loading.screen.dart';

void main() {
  logger.i("App started");
  runApp(const ProviderScope(child: MaterialApp(home: LoadingScreen())));
}
