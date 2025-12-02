import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokats/application/providers.dart';

final MONTHS = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

final AMOUNT_OF_DAYS_PER_MONTH = [
  31,
  -1, // February (handle leap years separately)
  31,
  30,
  31,
  30,
  31,
  31,
  30,
  31,
  30,
  31,
];

class CalendarStats extends ConsumerWidget {
  const CalendarStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsService = ref.read(statsServiceProvider);
    return FutureBuilder(
      future: statsService.getCompletedGames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final completedGames = snapshot.data!;

          final currentMonth = DateTime.now().month;
          final currentYear = DateTime.now().year;
          final dates = [];
          final amountOfDays = currentMonth == 2
              ? (DateTime.now().year % 4 == 0 ? 29 : 28)
              : AMOUNT_OF_DAYS_PER_MONTH[currentMonth - 1];
          for (int i = 1; i <= amountOfDays; i++) {
            dates.add(DateTime(currentYear, currentMonth, i));
          }

          final Map<DateTime, int> dailyStats = {};
          for (var completedGames in completedGames) {
            final date = DateTime(
              completedGames.completedAt.year,
              completedGames.completedAt.month,
              completedGames.completedAt.day,
            );
            dailyStats[date] = (dailyStats[date] ?? 0) + 1;
          }

          return GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics:
                NeverScrollableScrollPhysics(), // Prevents scrolling inside the GridView
            children: dates.map((date) {
              return Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(300),
                  color: dailyStats.containsKey(date)
                      ? Colors.green
                      : Colors.grey[300],
                ),
                child: Center(
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: dailyStats.containsKey(date)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        } else {
          return Text('No data');
        }
      },
    );
  }
}
