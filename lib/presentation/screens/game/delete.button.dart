import 'package:flutter/material.dart';
import 'package:sudokats/application/utils.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;
  const DeleteButton({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        await vibrationFeedback();
        onDelete();
      },
    );
  }
}
