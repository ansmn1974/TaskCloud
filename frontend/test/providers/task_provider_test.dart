import 'package:flutter_test/flutter_test.dart';

import 'package:taskcloud/models/task_model.dart';
import 'package:taskcloud/providers/task_provider.dart';
import 'package:taskcloud/services/storage_service.dart';

class InMemoryStorage implements StorageService {
  List<Task> _cache = [];
  @override
  Future<void> clear() async {
    _cache = [];
  }

  @override
  Future<List<Task>> loadTasks() async {
    return List<Task>.from(_cache);
  }

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    _cache = List<Task>.from(tasks);
  }
}

void main() {
  group('TaskProvider - Basic CRUD & Persistence', () {
    late InMemoryStorage storage;
    late TaskProvider provider;

    setUp(() {
      storage = InMemoryStorage();
      provider = TaskProvider(storage: storage);
    });

    test('addTask increases list and persists', () async {
      final task = Task(id: '1', title: 'Test', isCompleted: false);
      await provider.addTask(task);

      expect(provider.tasks.length, 1);
      final persisted = await storage.loadTasks();
      expect(persisted.length, 1);
      expect(persisted.first.title, 'Test');
    });

    test('toggleComplete flips completion', () async {
      final task = Task(id: '1', title: 'A', isCompleted: false);
      await provider.addTask(task);
      await provider.toggleComplete('1');
      expect(provider.tasks.first.isCompleted, true);
      await provider.toggleComplete('1');
      expect(provider.tasks.first.isCompleted, false);
    });

    test('updateTask updates fields', () async {
      final task = Task(id: '1', title: 'A', isCompleted: false);
      await provider.addTask(task);
      final updated = task.copyWith(title: 'B');
      await provider.updateTask(updated);
      expect(provider.tasks.first.title, 'B');
    });

    test('deleteTask removes task', () async {
      final task = Task(id: '1', title: 'A', isCompleted: false);
      await provider.addTask(task);
      await provider.deleteTask('1');
      expect(provider.tasks, isEmpty);
    });

    test('loadFromStorage keeps tasks even if >1h old (server-only expiration)', () async {
      final fresh = Task(id: 'a', title: 'fresh', isCompleted: false, createdAt: DateTime.now());
      final expired = Task(id: 'b', title: 'old', isCompleted: false, createdAt: DateTime.now().subtract(const Duration(hours: 2)));

      await storage.saveTasks([fresh, expired]);
      await provider.loadFromStorage();

      expect(provider.tasks.length, 2);
      expect(provider.tasks.any((t) => t.id == 'a'), isTrue);
      expect(provider.tasks.any((t) => t.id == 'b'), isTrue);
    });
  });
}
