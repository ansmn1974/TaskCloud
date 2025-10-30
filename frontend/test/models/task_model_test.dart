import 'package:flutter_test/flutter_test.dart';
import 'package:taskcloud/models/task_model.dart';

/// Test suite for Task Model
/// 
/// This test file follows TDD principles:
/// 1. Write tests first (they will fail)
/// 2. Implement minimal code to pass tests
/// 3. Refactor while keeping tests green
void main() {
  group('Task Model - JSON Serialization', () {
    test('should create a Task from JSON with all fields', () {
      // Arrange
      final json = {
        'id': '123',
        'title': 'Complete Flutter app',
        'description': 'Build the TaskCloud frontend',
        'isCompleted': false,
        'dueDate': '2025-10-30T10:00:00.000Z',
        'priority': 'high',
        'categoryId': 'work',
      };

      // Act
      final task = Task.fromJson(json);

      // Assert
      expect(task.id, '123');
      expect(task.title, 'Complete Flutter app');
      expect(task.description, 'Build the TaskCloud frontend');
      expect(task.isCompleted, false);
      expect(task.dueDate, isNotNull);
      expect(task.priority, 'high');
      expect(task.categoryId, 'work');
    });

    test('should create a Task from JSON with minimal fields', () {
      // Arrange
      final json = {
        'id': '456',
        'title': 'Minimal task',
        'isCompleted': false,
      };

      // Act
      final task = Task.fromJson(json);

      // Assert
      expect(task.id, '456');
      expect(task.title, 'Minimal task');
      expect(task.isCompleted, false);
      expect(task.description, isNull);
      expect(task.dueDate, isNull);
      expect(task.priority, isNull);
      expect(task.categoryId, isNull);
    });

    test('should convert Task to JSON', () {
      // Arrange
      final task = Task(
        id: '789',
        title: 'Test task',
        description: 'Testing JSON conversion',
        isCompleted: true,
        dueDate: DateTime.parse('2025-10-30T10:00:00.000Z'),
        priority: 'medium',
        categoryId: 'personal',
      );

      // Act
      final json = task.toJson();

      // Assert
      expect(json['id'], '789');
      expect(json['title'], 'Test task');
      expect(json['description'], 'Testing JSON conversion');
      expect(json['isCompleted'], true);
      expect(json['dueDate'], isNotNull);
      expect(json['priority'], 'medium');
      expect(json['categoryId'], 'personal');
    });

    test('should handle null values in toJson', () {
      // Arrange
      final task = Task(
        id: '101',
        title: 'Task with nulls',
        isCompleted: false,
      );

      // Act
      final json = task.toJson();

      // Assert
      expect(json['id'], '101');
      expect(json['title'], 'Task with nulls');
      expect(json['isCompleted'], false);
      expect(json['description'], isNull);
      expect(json['dueDate'], isNull);
    });
  });

  group('Task Model - Equality and HashCode', () {
    test('should be equal when all properties match', () {
      // Arrange
      final task1 = Task(
        id: '1',
        title: 'Same task',
        isCompleted: false,
      );
      final task2 = Task(
        id: '1',
        title: 'Same task',
        isCompleted: false,
      );

      // Act & Assert
      expect(task1, equals(task2));
      expect(task1.hashCode, equals(task2.hashCode));
    });

    test('should not be equal when properties differ', () {
      // Arrange
      final task1 = Task(
        id: '1',
        title: 'Task one',
        isCompleted: false,
      );
      final task2 = Task(
        id: '2',
        title: 'Task two',
        isCompleted: false,
      );

      // Act & Assert
      expect(task1, isNot(equals(task2)));
    });

    test('should not be equal when completion status differs', () {
      // Arrange
      final task1 = Task(
        id: '1',
        title: 'Same task',
        isCompleted: false,
      );
      final task2 = Task(
        id: '1',
        title: 'Same task',
        isCompleted: true,
      );

      // Act & Assert
      expect(task1, isNot(equals(task2)));
    });
  });

  group('Task Model - CopyWith', () {
    test('should create a copy with updated title', () {
      // Arrange
      final original = Task(
        id: '1',
        title: 'Original title',
        isCompleted: false,
      );

      // Act
      final updated = original.copyWith(title: 'Updated title');

      // Assert
      expect(updated.id, '1');
      expect(updated.title, 'Updated title');
      expect(updated.isCompleted, false);
      expect(original.title, 'Original title'); // Original unchanged
    });

    test('should create a copy with updated completion status', () {
      // Arrange
      final original = Task(
        id: '1',
        title: 'Task',
        isCompleted: false,
      );

      // Act
      final updated = original.copyWith(isCompleted: true);

      // Assert
      expect(updated.isCompleted, true);
      expect(original.isCompleted, false); // Original unchanged
    });

    test('should create a copy with multiple updated fields', () {
      // Arrange
      final original = Task(
        id: '1',
        title: 'Original',
        description: 'Original description',
        isCompleted: false,
        priority: 'low',
      );

      // Act
      final updated = original.copyWith(
        title: 'Updated',
        description: 'Updated description',
        priority: 'high',
      );

      // Assert
      expect(updated.title, 'Updated');
      expect(updated.description, 'Updated description');
      expect(updated.priority, 'high');
      expect(updated.isCompleted, false); // Unchanged field preserved
    });

    test('should create a copy without changes when no parameters provided', () {
      // Arrange
      final original = Task(
        id: '1',
        title: 'Task',
        isCompleted: false,
      );

      // Act
      final copy = original.copyWith();

      // Assert
      expect(copy.id, original.id);
      expect(copy.title, original.title);
      expect(copy.isCompleted, original.isCompleted);
    });
  });

  group('Task Model - Validation', () {
    test('should not allow empty title', () {
      // Act & Assert
      expect(
        () => Task(id: '1', title: '', isCompleted: false),
        throwsAssertionError,
      );
    });

    test('should not allow null id', () {
      // Act & Assert - This will be enforced by Dart's null safety
      // The test documents the expected behavior
    });

    test('should validate title length constraints', () {
      // Arrange - title longer than max allowed (e.g., 200 chars)
      final longTitle = 'a' * 201;

      // Act & Assert
      expect(
        () => Task(id: '1', title: longTitle, isCompleted: false),
        throwsAssertionError,
      );
    });
  });

  group('Task Model - Helper Methods', () {
    test('should identify overdue tasks', () {
      // Arrange
      final overdueTask = Task(
        id: '1',
        title: 'Overdue task',
        isCompleted: false,
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      );
      final futureTask = Task(
        id: '2',
        title: 'Future task',
        isCompleted: false,
        dueDate: DateTime.now().add(const Duration(days: 1)),
      );

      // Act & Assert
      expect(overdueTask.isOverdue, true);
      expect(futureTask.isOverdue, false);
    });

    test('should not mark completed tasks as overdue', () {
      // Arrange
      final completedOverdueTask = Task(
        id: '1',
        title: 'Completed task',
        isCompleted: true,
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      // Act & Assert
      expect(completedOverdueTask.isOverdue, false);
    });

    test('should return false for isOverdue when no due date', () {
      // Arrange
      final taskWithoutDueDate = Task(
        id: '1',
        title: 'Task without due date',
        isCompleted: false,
      );

      // Act & Assert
      expect(taskWithoutDueDate.isOverdue, false);
    });
  });

  group('Task Model - Edge Cases', () {
    test('should handle very long descriptions', () {
      // Arrange
      final longDescription = 'a' * 1000;
      final json = {
        'id': '1',
        'title': 'Task',
        'description': longDescription,
        'isCompleted': false,
      };

      // Act
      final task = Task.fromJson(json);

      // Assert
      expect(task.description, longDescription);
      expect(task.description!.length, 1000);
    });

    test('should handle special characters in title and description', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Task with émojis 🚀 and spëcial çhars!',
        'description': 'Description with "quotes" and \'apostrophes\'',
        'isCompleted': false,
      };

      // Act
      final task = Task.fromJson(json);

      // Assert
      expect(task.title, contains('🚀'));
      expect(task.description, contains('"quotes"'));
    });

    test('should handle invalid date format gracefully', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Task',
        'isCompleted': false,
        'dueDate': 'invalid-date-format',
      };

      // Act & Assert - Should throw FormatException
      expect(() => Task.fromJson(json), throwsFormatException);
    });
  });
}
