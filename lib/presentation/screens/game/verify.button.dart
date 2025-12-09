import 'package:flutter/material.dart';
import 'package:sudokats/application/utils.dart';

import 'package:sudokats/l10n/app_localizations.dart';

class VerifyButton extends StatelessWidget {
  final VoidCallback onConfirm;

  const VerifyButton({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return IconButton(
      icon: Icon(Icons.check_circle_outline),
      onPressed: () async {
        await vibrationFeedback();
        showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              localizations.verifyTitle,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            content: Text(
              localizations.verifyContent,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(localizations.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(localizations.confirm),
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
