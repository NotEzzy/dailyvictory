import 'package:dailyvictory/providers/habit_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dailyvictory/screens/habit_timer_screen.dart';
import 'package:dailyvictory/screens/habit_detail_screen.dart';
import 'package:dailyvictory/screens/add_habit_screen.dart';

/// Dashboard screen
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  DateTime _selectedDate = DateTime.now();

  DateTime get _mondayOfWeek {
    final now = _selectedDate;
    return now.subtract(Duration(days: now.weekday == 7 ? 0 : now.weekday - 1));
  }

  void _goToPreviousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
    });
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  bool _isCompletedToday(habit) {
    if (habit.lastCompletedAt == null) return false;
    final now = DateTime.now();
    final lastCompleted = habit.lastCompletedAt;
    return lastCompleted.year == now.year &&
        lastCompleted.month == now.month &&
        lastCompleted.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final habitState = ref.watch(habitStreamProvider);

    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemBackground,
        child: Stack(children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('My Journal',
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          // Icon(CupertinoIcons.pencil, size: 22),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     CupertinoButton(
                      //       padding: EdgeInsets.zero,
                      //       child: const Icon(CupertinoIcons.book),
                      //       onPressed: () {},
                      //     ),
                      //     CupertinoButton(
                      //       padding: EdgeInsets.zero,
                      //       child: const Icon(CupertinoIcons.arrow_up_right_square),
                      //       onPressed: () {},
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                // Tabs
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Row(
                //     children: [
                //       _buildTab('All Habits', true),
                //       const SizedBox(width: 8),
                //       _buildTab('Morning', false),
                //       const SizedBox(width: 8),
                //       _buildTab('+ New Area', false),
                //     ],
                //   ),
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildWeekCalendar(),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: habitState.when(
                    data: (habits) {
                      if (habits.isEmpty) {
                        return _buildEmptyState(context);
                      }
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: habits.length,
                              itemBuilder: (context, index) {
                                final habit = habits[index];
                                return _buildHabitCard(habit);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CupertinoActivityIndicator()),
                    error: (error, stack) =>
                        Center(child: Text('Error: $error')),
                  ),
                ),
              ],
            ),
          ),
          // FAB positioned at the bottom right
          Positioned(
            right: 16,
            bottom: 86,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => const AddHabitScreen(),
                  ),
                );
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.add,
                  color: CupertinoColors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ]));
  }

  Widget buildTab(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color:
            selected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? CupertinoColors.white : CupertinoColors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.plus_circle,
                size: 64, color: CupertinoColors.systemGrey3),
            const SizedBox(height: 24),
            const Text('Welcome to Journal',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'Journal makes your habit progress visible day by day. It\'s empty now, but your journey can start with a single habit.',
              textAlign: TextAlign.center,
              style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 16),
            ),
            const SizedBox(height: 32),
            CupertinoButton.filled(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => const AddHabitScreen(),
                  ),
                );
              },
              child: const Text('Build new Habit'),
            ),
            const SizedBox(height: 12),
            CupertinoButton(
              color: CupertinoColors.systemGrey5,
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Coming Soon'),
                    content: const Text('Break a Habit feature is coming soon!'),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('OK'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Break a Habit',
                  style: TextStyle(color: CupertinoColors.destructiveRed)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitCard(habit) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => HabitDetailScreen(habit: habit),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey5,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(CupertinoIcons.heart,
                        color: CupertinoColors.systemRed),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${habit.lastCompletedAt != null && _isCompletedToday(habit) ? habit.duration : 0}/${habit.duration} min',
                          style: const TextStyle(
                              color: CupertinoColors.systemGrey),
                        ),
                      ],
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                    ),
                    onPressed: () => _showStartHabitDialog(habit),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Streak: ${habit.currentStreak} days',
                    style: TextStyle(
                      color: habit.currentStreak > 0
                          ? CupertinoColors.activeOrange
                          : CupertinoColors.systemGrey,
                      fontWeight: habit.currentStreak > 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.flame,
                    color: habit.currentStreak > 0
                        ? CupertinoColors.activeOrange
                        : CupertinoColors.systemGrey,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStartHabitDialog(habit) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Start Habit'),
        content: Text('Start working on "${habit.title}"?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: const Text('Start'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => HabitTimerScreen(habit: habit),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar() {
    final monday = _mondayOfWeek;
    final days = List.generate(7, (i) => monday.add(Duration(days: i)));
    final monthYear = DateFormat('MMMM yyyy').format(_selectedDate);
    final weekDayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(monthYear,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Row(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _goToPreviousWeek,
                  child: const Icon(CupertinoIcons.chevron_left),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _goToNextWeek,
                  child: const Icon(CupertinoIcons.chevron_right),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(7, (i) {
              final day = days[i];
              final isSelected = day.year == _selectedDate.year &&
                  day.month == _selectedDate.month &&
                  day.day == _selectedDate.day;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: GestureDetector(
                  onTap: () => _onDaySelected(day),
                  child: Container(
                    width: 56,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: CupertinoColors.activeBlue,
                            borderRadius: BorderRadius.circular(18),
                          )
                        : null,
                    child: Column(
                      children: [
                        Text(
                          weekDayNames[i],
                          style: TextStyle(
                            color: isSelected
                                ? CupertinoColors.white
                                : CupertinoColors.systemGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isSelected
                                ? CupertinoColors.white
                                : CupertinoColors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
