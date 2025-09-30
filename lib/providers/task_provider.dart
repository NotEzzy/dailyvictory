import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Task model
enum TaskPriority { low, medium, high }
enum TaskStatus { pending, inProgress, completed, cancelled }

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final DateTime? dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final String userId;
  final int estimatedDuration;
  final List<String> tags;
  final bool isArchived;
  final Map<String, dynamic> metadata;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.dueDate,
    required this.priority,
    required this.status,
    required this.userId,
    this.estimatedDuration = 25,
    this.tags = const [],
    this.isArchived = false,
    this.metadata = const {},
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      completedAt: map['completedAt'] != null 
          ? (map['completedAt'] as Timestamp).toDate() 
          : null,
      dueDate: map['dueDate'] != null 
          ? (map['dueDate'] as Timestamp).toDate() 
          : null,
      priority: TaskPriority.values.firstWhere(
        (e) => e.toString() == map['priority'],
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => TaskStatus.pending,
      ),
      userId: map['userId'] as String,
      estimatedDuration: map['estimatedDuration'] as int? ?? 25,
      tags: List<String>.from(map['tags'] ?? []),
      isArchived: map['isArchived'] as bool? ?? false,
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'priority': priority.toString(),
      'status': status.toString(),
      'userId': userId,
      'estimatedDuration': estimatedDuration,
      'tags': tags,
      'isArchived': isArchived,
      'metadata': metadata,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
    String? userId,
    int? estimatedDuration,
    List<String>? tags,
    bool? isArchived,
    Map<String, dynamic>? metadata,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      tags: tags ?? this.tags,
      isArchived: isArchived ?? this.isArchived,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Task provider
final taskProvider = StateNotifierProvider<TaskNotifier, AsyncValue<List<Task>>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TaskNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    final user = FirebaseFirestore.instance.collection('users').doc('current_user_id');
    _firestore
        .collection('tasks')
        .where('userId', isEqualTo: user.id)
        .snapshots()
        .listen((snapshot) {
      try {
        final tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
        state = AsyncValue.data(tasks);
      } catch (e, st) {
        state = AsyncValue.error(e, st);
      }
    });
  }

  Future<void> createTask(Task task) async {
    try {
      await _firestore.collection('tasks').doc(task.id).set(task.toMap());
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _firestore.collection('tasks').doc(task.id).update(task.toMap());
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Future<void> completeTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'status': TaskStatus.completed.toString().split('.').last,
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to complete task: $e');
    }
  }
} 