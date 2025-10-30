/// Configuration Module
/// 
/// This directory contains all application-wide configuration files.
/// 
/// Responsibilities:
/// - Define API endpoints and base URLs
/// - Store environment-specific configurations (dev, staging, production)
/// - Define app-wide constants (timeouts, limits, keys)
/// - Theme configurations (colors, typography, spacing)
/// - Feature flags for gradual rollouts
/// 
/// Example files:
/// - api_config.dart: API endpoints and HTTP client setup
/// - app_config.dart: General app settings and constants
/// - theme_config.dart: Material theme definitions
/// - environment.dart: Environment variable management
/// 
/// Usage:
/// ```dart
/// import 'package:taskcloud/config/api_config.dart';
/// 
/// final response = await http.get('${ApiConfig.baseUrl}/tasks');
/// ```
