import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/task_model.dart';
import '../services/storage_service.dart';
import '../services/local_storage_service.dart';

/// Provider for managing tasks state and persistence.
class TaskProvider extends ChangeNotifier {
  final StorageService _storage;
  final List<Task> _tasks = <Task>[];

  TaskProvider({StorageService? storage}) : _storage = storage ?? LocalStorageService.instance;

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  /// Loads tasks from storage. Keeps tasks even if past 1 hour, since
  /// auto-deletion is a server-only policy. Local storage retains tasks
  /// until the user deletes them.
  Future<void> loadFromStorage() async {
    final loaded = await _storage.loadTasks();
    _tasks
      ..clear()
      ..addAll(loaded);
    notifyListeners();
  }

  Future<void> _save() async {
    await _storage.saveTasks(_tasks);
  }

  /// Adds a new task.
  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _save();
    notifyListeners();
  }

  /// Updates an existing task by ID.
  Future<void> updateTask(Task updated) async {
    final idx = _tasks.indexWhere((t) => t.id == updated.id);
    if (idx == -1) return;
    _tasks[idx] = updated.copyWith(updatedAt: DateTime.now());
    await _save();
    notifyListeners();
  }

  /// Toggles completion state by task ID.
  Future<void> toggleComplete(String id) async {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    final t = _tasks[idx];
    _tasks[idx] = t.copyWith(isCompleted: !t.isCompleted, updatedAt: DateTime.now());
    await _save();
    notifyListeners();
  }

  /// Deletes task by ID.
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _save();
    notifyListeners();
  }

  /// No auto-deletion locally; server enforces session expiration.
}
