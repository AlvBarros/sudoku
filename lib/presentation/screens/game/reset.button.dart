import 'package:flutter/material.dart';
import 'package:sudokats/application/utils.dart';

import 'package:sudokats/l10n/app_localizations.dart';

class ResetButton extends StatelessWidget {
  final Function()? onReset;
  const ResetButton({super.key, this.onReset});

  void _showConfirmationDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localizations.resetTitle,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Text(
            localizations.resetContent,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onReset != null) {
                  onReset!();
                }
              },
              child: Text(localizations.confirm),
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
      icon: const Icon(Icons.refresh),
    );
  }
}
