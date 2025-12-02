import 'package:flutter/material.dart';

class UndoButton extends StatelessWidget {
  final Function onUndo;
  const UndoButton({super.key, required this.onUndo});

  @override
  Widget build(BuildContext context) {
    return FilledButton(child: Icon(Icons.undo), onPressed: () => onUndo());
  }
}
