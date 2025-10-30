/// Models Module
/// 
/// This directory contains data models and entity classes.
/// 
/// Responsibilities:
/// - Define data structures for the application
/// - Implement JSON serialization/deserialization
/// - Add data validation logic
/// - Define relationships between entities
/// - Implement equality and hashCode for comparison
/// 
/// Key Models:
/// - task_model.dart: Task entity (id, title, description, dueDate, isCompleted)
/// - user_model.dart: User entity (id, username, email, token)
/// - category_model.dart: Task category (id, name, color)
/// 
/// Example structure:
/// ```dart
/// class Task {
///   final String id;
///   final String title;
///   final String description;
///   final DateTime? dueDate;
///   final bool isCompleted;
///   
///   Task({...});
///   
///   // JSON serialization
///   factory Task.fromJson(Map<String, dynamic> json) => ...;
///   Map<String, dynamic> toJson() => ...;
///   
///   // Copy with for immutability
///   Task copyWith({...}) => ...;
/// }
/// ```
/// 
/// Testing:
/// - Test JSON parsing (fromJson/toJson)
/// - Test equality and hashCode
/// - Test copyWith functionality
/// - Test validation logic
