import 'package:flutter/material.dart';

class VerifyButton extends StatelessWidget {
  final VoidCallback onConfirm;

  const VerifyButton({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.check_circle_outline),
      onPressed: () {
        showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Lose Perfect Game?'),
            content: Text(
              'Checking the grid will remove the "perfect game" status. Do you want to proceed?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        ).then((confirm) {
          if (confirm == true) {
            onConfirm();
          }
        });
      },
      tooltip: 'Verify Grid',
    );
  }
}
