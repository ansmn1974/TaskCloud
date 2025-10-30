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
  /// Tries API first, merges with local storage to preserve unsaved changes.
  Future<void> loadFromStorage() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Always load from local storage first
    final localTasks = await _storage.loadTasks();

    try {
      // Try to fetch from API
      final apiTasks = await _api.fetchTasks();
      
      // Merge: prefer API tasks, but keep local tasks not in API
      final Map<String, Task> taskMap = {for (var t in localTasks) t.id: t};
      for (var apiTask in apiTasks) {
        taskMap[apiTask.id] = apiTask; // API version takes precedence
      }
      
      _tasks
        ..clear()
        ..addAll(taskMap.values);
      _isOnline = true;
      _error = null;
      
      // Save merged result to local storage
      await _storage.saveTasks(_tasks);
      
      if (kDebugMode) {
        print('Loaded ${apiTasks.length} tasks from server, ${_tasks.length} total after merge');
      }
    } catch (e) {
      // Use local storage if API fails
      _isOnline = false;
      _tasks
        ..clear()
        ..addAll(localTasks);
      _error = 'Offline: Using local data';
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
    await _save();
    notifyListeners();

    try {
      // Sync with API
      final createdTask = await _api.createTask(task);
      
      // Replace local task with server version (has server-generated ID)
      final idx = _tasks.indexWhere((t) => t.id == task.id);
      if (idx != -1) {
        _tasks[idx] = createdTask;
        await _save();
      }
      // Don't change connection status - maintain current state
      if (kDebugMode) {
        print('Task created successfully on server: ${createdTask.id}');
      }
    } catch (e) {
      // Task is already saved locally, just log the error
      if (kDebugMode) {
        print('Failed to sync task to server: $e');
      }
      // Only set offline if we weren't already offline
      if (_isOnline) {
        _isOnline = false;
        _error = 'Task saved locally. Will sync when online.';
        notifyListeners();
      }
    }
  }

  /// Updates an existing task with optimistic update.
  Future<void> updateTask(Task updated) async {
    final idx = _tasks.indexWhere((t) => t.id == updated.id);
    if (idx == -1) return;

    // Optimistic update
    _tasks[idx] = updated.copyWith(updatedAt: DateTime.now());
    await _save();
    notifyListeners();

    try {
      // Sync with API
      final serverTask = await _api.updateTask(_tasks[idx]);
      _tasks[idx] = serverTask;
      await _save();
      if (kDebugMode) {
        print('Task updated successfully on server: ${serverTask.id}');
      }
    } catch (e) {
      // Keep the local change, just log the error
      if (kDebugMode) {
        print('Failed to sync task update to server: $e');
      }
      if (_isOnline) {
        _isOnline = false;
        _error = 'Changes saved locally. Will sync when online.';
        notifyListeners();
      }
    }
  }

  /// Toggles completion state with API sync.
  Future<void> toggleComplete(String id) async {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;

    final t = _tasks[idx];
    final updated = t.copyWith(isCompleted: !t.isCompleted, updatedAt: DateTime.now());
    
    // Optimistic update
    _tasks[idx] = updated;
    await _save();
    notifyListeners();

    try {
      // Sync with API
      final serverTask = await _api.updateTask(updated);
      _tasks[idx] = serverTask;
      await _save();
      if (kDebugMode) {
        print('Task toggle synced successfully: ${serverTask.id}');
      }
    } catch (e) {
      // Keep the local change, just log the error
      if (kDebugMode) {
        print('Failed to sync task toggle to server: $e');
      }
      if (_isOnline) {
        _isOnline = false;
        _error = 'Changes saved locally. Will sync when online.';
        notifyListeners();
      }
    }
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
