import 'package:dailyvictory/models/habit.dart';
import 'package:dailyvictory/utils/colors.dart';
import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final bool showProgress;

  const HabitCard({
    super.key,
    required this.habit,
    this.onTap,
    this.onComplete,
    this.showProgress = true,
  });

  Color _getCategoryColor() {
    switch (habit.category) {
      case HabitCategory.health:
        return AppColors.health;
      case HabitCategory.mindfulness:
        return AppColors.mindfulness;
      case HabitCategory.productivity:
        return AppColors.productivity;
      case HabitCategory.fitness:
        return AppColors.fitness;
      case HabitCategory.learning:
        return AppColors.learning;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppColors.surfaceVariant,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(),
                      color: categoryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (habit.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            habit.description!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (onComplete != null)
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      color: AppColors.success,
                      onPressed: onComplete,
                    ),
                ],
              ),
              if (showProgress) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: categoryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${habit.currentStreak} day streak',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Best: ${habit.bestStreak}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: habit.currentStreak / (habit.bestStreak ?? 7),
                  backgroundColor: categoryColor.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (habit.category) {
      case HabitCategory.health:
        return Icons.favorite;
      case HabitCategory.mindfulness:
        return Icons.self_improvement;
      case HabitCategory.productivity:
        return Icons.lightbulb;
      case HabitCategory.fitness:
        return Icons.fitness_center;
      case HabitCategory.learning:
        return Icons.school;
      default:
        return Icons.star;
    }
  }
}
