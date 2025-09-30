import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/habit.dart';

class HabitDetailScreen extends ConsumerStatefulWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen> {
  int _currentTabIndex = 0;
  final List<String> _tabs = ['Progress', 'Notes', 'About'];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground,
        border: null,
        middle: Text(widget.habit.title),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.ellipsis_circle),
          onPressed: () {
            // Show options menu
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: _tabs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final title = entry.value;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _currentTabIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: _currentTabIndex == index
                              ? CupertinoColors.systemGrey5
                              : CupertinoColors.systemBackground,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: _currentTabIndex == index
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Month selector
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMMM yyyy').format(DateTime.now()),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Icon(CupertinoIcons.chevron_down, size: 16),
                  ],
                ),
              ),
            ),

            // Content based on selected tab
            Expanded(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  _buildProgressTab(),
                  _buildNotesTab(),
                  _buildAboutTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTab() {
    
    // Get the current date and calculate dates for the last 7 days
    final now = DateTime.now();
    final weekDays = List.generate(7, (index) => 
      DateTime(now.year, now.month, now.day - (6 - index)));
    
    // Get the day names for the week
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    // Calculate completion data
    final habit = widget.habit;
    final currentStreak = habit.currentStreak;
    final bestStreak = habit.bestStreak ?? 0;
    
    // Calculate success, failed, and skipped days (placeholder logic)
    final successDays = currentStreak;
    const failedDays = 0; // This would need actual tracking of failed days
    const skippedDays = 0; // This would need actual tracking of skipped days
    final totalMinutes = habit.duration * successDays;
    
    // Generate motivational text based on streak
    String motivationalText = '';
    if (currentStreak == 0) {
      motivationalText = 'Zero is the perfect launchpad—focus on taking that very first step.';
    } else if (currentStreak < 3) {
      motivationalText = 'Great start! Keep building your momentum.';
    } else if (currentStreak < 7) {
      motivationalText = 'You\'re developing a solid habit! Keep it up!';
    } else {
      motivationalText = 'Impressive streak! You\'re making this a part of your lifestyle.';
    }
    
    // Calculate monthly average completion rate
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final monthlyAverage = (successDays / daysInMonth * 100).toStringAsFixed(1);
    
    // Check if the habit was completed on each of the last 7 days
    List<bool> completedDays = List.generate(7, (index) => false);
    if (habit.lastCompletedAt != null) {
      for (int i = 0; i < 7; i++) {
        final day = weekDays[i];
        final lastCompleted = habit.lastCompletedAt!;
        
        // Check if the habit was completed on this day
        if (lastCompleted.year == day.year && 
            lastCompleted.month == day.month && 
            lastCompleted.day == day.day) {
          completedDays[i] = true;
        }
      }
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Streak flame icon
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: currentStreak > 0 ? CupertinoColors.activeOrange.withOpacity(0.1) : CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              CupertinoIcons.flame,
              size: 48,
              color: currentStreak > 0 ? CupertinoColors.activeOrange : CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 16),

          // Day streak text
          Text(
            currentStreak.toString(),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'day streak!',
            style: TextStyle(
              fontSize: 20,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 8),

          // Motivational text
          Text(
            motivationalText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.systemGrey,
            ),
          ),

          const SizedBox(height: 24),

          // Week day indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final day = dayNames[weekDays[index].weekday % 7];
              final isCompleted = completedDays[index];
              return Column(
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted ? CupertinoColors.activeGreen : CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: isCompleted 
                      ? const Icon(CupertinoIcons.checkmark, color: CupertinoColors.white, size: 16) 
                      : null,
                  ),
                ],
              );
            }),
          ),

          const SizedBox(height: 24),

          // Stats grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard('SUCCESS', '$successDays Days', 'Completed'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard('FAILED', '$failedDays Days', 'Missed'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('SKIPPED', '$skippedDays Days', 'Not tracked'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard('TOTAL', '$totalMinutes Minutes', 'Time invested'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Streaks section
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Streaks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          bestStreak > 0 
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Best Streak',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(CupertinoIcons.flame, color: CupertinoColors.activeOrange),
                        const SizedBox(width: 4),
                        Text(
                          '$bestStreak days',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : const Center(
                child: Text(
                  'Not enough information for ranking',
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),

          const SizedBox(height: 24),

          // Monthly average section
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'MONTHLY AVERAGE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$monthlyAverage%',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(7, (index) => 
                      FlSpot(index.toDouble(), completedDays[index] ? 100 : 0)),
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
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: CupertinoColors.systemGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Add notes about your progress, challenges, or insights related to this habit.',
              style: TextStyle(
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
          const SizedBox(height: 16),
          CupertinoButton.filled(
            child: const Text('Add Note'),
            onPressed: () {
              // Add note functionality would go here
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.habit.description ?? 'No description provided',
            style: const TextStyle(
              fontSize: 16,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Duration',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.habit.duration} minutes',
            style: const TextStyle(
              fontSize: 16,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Reminder',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.habit.reminderTime.hour}:${widget.habit.reminderTime.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 16,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Frequency',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.habit.frequency,
            style: const TextStyle(
              fontSize: 16,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
}
