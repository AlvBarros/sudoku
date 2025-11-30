import 'package:flutter/material.dart';

import 'package:sudoku/presentation/grid/actions.dart';
import 'package:sudoku/presentation/grid/ellapsed_time.dart';
import 'package:sudoku/presentation/grid/game.dart';

// import 'package:sudoku/domain/sudoku.dart';

class GridScreen extends StatelessWidget {
  const GridScreen({super.key});

  @override
  Widget build(BuildContext contexts) {
    return Scaffold(
      appBar: AppBar(title: ElapsedTime(), actions: [GridActions()]),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: GameWidget()),
        ],
      ),
    );
  }
}
