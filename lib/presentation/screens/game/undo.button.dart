import 'package:flutter/material.dart';
import 'package:sudokats/application/utils.dart';

class UndoButton extends StatelessWidget {
  final Function onUndo;
  const UndoButton({super.key, required this.onUndo});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.undo),
      onPressed: () async {
        await vibrationFeedback();
        onUndo();
      },
    );
  }
}
