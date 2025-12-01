import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/application/providers.dart';
import 'package:sudoku/domain/sudoku.dart';
import 'package:sudoku/presentation/widgets/stats_button.dart';

class NewGameScreen extends ConsumerStatefulWidget {
  const NewGameScreen({super.key});

  @override
  ConsumerState<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends ConsumerState<NewGameScreen> {
  bool isLoading = false;
  SudokuDifficulty _selectedDifficulty = SudokuDifficulty.unknown;
  List<SudokuDifficulty> difficulties = SudokuDifficulty.values
      .where((difficulty) => difficulty != SudokuDifficulty.unknown)
      .toList();

  @override
  Widget build(BuildContext context) {
    final gameNotifier = ref.read(gameProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Container(), actions: [StatsButton()]),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select Difficulty',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ToggleButtons(
                      isSelected: difficulties
                          .map(
                            (difficulty) => difficulty == _selectedDifficulty,
                          )
                          .toList(),
                      onPressed: (index) {
                        setState(() {
                          _selectedDifficulty = difficulties.elementAt(index);
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      children: difficulties
                          .map(
                            (difficulty) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Text(
                                difficulty.name[0].toUpperCase() +
                                    difficulty.name.substring(1),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      gameNotifier.newGame(_selectedDifficulty).then((value) {
                        if (mounted) {
                          Navigator.of(context).pushReplacementNamed('/grid');
                        }
                        setState(() {
                          isLoading = false;
                        });
                      });
                    },
                    child: Text('Start Now'),
                  ),
                ],
              ),
            ),
    );
  }
}
