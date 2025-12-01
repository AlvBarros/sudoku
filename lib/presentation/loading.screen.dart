import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/application/providers.dart';
import 'package:sudoku/presentation/grid/grid.screen.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameNotifier = ref.read(gameProvider.notifier);

    return FutureBuilder(
      future: gameNotifier.loadGame(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error loading grid')));
        } else {
          if (snapshot.hasData && !snapshot.data!.grid.isEmpty) {
            // If no saved game, navigate to New Game Screen
            WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/continuegame');
            });
          }
          if (snapshot.hasData && snapshot.data!.grid.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/newgame');
            });
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
