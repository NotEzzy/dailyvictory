import 'package:dailyvictory/models/bad_habit.dart';
import 'package:dailyvictory/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final badHabitStreamProvider = StreamProvider<List<BadHabit>>((ref) {
  final auth = ref.watch(authProvider);
  final userId = auth.user?.uid;
  if (userId == null) return const Stream.empty();
  return FirebaseFirestore.instance
      .collection('bad_habits')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => BadHabit.fromMap(doc.data())).toList());
});

final badHabitProvider = StateNotifierProvider<BadHabitNotifier, AsyncValue<List<BadHabit>>>((ref) {
  final auth = ref.watch(authProvider);
  return BadHabitNotifier(ref, auth.user?.uid);
});

class BadHabitNotifier extends StateNotifier<AsyncValue<List<BadHabit>>> {
  final String? _userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isDisposed = false;

  BadHabitNotifier(Ref ref, this._userId) : super(const AsyncValue.loading()) {
    if (_userId != null) {
      loadBadHabits();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _updateState(AsyncValue<List<BadHabit>> newState) {
    if (!_isDisposed) {
      state = newState;
    }
  }

  Future<void> loadBadHabits() async {
    if (_userId == null || _isDisposed) return;
    try {
      _updateState(const AsyncValue.loading());
      final snapshot = await _firestore
          .collection('bad_habits')
          .where('userId', isEqualTo: _userId)
          .orderBy('createdAt', descending: true)
          .get();
      if (_isDisposed) return;
      final badHabits = snapshot.docs.map((doc) => BadHabit.fromMap(doc.data())).toList();
      _updateState(AsyncValue.data(badHabits));
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _updateState(AsyncValue.error(error, stackTrace));
      }
    }
  }

  Future<void> createBadHabit(BadHabit badHabit) async {
    if (_userId == null || _isDisposed) return;
    try {
      final docRef = _firestore.collection('bad_habits').doc();
      final newBadHabit = badHabit.copyWith(
        id: docRef.id,
        userId: _userId,
        createdAt: DateTime.now(),
      );
      await docRef.set(newBadHabit.toMap());
      if (!_isDisposed) {
        await loadBadHabits();
      }
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _updateState(AsyncValue.error(error, stackTrace));
      }
    }
  }

  Future<void> updateBadHabit(BadHabit badHabit) async {
    if (_userId == null || _isDisposed) return;
    try {
      await _firestore.collection('bad_habits').doc(badHabit.id).update(badHabit.toMap());
      if (!_isDisposed) {
        await loadBadHabits();
      }
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _updateState(AsyncValue.error(error, stackTrace));
      }
    }
  }

  Future<void> deleteBadHabit(String badHabitId) async {
    if (_userId == null || _isDisposed) return;
    try {
      await _firestore.collection('bad_habits').doc(badHabitId).delete();
      if (!_isDisposed) {
        await loadBadHabits();
      }
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _updateState(AsyncValue.error(error, stackTrace));
      }
    }
  }

  Future<void> markSlip(String badHabitId) async {
    if (_userId == null || _isDisposed) return;
    try {
      final badHabitDoc = await _firestore.collection('bad_habits').doc(badHabitId).get();
      if (!badHabitDoc.exists || _isDisposed) return;
      final badHabit = BadHabit.fromMap(badHabitDoc.data()!);
      final now = DateTime.now();
      final lastSlipDate = badHabit.lastSlipAt;
      final isSlipToday = lastSlipDate?.day == now.day &&
          lastSlipDate?.month == now.month &&
          lastSlipDate?.year == now.year;
      if (isSlipToday) {
        // Unmark slip
        await badHabitDoc.reference.update({
          'lastSlipAt': null,
          'daysAvoided': badHabit.daysAvoided - 1,
        });
      } else {
        // Mark slip
        await badHabitDoc.reference.update({
          'lastSlipAt': now.toIso8601String(),
          'daysAvoided': 0,
          'bestStreak': badHabit.daysAvoided > badHabit.bestStreak ? badHabit.daysAvoided : badHabit.bestStreak,
        });
      }
      if (!_isDisposed) {
        await loadBadHabits();
      }
    } catch (error, stackTrace) {
      if (!_isDisposed) {
        _updateState(AsyncValue.error(error, stackTrace));
      }
    }
  }
}
