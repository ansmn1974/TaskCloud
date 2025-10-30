/// Validators Utility Class
/// 
/// Provides reusable validation functions for form inputs across the app.
/// All validators return `null` for valid input, or an error message string for invalid input.
/// 
/// This format is compatible with Flutter's TextFormField validator parameter.
/// 
/// Example usage:
/// ```dart
/// TextFormField(
///   validator: Validators.validateEmail,
///   decoration: InputDecoration(labelText: 'Email'),
/// )
/// ```
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validates email address format
  /// 
  /// Returns `null` if email is valid, error message otherwise.
  /// 
  /// Rules:
  /// - Must not be empty
  /// - Must match standard email pattern
  /// - Must have @ symbol
  /// - Must have domain with extension
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }

    // Email regex pattern
    final emailRegex = RegExp(
  r'^[\w\-\.\+]+@([\w-]+\.)+[\w-]{2,}$',
    );

    if (!emailRegex.hasMatch(email.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  /// Validates password strength
  /// 
  /// Returns `null` if password is valid, error message otherwise.
  /// 
  /// Rules:
  /// - Minimum 8 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one number
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validates task title
  /// 
  /// Returns `null` if title is valid, error message otherwise.
  /// 
  /// Rules:
  /// - Must not be empty or whitespace-only
  /// - Maximum 100 characters
  static String? validateTaskTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return 'Task title is required';
    }

    if (title.trim().length > 100) {
      return 'Task title must be less than 100 characters';
    }

    return null;
  }

  /// Validates task description (optional field)
  /// 
  /// Returns `null` if description is valid, error message otherwise.
  /// 
  /// Rules:
  /// - Can be null or empty (optional field)
  /// - Maximum 500 characters if provided
  static String? validateTaskDescription(String? description) {
    // Description is optional
    if (description == null || description.isEmpty) {
      return null;
    }

    if (description.length > 500) {
      return 'Task description must be less than 500 characters';
    }

    return null;
  }

  /// Validates username
  /// 
  /// Returns `null` if username is valid, error message otherwise.
  /// 
  /// Rules:
  /// - Minimum 3 characters
  /// - Maximum 20 characters
  /// - Only alphanumeric characters and underscores
  /// - Must start with a letter
  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username is required';
    }

    if (username.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (username.length > 20) {
      return 'Username must be less than 20 characters';
    }

    // Must start with a letter
    if (!RegExp(r'^[a-zA-Z]').hasMatch(username)) {
      return 'Username must start with a letter';
    }

    // Only alphanumeric and underscores
    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(username)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  /// Validates due date
  /// 
  /// Returns `null` if date is valid, error message otherwise.
  /// 
  /// Rules:
  /// - Can be null (optional)
  /// - Must be today or in the future if provided
  static String? validateDueDate(DateTime? date) {
    // Due date is optional
    if (date == null) {
      return null;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    // Allow today and future dates
    if (dateOnly.isBefore(today)) {
      return 'Due date must be today or in the future';
    }

    return null;
  }

  /// Validates password confirmation
  /// 
  /// Returns `null` if passwords match, error message otherwise.
  /// 
  /// Rules:
  /// - Confirm password must match original password
  /// - Must not be empty
  /// - Case-sensitive comparison
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates that a field is not empty
  /// 
  /// Generic validator for required fields.
  /// 
  /// Parameters:
  /// - [value]: The value to validate
  /// - [fieldName]: Name of the field for error message
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates minimum length
  /// 
  /// Parameters:
  /// - [value]: The value to validate
  /// - [minLength]: Minimum required length
  /// - [fieldName]: Name of the field for error message
  static String? validateMinLength(
    String? value,
    int minLength,
    String fieldName,
  ) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    return null;
  }

  /// Validates maximum length
  /// 
  /// Parameters:
  /// - [value]: The value to validate
  /// - [maxLength]: Maximum allowed length
  /// - [fieldName]: Name of the field for error message
  static String? validateMaxLength(
    String? value,
    int maxLength,
    String fieldName,
  ) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }

    return null;
  }

  /// Combines multiple validators
  /// 
  /// Returns the first error found, or null if all validators pass.
  /// 
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: (value) => Validators.combine(value, [
  ///     (v) => Validators.validateRequired(v, 'Email'),
  ///     Validators.validateEmail,
  ///   ]),
  /// )
  /// ```
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
