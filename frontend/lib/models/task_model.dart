import 'package:equatable/equatable.dart';

/// Task Model
/// 
/// Represents a single to-do task in the TaskCloud application.
/// 
/// Features:
/// - Immutable data structure for predictable state management
/// - JSON serialization for API communication and local storage
/// - Session-based with 1-hour auto-deletion
/// - Support for completion status, due dates, and priorities
/// 
/// Session Management:
/// Tasks are automatically marked for deletion 1 hour after creation.
/// The `createdAt` timestamp is used to determine task age and cleanup.
class Task extends Equatable {
  /// Unique identifier for the task
  final String id;
  
  /// Task title (required, max 100 characters)
  final String title;
  
  /// Optional detailed description (max 500 characters)
  final String? description;
  
  /// Completion status
  final bool isCompleted;
  
  /// Optional due date for the task
  final DateTime? dueDate;
  
  /// Priority level: 'low', 'medium', 'high'
  final String? priority;
  
  /// Optional category ID for organization
  final String? categoryId;
  
  /// Timestamp when task was created (for session management)
  final DateTime createdAt;
  
  /// Timestamp when task was last updated
  final DateTime updatedAt;

  /// Creates a new Task instance
  /// 
  /// Required parameters:
  /// - [id]: Unique identifier
  /// - [title]: Task title (must not be empty, max 100 chars)
  /// - [isCompleted]: Completion status
  /// 
  /// Optional parameters:
  /// - [description]: Detailed task description
  /// - [dueDate]: When the task is due
  /// - [priority]: Priority level
  /// - [categoryId]: Category for organization
  /// - [createdAt]: Creation timestamp (defaults to now)
  /// - [updatedAt]: Last update timestamp (defaults to now)
  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.description,
    this.dueDate,
    this.priority,
    this.categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        assert(title.isNotEmpty, 'Task title cannot be empty'),
        assert(title.length <= 200, 'Task title must be 200 characters or less');

  /// Creates a Task from JSON data
  /// 
  /// Used for:
  /// - API response deserialization
  /// - Local storage retrieval
  /// - State restoration
  /// 
  /// Throws [FormatException] if date strings are invalid.
  factory Task.fromJson(Map<String, dynamic> json) {
    // Accept both camelCase (local storage) and snake_case (API) keys
    T? _get<T>(String camel, String snake) {
      final v = json.containsKey(camel) ? json[camel] : json[snake];
      return v is T ? v : null;
    }

    final String id = (json['id'] ?? '') as String;
    final String title = (json['title'] ?? '') as String;
    final String? description = _get<String>('description', 'description');
    final bool isCompleted = (_get<bool>('isCompleted', 'is_completed')) ?? false;
    final String? dueRaw = _get<String>('dueDate', 'due_date');
    final DateTime? dueDate = (dueRaw != null && dueRaw.isNotEmpty)
        ? DateTime.parse(dueRaw)
        : null;
    final String? priority = _get<String>('priority', 'priority');
    final String? categoryId = _get<String>('categoryId', 'category_id');
    final String? createdRaw = _get<String>('createdAt', 'created_at');
    final String? updatedRaw = _get<String>('updatedAt', 'updated_at');

    return Task(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      dueDate: dueDate,
      priority: priority,
      categoryId: categoryId,
      createdAt: createdRaw != null ? DateTime.parse(createdRaw) : null,
      updatedAt: updatedRaw != null ? DateTime.parse(updatedRaw) : null,
    );
  }

  /// Converts Task to JSON format
  /// 
  /// Used for:
  /// - API request serialization
  /// - Local storage persistence
  /// - State serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
      'categoryId': categoryId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Creates a copy of this task with updated fields
  /// 
  /// This is the preferred way to update tasks since they are immutable.
  /// Only specified fields will be updated; others remain unchanged.
  /// 
  /// Example:
  /// ```dart
  /// final updatedTask = task.copyWith(
  ///   isCompleted: true,
  ///   updatedAt: DateTime.now(),
  /// );
  /// ```
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    String? priority,
    String? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Checks if this task is overdue
  /// 
  /// A task is considered overdue if:
  /// - It has a due date
  /// - The due date is in the past
  /// - It is not completed
  /// 
  /// Returns `false` if task has no due date or is already completed.
  bool get isOverdue {
    if (dueDate == null || isCompleted) {
      return false;
    }
    return dueDate!.isBefore(DateTime.now());
  }

  /// Checks if this task should be deleted (older than 1 hour)
  /// 
  /// Session Management:
  /// Tasks are automatically deleted after 1 hour from creation.
  /// This implements the requirement for session-based task storage.
  /// 
  /// Returns `true` if task is older than 1 hour.
  bool get shouldBeDeleted {
    final now = DateTime.now();
    final age = now.difference(createdAt);
    return age.inHours >= 1;
  }

  /// Returns the remaining time before this task expires (in minutes)
  /// 
  /// Useful for displaying countdown timers or warnings.
  /// Returns 0 if task has already expired.
  int get minutesUntilExpiration {
    final now = DateTime.now();
    final expirationTime = createdAt.add(const Duration(hours: 1));
    final remaining = expirationTime.difference(now);
    
    if (remaining.isNegative) {
      return 0;
    }
    
    return remaining.inMinutes;
  }

  /// Returns a human-readable expiration status
  /// 
  /// Examples:
  /// - "Expires in 45 minutes"
  /// - "Expires in 5 minutes"
  /// - "Expired"
  String get expirationStatus {
    final minutes = minutesUntilExpiration;
    
    if (minutes == 0) {
      return 'Expired';
    } else if (minutes == 1) {
      return 'Expires in 1 minute';
    } else {
      return 'Expires in $minutes minutes';
    }
  }

  /// Equatable props for value comparison
  /// 
  /// Two tasks are considered equal if all their properties match.
  /// This enables efficient state comparison in Provider.
  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        dueDate,
        priority,
        categoryId,
        createdAt,
        updatedAt,
      ];

  /// String representation for debugging
  @override
  String toString() {
    return 'Task(id: $id, title: $title, isCompleted: $isCompleted, '
        'dueDate: $dueDate, priority: $priority, '
        'createdAt: $createdAt, minutesUntilExpiration: $minutesUntilExpiration)';
  }
}
