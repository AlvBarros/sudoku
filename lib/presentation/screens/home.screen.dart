import 'package:flutter/material.dart';
import 'package:sudoku/presentation/images.dart';
import 'package:sudoku/presentation/widgets/start_game.dart';
import 'package:sudoku/presentation/widgets/stats_card.dart';
import 'package:sudoku/presentation/widgets/welcome_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WelcomeTitle(),
              Expanded(
                child: Image.asset(
                  isLightMode ? Images.blackCat1 : Images.whiteCat1,
                  fit: BoxFit.contain,
                ),
              ),
              StatsCard(),
              Expanded(child: StartGame()),
            ],
          ),
        ),
      ),
    );
  }
}
