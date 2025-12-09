import 'package:flutter/material.dart';
import 'package:sudokats/application/utils.dart';

class ExitButton extends StatelessWidget {
  final Function()? onExit;
  const ExitButton({super.key, required this.onExit});

  void _showConfirmationDialog(BuildContext context) {
    final themeData = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeData.colorScheme.surface,
          title: Text(
            'Confirm exit',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Text(
            'Are you sure you want to exit the game?',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: themeData.colorScheme.secondary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onExit != null) {
                  onExit!();
                }
              },
              child: Text(
                'Confirm',
                style: TextStyle(color: themeData.colorScheme.secondary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await vibrationFeedback();
        _showConfirmationDialog(context);
      },
      icon: const Icon(Icons.logout),
    );
  }
}
