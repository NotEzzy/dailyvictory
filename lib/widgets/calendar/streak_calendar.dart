import 'package:flutter/cupertino.dart';
import 'package:dailyvictory/models/habit.dart';

class StreakCalendar extends StatelessWidget {
  final List<Habit> habits;
  final DateTime selectedDate;

  const StreakCalendar({
    super.key,
    required this.habits,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;

    return Column(
      children: [
        // Month selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // TODO: Navigate to previous month
              },
              child: const Icon(CupertinoIcons.chevron_left),
            ),
            Text(
              '${selectedDate.month}/${selectedDate.year}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                // TODO: Navigate to next month
              },
              child: const Icon(CupertinoIcons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
            return SizedBox(
              width: 40,
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),

        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: 42, // 6 rows * 7 days
          itemBuilder: (context, index) {
            final adjustedIndex = index - (firstWeekday - 1);
            if (adjustedIndex < 0 || adjustedIndex >= daysInMonth) {
              return const SizedBox();
            }

            final date = DateTime(selectedDate.year, selectedDate.month, adjustedIndex + 1);
            final isCompleted = habits.any((habit) => 
              habit.lastCompletedAt?.year == date.year &&
              habit.lastCompletedAt?.month == date.month &&
              habit.lastCompletedAt?.day == date.day
            );

            return Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isCompleted ? CupertinoColors.activeGreen.withOpacity(0.2) : null,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCompleted ? CupertinoColors.activeGreen : CupertinoColors.systemGrey4,
                  width: isCompleted ? 2 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  '${adjustedIndex + 1}',
                  style: TextStyle(
                    color: isCompleted ? CupertinoColors.activeGreen : CupertinoColors.black,
                    fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
} 