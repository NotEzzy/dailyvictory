import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bad_habit_provider.dart';
import 'add_bad_habit_screen.dart';

class BadHabitsDashboardScreen extends ConsumerWidget {
  const BadHabitsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badHabitState = ref.watch(badHabitStreamProvider);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Break Bad Habits'),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            badHabitState.when(
              data: (badHabits) {
                if (badHabits.isEmpty) {
                  return const Center(
                    child: Text(
                      'No bad habits yet. Tap + to add one!',
                      style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 18),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: badHabits.length,
                  itemBuilder: (context, index) {
                    final badHabit = badHabits[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          // TODO: Show details or allow marking slip
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      badHabit.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: CupertinoColors.black,
                                      ),
                                    ),
                                    if (badHabit.description != null && badHabit.description!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          badHabit.description!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: CupertinoColors.systemGrey,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Avoided: 	${badHabit.daysAvoided}d',
                                    style: const TextStyle(fontSize: 14, color: CupertinoColors.activeGreen),
                                  ),
                                  Text(
                                    'Best: ${badHabit.bestStreak}d',
                                    style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: const Text('+'),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (_) => const AddBadHabitScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
