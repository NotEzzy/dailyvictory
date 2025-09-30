import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Screen tracking
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  // User events
  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  // Task events
  Future<void> logTaskCreated() async {
    await _analytics.logEvent(name: 'task_created');
  }

  Future<void> logTaskCompleted() async {
    await _analytics.logEvent(name: 'task_completed');
  }

  Future<void> logTaskDeleted() async {
    await _analytics.logEvent(name: 'task_deleted');
  }

  // Habit events
  Future<void> logHabitCreated() async {
    await _analytics.logEvent(name: 'habit_created');
  }

  Future<void> logHabitCompleted() async {
    await _analytics.logEvent(name: 'habit_completed');
  }

  Future<void> logHabitStreak(int streak) async {
    await _analytics.logEvent(
      name: 'habit_streak',
      parameters: {'streak': streak},
    );
  }

  // Error tracking
  Future<void> logError(String errorName, String errorDetails) async {
    await _analytics.logEvent(
      name: 'error_occurred',
      parameters: {
        'error_name': errorName,
        'error_details': errorDetails,
      },
    );
  }

  // User properties
  Future<void> setUserProperties({
    required String userId,
    required String userRole,
  }) async {
    await _analytics.setUserId(id: userId);
    await _analytics.setUserProperty(name: 'user_role', value: userRole);
  }
} 