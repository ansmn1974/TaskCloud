/// Providers Module
/// 
/// This directory contains state management logic using Provider/Riverpod.
/// 
/// Responsibilities:
/// - Manage application state
/// - Coordinate between services and UI
/// - Implement business logic
/// - Handle loading and error states
/// - Notify listeners of state changes
/// - Cache data to reduce API calls
/// 
/// Key Providers:
/// 
/// 1. **task_provider.dart**: Task state management
///    - List of all tasks
///    - CRUD operations
///    - Filtering and sorting
///    - Loading states
/// 
/// 2. **auth_provider.dart**: Authentication state
///    - Current user information
///    - Login/logout actions
///    - Token management
///    - Authentication status
/// 
/// 3. **theme_provider.dart**: App theme state
///    - Light/dark mode toggle
///    - Theme preferences persistence
/// 
/// Example Structure (using Provider):
/// ```dart
/// class TaskProvider extends ChangeNotifier {
///   final ApiService _apiService;
///   
///   List<Task> _tasks = [];
///   bool _isLoading = false;
///   String? _error;
///   
///   // Getters
///   List<Task> get tasks => _tasks;
///   bool get isLoading => _isLoading;
///   String? get error => _error;
///   
///   List<Task> get completedTasks => 
///     _tasks.where((task) => task.isCompleted).toList();
///   
///   List<Task> get pendingTasks => 
///     _tasks.where((task) => !task.isCompleted).toList();
///   
///   TaskProvider(this._apiService);
///   
///   /// Fetch all tasks from the server
///   Future<void> fetchTasks() async {
///     _isLoading = true;
///     _error = null;
///     notifyListeners();
///     
///     try {
///       _tasks = await _apiService.getTasks();
///       _isLoading = false;
///       notifyListeners();
///     } catch (e) {
///       _error = e.toString();
///       _isLoading = false;
///       notifyListeners();
///     }
///   }
///   
///   /// Create a new task
///   Future<void> createTask(Task task) async {
///     try {
///       final newTask = await _apiService.createTask(task);
///       _tasks.add(newTask);
///       notifyListeners();
///     } catch (e) {
///       _error = e.toString();
///       notifyListeners();
///       rethrow;
///     }
///   }
///   
///   /// Update a task
///   Future<void> updateTask(Task task) async {
///     try {
///       final updatedTask = await _apiService.updateTask(task);
///       final index = _tasks.indexWhere((t) => t.id == task.id);
///       if (index != -1) {
///         _tasks[index] = updatedTask;
///         notifyListeners();
///       }
///     } catch (e) {
///       _error = e.toString();
///       notifyListeners();
///       rethrow;
///     }
///   }
///   
///   /// Delete a task
///   Future<void> deleteTask(String taskId) async {
///     try {
///       await _apiService.deleteTask(taskId);
///       _tasks.removeWhere((t) => t.id == taskId);
///       notifyListeners();
///     } catch (e) {
///       _error = e.toString();
///       notifyListeners();
///       rethrow;
///     }
///   }
///   
///   /// Toggle task completion status
///   Future<void> toggleTaskCompletion(Task task) async {
///     final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
///     await updateTask(updatedTask);
///   }
/// }
/// ```
/// 
/// Using Providers in Widgets:
/// ```dart
/// // In main.dart, wrap app with providers
/// MultiProvider(
///   providers: [
///     ChangeNotifierProvider(create: (_) => TaskProvider(ApiService())),
///     ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
///   ],
///   child: MyApp(),
/// )
/// 
/// // In a widget
/// Consumer<TaskProvider>(
///   builder: (context, taskProvider, child) {
///     if (taskProvider.isLoading) {
///       return CircularProgressIndicator();
///     }
///     return ListView(
///       children: taskProvider.tasks.map((task) => TaskCard(task: task)).toList(),
///     );
///   },
/// )
/// ```
/// 
/// Best Practices:
/// - Keep providers focused (Single Responsibility)
/// - Always call notifyListeners() after state changes
/// - Handle loading and error states explicitly
/// - Use immutable data structures
/// - Avoid business logic in widgets
/// - Cache data when appropriate
/// 
/// Testing:
/// - Test state changes
/// - Test error handling
/// - Test data transformations
/// - Mock services in provider tests
/// - Verify notifyListeners is called
