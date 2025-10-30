/// Utils Module
/// 
/// This directory contains utility functions, helpers, and extensions.
/// 
/// Responsibilities:
/// - Provide reusable helper functions
/// - Define app-wide constants
/// - Create extension methods
/// - Implement validators
/// - Format and parse data
/// - Handle common operations
/// 
/// Key Utility Files:
/// 
/// 1. **constants.dart**: App-wide constants
///    - Colors
///    - Spacing values
///    - Text styles
///    - API keys (non-sensitive)
///    - Route names
/// 
/// 2. **validators.dart**: Input validation
///    - Email validation
///    - Password strength
///    - Task title validation
///    - Date validation
/// 
/// 3. **date_formatter.dart**: Date/time utilities
///    - Format dates for display
///    - Parse date strings
///    - Calculate relative dates ("2 days ago")
///    - Handle timezones
/// 
/// 4. **extensions.dart**: Dart extension methods
///    - String extensions
///    - DateTime extensions
///    - BuildContext extensions
/// 
/// 5. **helpers.dart**: Miscellaneous helper functions
///    - Generate unique IDs
///    - Deep copy objects
///    - Debounce/throttle functions
/// 
/// Example - Constants:
/// ```dart
/// // constants.dart
/// class AppConstants {
///   // Colors
///   static const Color primaryColor = Color(0xFF6200EE);
///   static const Color accentColor = Color(0xFF03DAC6);
///   
///   // Spacing
///   static const double paddingSmall = 8.0;
///   static const double paddingMedium = 16.0;
///   static const double paddingLarge = 24.0;
///   
///   // API
///   static const Duration apiTimeout = Duration(seconds: 30);
///   
///   // Routes
///   static const String homeRoute = '/home';
///   static const String loginRoute = '/login';
///   static const String taskDetailRoute = '/task-detail';
/// }
/// ```
/// 
/// Example - Validators:
/// ```dart
/// // validators.dart
/// class Validators {
///   /// Validate email format
///   static String? validateEmail(String? email) {
///     if (email == null || email.isEmpty) {
///       return 'Email is required';
///     }
///     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
///     if (!emailRegex.hasMatch(email)) {
///       return 'Enter a valid email';
///     }
///     return null;
///   }
///   
///   /// Validate password strength
///   static String? validatePassword(String? password) {
///     if (password == null || password.isEmpty) {
///       return 'Password is required';
///     }
///     if (password.length < 8) {
///       return 'Password must be at least 8 characters';
///     }
///     if (!password.contains(RegExp(r'[A-Z]'))) {
///       return 'Password must contain an uppercase letter';
///     }
///     if (!password.contains(RegExp(r'[0-9]'))) {
///       return 'Password must contain a number';
///     }
///     return null;
///   }
///   
///   /// Validate task title
///   static String? validateTaskTitle(String? title) {
///     if (title == null || title.trim().isEmpty) {
///       return 'Task title is required';
///     }
///     if (title.length > 100) {
///       return 'Task title must be less than 100 characters';
///     }
///     return null;
///   }
/// }
/// ```
/// 
/// Example - Date Formatter:
/// ```dart
/// // date_formatter.dart
/// import 'package:intl/intl.dart';
/// 
/// class DateFormatter {
///   /// Format date as "Jan 15, 2025"
///   static String formatDate(DateTime date) {
///     return DateFormat('MMM dd, yyyy').format(date);
///   }
///   
///   /// Format as relative time ("2 days ago", "in 3 hours")
///   static String formatRelative(DateTime date) {
///     final now = DateTime.now();
///     final difference = date.difference(now);
///     
///     if (difference.inDays > 0) {
///       return 'in ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
///     } else if (difference.inDays < 0) {
///       return '${difference.inDays.abs()} day${difference.inDays.abs() > 1 ? 's' : ''} ago';
///     } else if (difference.inHours > 0) {
///       return 'in ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
///     } else {
///       return 'today';
///     }
///   }
///   
///   /// Check if date is overdue
///   static bool isOverdue(DateTime dueDate) {
///     return dueDate.isBefore(DateTime.now());
///   }
/// }
/// ```
/// 
/// Example - Extensions:
/// ```dart
/// // extensions.dart
/// extension StringExtension on String {
///   /// Capitalize first letter
///   String capitalize() {
///     if (isEmpty) return this;
///     return '${this[0].toUpperCase()}${substring(1)}';
///   }
///   
///   /// Check if string is a valid email
///   bool get isValidEmail {
///     return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
///   }
/// }
/// 
/// extension DateTimeExtension on DateTime {
///   /// Check if date is today
///   bool get isToday {
///     final now = DateTime.now();
///     return year == now.year && month == now.month && day == now.day;
///   }
///   
///   /// Check if date is tomorrow
///   bool get isTomorrow {
///     final tomorrow = DateTime.now().add(Duration(days: 1));
///     return year == tomorrow.year && 
///            month == tomorrow.month && 
///            day == tomorrow.day;
///   }
/// }
/// 
/// extension BuildContextExtension on BuildContext {
///   /// Easy access to theme
///   ThemeData get theme => Theme.of(this);
///   
///   /// Easy access to media query
///   Size get screenSize => MediaQuery.of(this).size;
///   
///   /// Show snackbar
///   void showSnackBar(String message) {
///     ScaffoldMessenger.of(this).showSnackBar(
///       SnackBar(content: Text(message)),
///     );
///   }
/// }
/// ```
/// 
/// Best Practices:
/// - Keep functions pure (no side effects)
/// - Make functions testable
/// - Document complex logic
/// - Use meaningful names
/// - Group related utilities
/// - Keep constants organized
/// 
/// Testing:
/// - Test each utility function independently
/// - Test edge cases (null, empty, invalid)
/// - Test validators with valid/invalid inputs
/// - Test date formatters with various dates
