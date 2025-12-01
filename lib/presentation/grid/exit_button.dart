import 'package:flutter/material.dart';

class ExitButton extends StatelessWidget {
  final Function()? onExit;
  const ExitButton({super.key, required this.onExit});

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm exit'),
          content: Text('Are you sure you want to exit the game?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onExit != null) {
                  onExit!();
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showConfirmationDialog(context),
      icon: const Icon(Icons.logout),
    );
  }
}
