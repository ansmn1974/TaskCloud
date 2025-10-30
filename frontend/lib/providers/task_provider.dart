import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/task_model.dart';
import '../services/storage_service.dart';
import '../services/local_storage_service.dart';
import '../services/api_service.dart';

/// Provider for managing tasks state with API synchronization.
/// 
/// Uses a hybrid approach:
/// - Local storage for offline support and quick access
/// - API service for server synchronization
/// - Optimistic updates for better UX
class TaskProvider extends ChangeNotifier {
  final StorageService _storage;
  final ApiService _api;
  final List<Task> _tasks = <Task>[];
  bool _isLoading = false;
  String? _error;
  bool _isOnline = true;

  TaskProvider({StorageService? storage, ApiService? api})
      : _storage = storage ?? LocalStorageService.instance,
        _api = api ?? ApiService();

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOnline => _isOnline;

  /// Loads tasks from both API and local storage.
  /// Tries API first, falls back to local storage if offline.
  Future<void> loadFromStorage() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to fetch from API
      final apiTasks = await _api.fetchTasks();
      _tasks
        ..clear()
        ..addAll(apiTasks);
      _isOnline = true;
      
      // Save to local storage for offline access
      await _storage.saveTasks(_tasks);
    } catch (e) {
      // Fallback to local storage if API fails
      _isOnline = false;
      final localTasks = await _storage.loadTasks();
      _tasks
        ..clear()
        ..addAll(localTasks);
      _error = 'Offline: ${e.toString()}';
      if (kDebugMode) {
        print('API connection error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _save() async {
    await _storage.saveTasks(_tasks);
  }

  /// Adds a new task with optimistic update.
  Future<void> addTask(Task task) async {
    // Optimistic update
    _tasks.add(task);
    notifyListeners();

    try {
      // Sync with API
      final createdTask = await _api.createTask(task);
      
      // Replace local task with server version (has server-generated ID if needed)
      final idx = _tasks.indexWhere((t) => t.id == task.id);
      if (idx != -1) {
        _tasks[idx] = createdTask;
      }
      await _save();
      _isOnline = true;
      _error = null;
    } catch (e) {
      // Keep local task even if API fails
      _isOnline = false;
      _error = 'Task saved locally. Will sync when online.';
      await _save();
    }
    notifyListeners();
  }

  /// Updates an existing task with optimistic update.
  Future<void> updateTask(Task updated) async {
    final idx = _tasks.indexWhere((t) => t.id == updated.id);
    if (idx == -1) return;

    // Optimistic update
    final oldTask = _tasks[idx];
    _tasks[idx] = updated.copyWith(updatedAt: DateTime.now());
    notifyListeners();

    try {
      // Sync with API
      final serverTask = await _api.updateTask(_tasks[idx]);
      _tasks[idx] = serverTask;
      await _save();
      _isOnline = true;
      _error = null;
    } catch (e) {
      // Rollback on failure
      _tasks[idx] = oldTask;
      _isOnline = false;
      _error = 'Failed to update task. Changes not saved.';
      await _save();
    }
    notifyListeners();
  }

  /// Toggles completion state with API sync.
  Future<void> toggleComplete(String id) async {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;

    final t = _tasks[idx];
    final updated = t.copyWith(isCompleted: !t.isCompleted, updatedAt: DateTime.now());
    
    // Optimistic update
    _tasks[idx] = updated;
    notifyListeners();

    try {
      // Sync with API
      final serverTask = await _api.updateTask(updated);
      _tasks[idx] = serverTask;
      await _save();
      _isOnline = true;
      _error = null;
    } catch (e) {
      // Rollback on failure
      _tasks[idx] = t;
      _isOnline = false;
      _error = 'Failed to toggle task. Try again.';
      await _save();
    }
    notifyListeners();
  }

  /// Deletes task with API sync.
  Future<void> deleteTask(String id) async {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;

    // Optimistic delete
    final deletedTask = _tasks.removeAt(idx);
    notifyListeners();

    try {
      // Sync with API
      await _api.deleteTask(id);
      await _save();
      _isOnline = true;
      _error = null;
    } catch (e) {
      // Rollback on failure
      _tasks.insert(idx, deletedTask);
      _isOnline = false;
      _error = 'Failed to delete task. Try again.';
      await _save();
    }
    notifyListeners();
  }

  /// Check API connectivity
  Future<bool> checkConnection() async {
    try {
      _isOnline = await _api.checkHealth();
      notifyListeners();
      return _isOnline;
    } catch (e) {
      _isOnline = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }
}
