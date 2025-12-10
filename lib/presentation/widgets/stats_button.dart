import 'package:flutter/material.dart';
import 'package:sudokats/main.dart';

///  @deprecated
/// This button is not being used since the stats screen is disabled.
class StatsButton extends StatelessWidget {
  const StatsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.emoji_events),
      onPressed: () {
        Navigator.pushNamed(context, Routes.stats);
      },
    );
  }
}
