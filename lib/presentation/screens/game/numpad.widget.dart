import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sudokats/application/providers.dart';

class Numpad extends ConsumerStatefulWidget {
  final int? selectedNumber;
  final Function(int?, TapDownDetails) onNumberSelection;
  const Numpad({
    super.key,
    required this.onNumberSelection,
    this.selectedNumber,
  });

  @override
  ConsumerState<Numpad> createState() => _NumpadState();
}

class _NumpadState extends ConsumerState<Numpad> {
  void handleTapDown(int number, TapDownDetails details) {
    widget.onNumberSelection(number, details);
  }

  @override
  Widget build(BuildContext context) {
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
                child: _NumberButton(
                  number: i,
                  isSelected: widget.selectedNumber == i,
                  filledCount: game.amountOfNumbersFilled(i),
                  onTapDown: (details) => handleTapDown(i, details),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _NumberButton extends ConsumerStatefulWidget {
  final int number;
  final bool isSelected;
  final int filledCount;
  final Function(TapDownDetails)? onTapDown;

  const _NumberButton({
    required this.number,
    required this.isSelected,
    required this.filledCount,
    required this.onTapDown,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NumberButtonState();
}

class _NumberButtonState extends ConsumerState<_NumberButton> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isLightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.onTapDown,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: AnimatedOpacity(
                opacity: widget.isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Image.asset(
                  isLightMode
                      ? 'assets/images/paw-orange.png'
                      : 'assets/images/paw-purple.png',
                  height: 56,
                ),
              ),
            ),
            Center(
              child: Stack(
                children: [
                  // Outline text
                  Visibility(
                    visible: widget.isSelected,
                    child: Text(
                      widget.number.toString(),
                      style: TextStyle(
                        fontSize: textTheme.headlineMedium?.fontSize,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth =
                              2.0 // Thickness of the outline
                          ..color = widget.isSelected
                              ? Colors.black
                              : colorScheme.onSecondary,
                      ),
                    ),
                  ),
                  // Inner text
                  Text(
                    widget.number.toString(),
                    style: TextStyle(
                      fontSize: textTheme.headlineMedium?.fontSize,
                      fontWeight: FontWeight.bold,
                      color: widget.isSelected
                          ? colorScheme.onSecondary
                          : colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
