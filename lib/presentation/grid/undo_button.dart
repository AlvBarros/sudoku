import 'package:flutter/material.dart';

class UndoButton extends StatelessWidget {
  final Function onUndo;
  const UndoButton({super.key, required this.onUndo});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.undo),
      label: Text('Undo'),
      onPressed: () => onUndo(),
    );
  }
}
