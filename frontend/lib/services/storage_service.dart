import 'dart:async';
import '../models/task_model.dart';

/// Abstract storage contract to persist and retrieve tasks.
///
/// We keep this minimal so providers can be tested with in-memory fakes
/// and production uses SharedPreferences or any other backend later.
abstract class StorageService {
  Future<void> saveTasks(List<Task> tasks);
  Future<List<Task>> loadTasks();
  Future<void> clear();
}
