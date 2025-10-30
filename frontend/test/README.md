/// Test Directory Structure
/// 
/// This directory mirrors the lib/ structure for organized testing.
/// 
/// Testing Philosophy:
/// - Follow Test-Driven Development (TDD)
/// - Write tests BEFORE implementing features
/// - Aim for high code coverage (>80%)
/// - Test behavior, not implementation
/// 
/// Test Types:
/// 
/// 1. **Unit Tests** (test/models/, test/services/, test/utils/)
///    - Test individual functions and classes in isolation
///    - Mock external dependencies
///    - Fast execution
///    - Example: test model serialization, validators, formatters
/// 
/// 2. **Widget Tests** (test/widgets/, test/screens/)
///    - Test UI components and user interactions
///    - Verify widgets render correctly
///    - Test user input and gestures
///    - Example: button taps, form validation, navigation
/// 
/// 3. **Integration Tests** (integration_test/)
///    - Test complete user flows
///    - Run on real devices/emulators
///    - Test app as a whole
///    - Example: login flow, create task flow
/// 
/// Directory Mapping:
/// ```
/// lib/models/task_model.dart    → test/models/task_model_test.dart
/// lib/widgets/task_card.dart    → test/widgets/task_card_test.dart
/// lib/services/api_service.dart → test/services/api_service_test.dart
/// lib/utils/validators.dart     → test/utils/validators_test.dart
/// ```
/// 
/// Running Tests:
/// ```bash
/// # Run all tests
/// flutter test
/// 
/// # Run specific test file
/// flutter test test/models/task_model_test.dart
/// 
/// # Run tests with coverage
/// flutter test --coverage
/// 
/// # Run tests in watch mode (rerun on file changes)
/// flutter test --watch
/// ```
/// 
/// Test File Structure:
/// ```dart
/// import 'package:flutter_test/flutter_test.dart';
/// import 'package:taskcloud/models/task_model.dart';
/// 
/// void main() {
///   group('Task Model', () {
///     test('should create a task from JSON', () {
///       // Arrange
///       final json = {
///         'id': '1',
///         'title': 'Test Task',
///         'isCompleted': false,
///       };
///       
///       // Act
///       final task = Task.fromJson(json);
///       
///       // Assert
///       expect(task.id, '1');
///       expect(task.title, 'Test Task');
///       expect(task.isCompleted, false);
///     });
///     
///     test('should convert task to JSON', () {
///       // Arrange
///       final task = Task(
///         id: '1',
///         title: 'Test Task',
///         isCompleted: false,
///       );
///       
///       // Act
///       final json = task.toJson();
///       
///       // Assert
///       expect(json['id'], '1');
///       expect(json['title'], 'Test Task');
///       expect(json['isCompleted'], false);
///     });
///   });
/// }
/// ```
/// 
/// Best Practices:
/// - Use descriptive test names
/// - Follow Arrange-Act-Assert pattern
/// - Test edge cases and error scenarios
/// - Keep tests independent
/// - Use setUp/tearDown for common setup
/// - Mock external dependencies
/// - Test one thing per test
/// 
/// Mocking Example:
/// ```dart
/// import 'package:mockito/mockito.dart';
/// import 'package:mockito/annotations.dart';
/// 
/// @GenerateMocks([ApiService])
/// void main() {
///   late MockApiService mockApiService;
///   late TaskProvider taskProvider;
///   
///   setUp(() {
///     mockApiService = MockApiService();
///     taskProvider = TaskProvider(mockApiService);
///   });
///   
///   test('should fetch tasks successfully', () async {
///     // Arrange
///     final mockTasks = [Task(id: '1', title: 'Test')];
///     when(mockApiService.getTasks()).thenAnswer((_) async => mockTasks);
///     
///     // Act
///     await taskProvider.fetchTasks();
///     
///     // Assert
///     expect(taskProvider.tasks, mockTasks);
///     expect(taskProvider.isLoading, false);
///   });
/// }
/// ```
