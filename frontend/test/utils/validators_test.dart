import 'package:flutter_test/flutter_test.dart';
import 'package:taskcloud/utils/validators.dart';

/// Test suite for Validators
/// 
/// TDD: These tests are written first and will fail initially.
/// Implementation will be created in lib/utils/validators.dart
void main() {
  group('Validators - Email', () {
    test('should return null for valid email addresses', () {
      // Valid emails
      expect(Validators.validateEmail('user@example.com'), isNull);
      expect(Validators.validateEmail('john.doe@company.co.uk'), isNull);
      expect(Validators.validateEmail('test+tag@domain.org'), isNull);
      expect(Validators.validateEmail('user123@test-domain.com'), isNull);
    });

    test('should return error for empty email', () {
      // Act
      final result = Validators.validateEmail('');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('required'));
    });

    test('should return error for null email', () {
      // Act
      final result = Validators.validateEmail(null);

      // Assert
      expect(result, isNotNull);
      expect(result, contains('required'));
    });

    test('should return error for invalid email formats', () {
      // Invalid formats
      expect(Validators.validateEmail('notanemail'), isNotNull);
      expect(Validators.validateEmail('missing@domain'), isNotNull);
      expect(Validators.validateEmail('@nodomain.com'), isNotNull);
      expect(Validators.validateEmail('user@'), isNotNull);
      expect(Validators.validateEmail('user name@domain.com'), isNotNull);
      expect(Validators.validateEmail('user@domain'), isNotNull);
    });

    test('should return error for email with spaces', () {
      // Act
      final result = Validators.validateEmail('user @example.com');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('valid'));
    });
  });

  group('Validators - Password', () {
    test('should return null for valid passwords', () {
      // Valid passwords (min 8 chars, 1 uppercase, 1 lowercase, 1 number)
      expect(Validators.validatePassword('Password123'), isNull);
      expect(Validators.validatePassword('SecurePass1'), isNull);
      expect(Validators.validatePassword('MyP@ssw0rd'), isNull);
    });

    test('should return error for empty password', () {
      // Act
      final result = Validators.validatePassword('');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('required'));
    });

    test('should return error for null password', () {
      // Act
      final result = Validators.validatePassword(null);

      // Assert
      expect(result, isNotNull);
    });

    test('should return error for password shorter than 8 characters', () {
      // Act
      final result = Validators.validatePassword('Pass1');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('8 characters'));
    });

    test('should return error for password without uppercase letter', () {
      // Act
      final result = Validators.validatePassword('password123');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('uppercase'));
    });

    test('should return error for password without lowercase letter', () {
      // Act
      final result = Validators.validatePassword('PASSWORD123');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('lowercase'));
    });

    test('should return error for password without number', () {
      // Act
      final result = Validators.validatePassword('PasswordOnly');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('number'));
    });

    test('should accept password with special characters', () {
      // Valid password with special chars
      expect(Validators.validatePassword('P@ssw0rd!'), isNull);
      expect(Validators.validatePassword('Secure#Pass123'), isNull);
    });
  });

  group('Validators - Task Title', () {
    test('should return null for valid task titles', () {
      // Valid titles
      expect(Validators.validateTaskTitle('Buy groceries'), isNull);
      expect(Validators.validateTaskTitle('Complete project'), isNull);
      expect(Validators.validateTaskTitle('A'), isNull); // Min 1 char
      expect(Validators.validateTaskTitle('a' * 100), isNull); // Max 100 chars
    });

    test('should return error for empty title', () {
      // Act
      final result = Validators.validateTaskTitle('');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('required'));
    });

    test('should return error for null title', () {
      // Act
      final result = Validators.validateTaskTitle(null);

      // Assert
      expect(result, isNotNull);
    });

    test('should return error for whitespace-only title', () {
      // Act
      final result = Validators.validateTaskTitle('   ');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('required'));
    });

    test('should return error for title exceeding max length', () {
      // Arrange - 101 characters
      final longTitle = 'a' * 101;

      // Act
      final result = Validators.validateTaskTitle(longTitle);

      // Assert
      expect(result, isNotNull);
      expect(result, contains('100 characters'));
    });

    test('should trim whitespace before validating', () {
      // Valid after trimming
      expect(Validators.validateTaskTitle('  Valid title  '), isNull);
    });
  });

  group('Validators - Task Description', () {
    test('should return null for valid descriptions', () {
      // Valid descriptions (optional field)
      expect(Validators.validateTaskDescription('Some description'), isNull);
      expect(Validators.validateTaskDescription(''), isNull);
      expect(Validators.validateTaskDescription(null), isNull);
    });

    test('should return error for description exceeding max length', () {
      // Arrange - 501 characters
      final longDescription = 'a' * 501;

      // Act
      final result = Validators.validateTaskDescription(longDescription);

      // Assert
      expect(result, isNotNull);
      expect(result, contains('500 characters'));
    });

    test('should accept description at max length', () {
      // Arrange - exactly 500 characters
      final maxDescription = 'a' * 500;

      // Act
      final result = Validators.validateTaskDescription(maxDescription);

      // Assert
      expect(result, isNull);
    });
  });

  group('Validators - Username', () {
    test('should return null for valid usernames', () {
      // Valid usernames (3-20 chars, alphanumeric and underscore)
      expect(Validators.validateUsername('john_doe'), isNull);
      expect(Validators.validateUsername('user123'), isNull);
      expect(Validators.validateUsername('abc'), isNull); // Min 3 chars
      expect(Validators.validateUsername('a' * 20), isNull); // Max 20 chars
    });

    test('should return error for empty username', () {
      // Act
      final result = Validators.validateUsername('');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('required'));
    });

    test('should return error for username shorter than 3 characters', () {
      // Act
      final result = Validators.validateUsername('ab');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('3 characters'));
    });

    test('should return error for username longer than 20 characters', () {
      // Arrange
      final longUsername = 'a' * 21;

      // Act
      final result = Validators.validateUsername(longUsername);

      // Assert
      expect(result, isNotNull);
      expect(result, contains('20 characters'));
    });

    test('should return error for username with special characters', () {
      // Invalid usernames with special chars (except underscore)
      expect(Validators.validateUsername('user@name'), isNotNull);
      expect(Validators.validateUsername('user-name'), isNotNull);
      expect(Validators.validateUsername('user.name'), isNotNull);
      expect(Validators.validateUsername('user name'), isNotNull);
    });

    test('should accept username with underscores', () {
      // Act
      final result = Validators.validateUsername('valid_user_name');

      // Assert
      expect(result, isNull);
    });

    test('should return error for username starting with number', () {
      // Act
      final result = Validators.validateUsername('123user');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('letter'));
    });
  });

  group('Validators - Date', () {
    test('should return null for future dates', () {
      // Arrange
      final futureDate = DateTime.now().add(const Duration(days: 1));

      // Act
      final result = Validators.validateDueDate(futureDate);

      // Assert
      expect(result, isNull);
    });

    test('should return null for null date (optional)', () {
      // Act
      final result = Validators.validateDueDate(null);

      // Assert
      expect(result, isNull);
    });

    test('should return error for past dates', () {
      // Arrange
      final pastDate = DateTime.now().subtract(const Duration(days: 1));

      // Act
      final result = Validators.validateDueDate(pastDate);

      // Assert
      expect(result, isNotNull);
      expect(result, contains('future'));
    });

    test('should accept today as valid due date', () {
      // Arrange
      final today = DateTime.now();

      // Act
      final result = Validators.validateDueDate(today);

      // Assert
      expect(result, isNull);
    });
  });

  group('Validators - Confirm Password', () {
    test('should return null when passwords match', () {
      // Act
      final result = Validators.validateConfirmPassword(
        'Password123',
        'Password123',
      );

      // Assert
      expect(result, isNull);
    });

    test('should return error when passwords do not match', () {
      // Act
      final result = Validators.validateConfirmPassword(
        'Password123',
        'DifferentPass456',
      );

      // Assert
      expect(result, isNotNull);
      expect(result, contains('match'));
    });

    test('should return error when confirm password is empty', () {
      // Act
      final result = Validators.validateConfirmPassword('Password123', '');

      // Assert
      expect(result, isNotNull);
    });

    test('should be case-sensitive', () {
      // Act
      final result = Validators.validateConfirmPassword(
        'Password123',
        'password123',
      );

      // Assert
      expect(result, isNotNull);
    });
  });
}
