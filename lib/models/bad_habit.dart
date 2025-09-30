import 'package:flutter/material.dart' show TimeOfDay;

class BadHabit {
  final String id;
  final String title;
  final String? description;
  final String userId;
  final DateTime createdAt;
  final int daysAvoided;
  final int bestStreak;
  final DateTime? lastSlipAt;
  final String frequency;
  final TimeOfDay reminderTime;

  const BadHabit({
    required this.id,
    required this.title,
    this.description,
    required this.userId,
    required this.createdAt,
    this.daysAvoided = 0,
    this.bestStreak = 0,
    this.lastSlipAt,
    required this.frequency,
    required this.reminderTime,
  });

  BadHabit copyWith({
    String? id,
    String? title,
    String? description,
    String? userId,
    DateTime? createdAt,
    int? daysAvoided,
    int? bestStreak,
    DateTime? lastSlipAt,
    String? frequency,
    TimeOfDay? reminderTime,
  }) {
    return BadHabit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      daysAvoided: daysAvoided ?? this.daysAvoided,
      bestStreak: bestStreak ?? this.bestStreak,
      lastSlipAt: lastSlipAt ?? this.lastSlipAt,
      frequency: frequency ?? this.frequency,
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
      'daysAvoided': daysAvoided,
      'bestStreak': bestStreak,
      'lastSlipAt': lastSlipAt?.toIso8601String(),
      'frequency': frequency,
      'reminderTime': '${reminderTime.hour}:${reminderTime.minute}',
    };
  }

  factory BadHabit.fromMap(Map<String, dynamic> map) {
    return BadHabit(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString(),
      userId: map['userId']?.toString() ?? '',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'].toString())
          : DateTime.now(),
      daysAvoided: (map['daysAvoided'] as num?)?.toInt() ?? 0,
      bestStreak: (map['bestStreak'] as num?)?.toInt() ?? 0,
      lastSlipAt: map['lastSlipAt'] != null
          ? DateTime.parse(map['lastSlipAt'].toString())
          : null,
      frequency: map['frequency']?.toString() ?? 'daily',
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
