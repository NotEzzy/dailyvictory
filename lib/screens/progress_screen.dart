import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dailyvictory/providers/habit_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});
  
  // Calculate completion rate for a specific day
  double _calculateDailyCompletionRate(List<dynamic> habits, DateTime date) {
    if (habits.isEmpty) return 0.0;
    
    int completedCount = 0;
    for (final habit in habits) {
      if (habit.lastCompletedAt != null) {
        final lastCompleted = habit.lastCompletedAt;
        if (lastCompleted.year == date.year && 
            lastCompleted.month == date.month && 
            lastCompleted.day == date.day) {
          completedCount++;
        }
      }
    }
    
    return habits.isEmpty ? 0 : (completedCount / habits.length) * 100;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitState = ref.watch(habitStreamProvider);

    // Statistics for habits
    int allHabits = 0;
    int activeHabits = 0;
    int stalledHabits = 0;
    double avgCompletionRate = 0;
    int perfectDays = 0;
    int partialDays = 0;
    int missedDays = 0;
    
    // Data for the last 30 days chart
    final now = DateTime.now();
    final last30Days = List.generate(30, (index) => 
      DateTime(now.year, now.month, now.day - index));
    final completionRates = List<double>.filled(30, 0.0);
    
    // Days of the week for the bottom chart
    final weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    habitState.whenData((habits) {
      allHabits = habits.length;
      activeHabits = habits.where((h) => h.currentStreak > 0).length;
      stalledHabits = habits.where((h) => h.currentStreak == 0).length;
      
      // Calculate actual completion rate based on streaks
      avgCompletionRate = allHabits > 0 ? activeHabits / allHabits * 100 : 0;
      
      // For the demo, we'll set some placeholder values for perfect/partial/missed days
      // In a real implementation, these would be calculated from actual habit completion data
      perfectDays = 0; // All habits completed on a day
      partialDays = 0; // Some habits completed on a day
      missedDays = 0; // No habits completed on a day
      
      // Calculate completion rates for the last 30 days
      for (int i = 0; i < 30; i++) {
        completionRates[i] = _calculateDailyCompletionRate(habits, last30Days[i]);
      }
    });

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Last 30 days'),
        trailing: Icon(CupertinoIcons.chevron_down),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              // Habit stats card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top stats row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCardNew(
                            'ALL HABITS',
                            allHabits.toString(),
                            const Icon(CupertinoIcons.square_grid_2x2, color: Color(0xFF4285F4), size: 24),
                          ),
                        ),
                        Container(width: 1, height: 60, color: CupertinoColors.systemGrey5),
                        Expanded(
                          child: _buildStatCardNew(
                            'ACTIVE',
                            activeHabits.toString(),
                            const Icon(CupertinoIcons.checkmark_circle_fill, color: Color(0xFF34A853), size: 24),
                          ),
                        ),
                        Container(width: 1, height: 60, color: CupertinoColors.systemGrey5),
                        Expanded(
                          child: _buildStatCardNew(
                            'STALLED',
                            stalledHabits.toString(),
                            const Icon(CupertinoIcons.exclamationmark_triangle_fill, color: Color(0xFFFBBC05), size: 24),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Completion rate card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AVG COMPLETION RATE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        allHabits == 0 ? 'N/A' : '${avgCompletionRate.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Chart with percentage lines
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 20,
                              getDrawingHorizontalLine: (value) {
                                return const FlLine(
                                  color: CupertinoColors.systemGrey5,
                                  strokeWidth: 1,
                                  dashArray: [5, 5],
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    if (value % 20 == 0) {
                                      return Text(
                                        '${value.toInt()}%',
                                        style: const TextStyle(fontSize: 10, color: CupertinoColors.systemGrey),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            minX: 0,
                            maxX: 29,
                            minY: 0,
                            maxY: 100,
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(30, (index) => 
                                  FlSpot(29 - index.toDouble(), completionRates[index])),
                                isCurved: true,
                                color: CupertinoColors.activeBlue,
                                barWidth: 2,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: CupertinoColors.activeBlue.withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Legend for the chart
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildLegendItem('PERFECT', '$perfectDays days', const Color(0xFF4285F4)),
                            _buildLegendItem('PARTIAL', '$partialDays days', const Color(0xFF4285F4).withOpacity(0.5)),
                            _buildLegendItem('MISSED', '$missedDays days', CupertinoColors.systemGrey4),
                          ],
                        ),
                      ),
                      
                      // Weekly progress bars
                      const SizedBox(height: 16),
                      ...weekdays.map((day) => _buildWeekdayProgressBar(day)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCardNew(String title, String value, Icon icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLegendItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.systemGrey,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildWeekdayProgressBar(String day) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF3FF),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
