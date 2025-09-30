import 'package:flutter/material.dart' show TimeOfDay;

enum HabitCategory {
  health,
  mindfulness,
  productivity,
  fitness,
  learning,
  other
}

class Habit {
  final String id;
  final String title;
  final String? description;
  final String userId;
  final DateTime createdAt;
  final HabitCategory category;
  final int currentStreak;
  final int? bestStreak;
  final DateTime? lastCompletedAt;
  final String frequency;
  final int duration; // Duration in minutes
  final TimeOfDay reminderTime;

  const Habit({
    required this.id,
    required this.title,
    this.description,
    required this.userId,
    required this.createdAt,
    this.category = HabitCategory.other,
    this.currentStreak = 0,
    this.bestStreak,
    this.lastCompletedAt,
    required this.frequency,
    required this.duration,
    required this.reminderTime,
  });

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    String? userId,
    DateTime? createdAt,
    HabitCategory? category,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastCompletedAt,
    String? frequency,
    int? duration,
    TimeOfDay? reminderTime,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'category': category.toString().split('.').last,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
      'frequency': frequency,
      'duration': duration,
      'reminderTime': '${reminderTime.hour}:${reminderTime.minute}',
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString(),
      userId: map['userId']?.toString() ?? '',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'].toString())
          : DateTime.now(),
      category: map['category'] != null
          ? HabitCategory.values.firstWhere(
              (e) => e.toString().split('.').last == map['category'].toString(),
              orElse: () => HabitCategory.other,
            )
          : HabitCategory.other,
      currentStreak: (map['currentStreak'] as num?)?.toInt() ?? 0,
      bestStreak: (map['bestStreak'] as num?)?.toInt(),
      lastCompletedAt: map['lastCompletedAt'] != null
          ? DateTime.parse(map['lastCompletedAt'].toString())
          : null,
      frequency: map['frequency']?.toString() ?? 'daily',
      duration: (map['duration'] as num?)?.toInt() ?? 10,
      reminderTime: _parseTimeOfDay(map['reminderTime']?.toString() ?? '9:00'),
    );
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    try {
      final parts = time.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (e) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }
} 