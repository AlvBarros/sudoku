import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  final Function()? onReset;
  const ResetButton({super.key, this.onReset});

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Reset'),
          content: Text('Are you sure you want to reset the game?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onReset != null) {
                  onReset!();
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
      icon: const Icon(Icons.refresh),
    );
  }
}
