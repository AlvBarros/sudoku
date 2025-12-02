import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/application/providers.dart';
import 'package:sudoku/domain/game.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  Future<Game> initializeGame(GameNotifier gameNotifier) async {
    return gameNotifier.loadGame();
  }

  Future<void> initializeApp(GameNotifier gameNotifier) async {
    await initializeGame(gameNotifier);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameNotifier = ref.read(gameProvider.notifier);

    return FutureBuilder(
      future: initializeApp(gameNotifier),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/home');
          });
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
