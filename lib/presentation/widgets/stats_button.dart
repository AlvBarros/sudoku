import 'package:flutter/material.dart';

class StatsButton extends StatelessWidget {
  const StatsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.emoji_events),
      onPressed: () {
        Navigator.pushNamed(context, '/stats');
      },
    );
  }
}