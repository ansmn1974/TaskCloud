/// API Configuration for TaskCloud
/// 
/// Centralized configuration for API endpoints and settings.
class ApiConfig {
  /// Base URL for the TaskCloud API
  /// 
  /// Production: https://api.ibn-nabil.com/tasks
  /// Development: http://localhost:8000 or http://127.0.0.1:8000
  static const String baseUrl = 'https://api.ibn-nabil.com/tasks';

  /// API endpoints
  static const String tasksEndpoint = '/api/tasks/';
  static const String healthEndpoint = '/health/';
  
  /// Full URLs
  static String get tasksUrl => '$baseUrl$tasksEndpoint';
  static String get healthUrl => '$baseUrl$healthEndpoint';
  
  /// Get task detail URL by ID
  static String taskDetailUrl(String id) => '$baseUrl$tasksEndpoint$id/';
  
  /// Request timeout duration
  static const Duration timeout = Duration(seconds: 30);
  
  /// Whether to use mock data (for testing without backend)
  static const bool useMockData = false;
}
