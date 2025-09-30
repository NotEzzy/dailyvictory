import 'package:dailyvictory/models/habit.dart';
import 'package:dailyvictory/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final habitStreamProvider = StreamProvider<List<Habit>>((ref) {
  final auth = ref.watch(authProvider);
  final userId = auth.user?.uid;
  if (userId == null) return const Stream.empty();
  return FirebaseFirestore.instance
      .collection('habits')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Habit.fromMap(doc.data())).toList());
});

final habitProvider = StateNotifierProvider<HabitNotifier, AsyncValue<List<Habit>>>((ref) {
  final auth = ref.watch(authProvider);
  return HabitNotifier(ref, auth.user?.uid);
});

class HabitNotifier extends StateNotifier<AsyncValue<List<Habit>>> {
  // Keeping _ref for potential future use with other providers
  final Ref _ref;
  final String? _userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isDisposed = false;

  HabitNotifier(this._ref, this._userId) : super(const AsyncValue.loading()) {
    if (_userId != null) {
      loadHabits();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _updateState(AsyncValue<List<Habit>> newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  Future<void> loadHabits() async {
    if (_userId == null || _isDisposed) return;

    try {
      _updateState(const AsyncValue.loading());
      final snapshot = await _firestore
          .collection('habits')
          .where('userId', isEqualTo: _userId)
          .orderBy('createdAt', descending: true)
          .get();

      if (_isDisposed) return;
      
      final habits = snapshot.docs.map((doc) => Habit.fromMap(doc.data())).toList();
      _updateState(AsyncValue.data(habits));
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _updateState(AsyncValue.error(error, stackTrace));
      }
    }
  }

  Future<void> createHabit(Habit habit) async {
    if (_userId == null || _isDisposed) return;

    try {
      final docRef = _firestore.collection('habits').doc();
      final newHabit = habit.copyWith(
        id: docRef.id,
        userId: _userId,
        createdAt: DateTime.now(),
      );

      await docRef.set(newHabit.toMap());
      if (!_isDisposed) {
        await loadHabits();
      }
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _updateState(AsyncValue.error(error, stackTrace));
      }
    }
  }

  Future<void> updateHabit(Habit habit) async {
    if (_userId == null || _isDisposed) return;

    try {
      await _firestore.collection('habits').doc(habit.id).update(habit.toMap());
      if (!_isDisposed) {
        await loadHabits();
      }
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _updateState(AsyncValue.error(error, stackTrace));
      }
    }
  }

  Future<void> deleteHabit(String habitId) async {
    if (_userId == null || _isDisposed) return;

    try {
      await _firestore.collection('habits').doc(habitId).delete();
      if (!_isDisposed) {
        await loadHabits();
      }
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _updateState(AsyncValue.error(error, stackTrace));
      }
    }
  }

  Future<void> toggleHabitCompletion(String habitId) async {
    if (_userId == null || _isDisposed) return;

    try {
      final habitDoc = await _firestore.collection('habits').doc(habitId).get();
      if (!habitDoc.exists || _isDisposed) return;

      final habit = Habit.fromMap(habitDoc.data()!);
      final now = DateTime.now();
      final lastCompletedDate = habit.lastCompletedAt;

      // Check if the habit was completed today
      final isCompletedToday = lastCompletedDate?.day == now.day &&
          lastCompletedDate?.month == now.month &&
          lastCompletedDate?.year == now.year;

      if (isCompletedToday) {
        // Uncomplete the habit
        await habitDoc.reference.update({
          'lastCompletedAt': null,
          'currentStreak': habit.currentStreak - 1,
        });
      } else {
        // Complete the habit
        await habitDoc.reference.update({
          'lastCompletedAt': now.toIso8601String(),
          'currentStreak': habit.currentStreak + 1,
          'bestStreak': (habit.currentStreak + 1) > (habit.bestStreak ?? 0)
              ? habit.currentStreak + 1
              : habit.bestStreak,
        });
      }

      if (!_isDisposed) {
        await loadHabits();
      }
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _updateState(AsyncValue.error(error, stackTrace));
      }
    }
  }
} 