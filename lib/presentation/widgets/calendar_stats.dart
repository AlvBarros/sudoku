import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudokats/application/providers.dart';
import 'package:intl/intl.dart';

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
    final localizations = AppLocalizations.of(context)!;
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

          final now = DateTime.now();
          final currentMonth = now.month;
          final currentYear = now.year;
          final locale = Localizations.localeOf(context).toString();
          final monthName = DateFormat.MMMM(locale).format(now);

          final dates = <DateTime>[];
          final amountOfDays = DateTime(currentYear, currentMonth + 1, 0).day;
          for (int i = 1; i <= amountOfDays; i++) {
            dates.add(DateTime(currentYear, currentMonth, i));
          }

          final Map<DateTime, int> dailyStats = {};
          for (var completedGame in completedGames) {
            final date = DateTime(
              completedGame.completedAt.year,
              completedGame.completedAt.month,
              completedGame.completedAt.day,
            );
            dailyStats[date] = (dailyStats[date] ?? 0) + 1;
          }

          return Column(
            children: [
              Text(monthName, style: Theme.of(context).textTheme.titleLarge),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
              ),
            ],
          );
        } else {
          return Text(localizations.statsNoData);
        }
      },
    );
  }
}
