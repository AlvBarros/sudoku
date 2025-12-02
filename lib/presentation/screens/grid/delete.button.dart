import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;
  const DeleteButton({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return FilledButton(onPressed: onDelete, child: Icon(Icons.delete));
  }
}
