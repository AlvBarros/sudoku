import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/application/providers.dart';

class Numpad extends ConsumerWidget {
  final Function(int?) onNumberSelection;
  const Numpad({super.key, required this.onNumberSelection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonHeight = constraints.maxHeight / 3 - 16.0;
        final buttonWidth = constraints.maxWidth / 3 - 16.0;
        return Wrap(
          spacing: 16.0,
          runSpacing: 4.0,
          children: [
            for (int i = 1; i <= 9; i++)
              SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () => onNumberSelection(i),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          i.toString(),
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '${game.amountOfNumbersFilled(i)}/9',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
