/// Screens Module
/// 
/// This directory contains full-screen pages (routes) of the application.
/// 
/// Responsibilities:
/// - Define complete screen layouts
/// - Coordinate multiple widgets
/// - Handle screen-level navigation
/// - Manage screen-specific state
/// - Connect to providers/services
/// 
/// Main Screens:
/// 
/// 1. **home_screen.dart**: Main task list view
///    - Display all tasks
///    - Filter and search functionality
///    - Navigate to task details
///    - Pull-to-refresh
/// 
/// 2. **task_detail_screen.dart**: Single task view
///    - View task details
///    - Edit task information
///    - Delete task
///    - Mark as complete/incomplete
/// 
/// 3. **login_screen.dart**: User authentication
///    - Login form
///    - Register option
///    - Password recovery
/// 
/// 4. **settings_screen.dart**: App settings
///    - User preferences
///    - Theme selection
///    - Logout option
/// 
/// 5. **add_task_screen.dart**: Create new task
///    - Task creation form
///    - Field validation
///    - Save and cancel actions
/// 
/// Screen Architecture:
/// ```dart
/// class HomeScreen extends StatefulWidget {
///   const HomeScreen({Key? key}) : super(key: key);
///   
///   @override
///   State<HomeScreen> createState() => _HomeScreenState();
/// }
/// 
/// class _HomeScreenState extends State<HomeScreen> {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text('TaskCloud')),
///       body: Consumer<TaskProvider>(
///         builder: (context, taskProvider, child) {
///           // Build UI based on provider state
///         },
///       ),
///       floatingActionButton: FloatingActionButton(...),
///     );
///   }
/// }
/// ```
/// 
/// Navigation:
/// - Use named routes in main.dart
/// - Pass arguments via RouteSettings
/// - Handle back navigation properly
/// 
/// Testing:
/// - Test navigation flows
/// - Test screen rendering
/// - Test user interactions
/// - Mock providers and services
