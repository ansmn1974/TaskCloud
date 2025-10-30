import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';
import 'storage_service.dart';

/// Local storage implementation backed by SharedPreferences.
class LocalStorageService implements StorageService {
  static const _tasksKey = 'tasks_json';

  LocalStorageService._internal();
  static final LocalStorageService instance = LocalStorageService._internal();

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final list = tasks.map((t) => t.toJson()).toList();
    final jsonStr = jsonEncode(list);
    await prefs.setString(_tasksKey, jsonStr);
  }

  @override
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_tasksKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
  }
}
