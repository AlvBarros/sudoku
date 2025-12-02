import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/presentation/widgets/calendar_stats.dart';
import 'package:sudoku/presentation/widgets/quick_stats.dart';

class StatsCard extends ConsumerStatefulWidget {
  const StatsCard({super.key});

  @override
  ConsumerState<StatsCard> createState() => _QuickStatsState();
}

class _QuickStatsState extends ConsumerState<StatsCard> {
  String formatDuration(Duration duration) {
    if (duration == Duration.zero) {
      return 'N/A';
    }
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width *
          0.9, // Limits width to 90% of the viewport
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(child: QuickStats()),
              const SizedBox(width: 16),
              Expanded(child: CalendarStats()),
            ],
          ),
        ),
      ),
    );
  }
}
