import 'package:flutter_test/flutter_test.dart';
import 'package:taskcloud/utils/date_formatter.dart';

/// Test suite for Date Formatter utilities
/// 
/// TDD: These tests define the expected behavior before implementation
void main() {
  group('DateFormatter - Format Date', () {
    test('should format date as "MMM dd, yyyy"', () {
      // Arrange
      final date = DateTime(2025, 10, 30);

      // Act
      final formatted = DateFormatter.formatDate(date);

      // Assert
      expect(formatted, 'Oct 30, 2025');
    });

    test('should format date with single-digit day', () {
      // Arrange
      final date = DateTime(2025, 1, 5);

      // Act
      final formatted = DateFormatter.formatDate(date);

      // Assert
      expect(formatted, 'Jan 05, 2025');
    });

    test('should handle different months correctly', () {
      // December
      expect(
        DateFormatter.formatDate(DateTime(2025, 12, 25)),
        'Dec 25, 2025',
      );
      // February
      expect(
        DateFormatter.formatDate(DateTime(2025, 2, 14)),
        'Feb 14, 2025',
      );
    });
  });

  group('DateFormatter - Format Time', () {
    test('should format time as "h:mm a"', () {
      // Arrange
      final dateTime = DateTime(2025, 10, 30, 14, 30);

      // Act
      final formatted = DateFormatter.formatTime(dateTime);

      // Assert
      expect(formatted, '2:30 PM');
    });

    test('should format morning time correctly', () {
      // Arrange
      final dateTime = DateTime(2025, 10, 30, 9, 15);

      // Act
      final formatted = DateFormatter.formatTime(dateTime);

      // Assert
      expect(formatted, '9:15 AM');
    });

    test('should handle midnight', () {
      // Arrange
      final dateTime = DateTime(2025, 10, 30, 0, 0);

      // Act
      final formatted = DateFormatter.formatTime(dateTime);

      // Assert
      expect(formatted, '12:00 AM');
    });

    test('should handle noon', () {
      // Arrange
      final dateTime = DateTime(2025, 10, 30, 12, 0);

      // Act
      final formatted = DateFormatter.formatTime(dateTime);

      // Assert
      expect(formatted, '12:00 PM');
    });
  });

  group('DateFormatter - Format DateTime', () {
    test('should format date and time together', () {
      // Arrange
      final dateTime = DateTime(2025, 10, 30, 14, 30);

      // Act
      final formatted = DateFormatter.formatDateTime(dateTime);

      // Assert
      expect(formatted, 'Oct 30, 2025 at 2:30 PM');
    });
  });

  group('DateFormatter - Relative Time', () {
    test('should return "today" for current date', () {
      // Arrange
      final today = DateTime.now();

      // Act
      final relative = DateFormatter.formatRelative(today);

      // Assert
      expect(relative, 'today');
    });

    test('should return "tomorrow" for next day', () {
      // Arrange
      final tomorrow = DateTime.now().add(const Duration(days: 1));

      // Act
      final relative = DateFormatter.formatRelative(tomorrow);

      // Assert
      expect(relative, 'tomorrow');
    });

    test('should return "yesterday" for previous day', () {
      // Arrange
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      // Act
      final relative = DateFormatter.formatRelative(yesterday);

      // Assert
      expect(relative, 'yesterday');
    });

    test('should return "in X days" for future dates', () {
      // Arrange
      final futureDate = DateTime.now().add(const Duration(days: 5));

      // Act
      final relative = DateFormatter.formatRelative(futureDate);

      // Assert
      expect(relative, 'in 5 days');
    });

    test('should return "X days ago" for past dates', () {
      // Arrange
      final pastDate = DateTime.now().subtract(const Duration(days: 3));

      // Act
      final relative = DateFormatter.formatRelative(pastDate);

      // Assert
      expect(relative, '3 days ago');
    });

    test('should handle single day correctly', () {
      // Arrange
      final oneDayAgo = DateTime.now().subtract(const Duration(days: 1));

      // Act
      final relative = DateFormatter.formatRelative(oneDayAgo);

      // Assert
      expect(relative, 'yesterday'); // Not "1 days ago"
    });

    test('should return "in X hours" for near future', () {
      // Arrange
      final nearFuture = DateTime.now().add(const Duration(hours: 3));

      // Act
      final relative = DateFormatter.formatRelative(nearFuture);

      // Assert
      expect(relative, 'in 3 hours');
    });

    test('should return "X hours ago" for recent past', () {
      // Arrange
      final recentPast = DateTime.now().subtract(const Duration(hours: 2));

      // Act
      final relative = DateFormatter.formatRelative(recentPast);

      // Assert
      expect(relative, '2 hours ago');
    });

    test('should return "in X minutes" for very near future', () {
      // Arrange
      final veryNear = DateTime.now().add(const Duration(minutes: 30));

      // Act
      final relative = DateFormatter.formatRelative(veryNear);

      // Assert
      expect(relative, 'in 30 minutes');
    });

    test('should return "just now" for very recent times', () {
      // Arrange
      final justNow = DateTime.now().subtract(const Duration(seconds: 30));

      // Act
      final relative = DateFormatter.formatRelative(justNow);

      // Assert
      expect(relative, 'just now');
    });
  });

  group('DateFormatter - Check Overdue', () {
    test('should return true for past dates', () {
      // Arrange
      final pastDate = DateTime.now().subtract(const Duration(days: 1));

      // Act
      final isOverdue = DateFormatter.isOverdue(pastDate);

      // Assert
      expect(isOverdue, true);
    });

    test('should return false for future dates', () {
      // Arrange
      final futureDate = DateTime.now().add(const Duration(days: 1));

      // Act
      final isOverdue = DateFormatter.isOverdue(futureDate);

      // Assert
      expect(isOverdue, false);
    });

    test('should return false for today', () {
      // Arrange
      final today = DateTime.now();

      // Act
      final isOverdue = DateFormatter.isOverdue(today);

      // Assert
      expect(isOverdue, false);
    });

    test('should consider time when checking if overdue', () {
      // Arrange
      final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
      final oneHourLater = DateTime.now().add(const Duration(hours: 1));

      // Act & Assert
      expect(DateFormatter.isOverdue(oneHourAgo), true);
      expect(DateFormatter.isOverdue(oneHourLater), false);
    });
  });

  group('DateFormatter - Days Until', () {
    test('should return 0 for today', () {
      // Arrange
      final today = DateTime.now();

      // Act
      final days = DateFormatter.daysUntil(today);

      // Assert
      expect(days, 0);
    });

    test('should return positive number for future dates', () {
      // Arrange
      final future = DateTime.now().add(const Duration(days: 7));

      // Act
      final days = DateFormatter.daysUntil(future);

      // Assert
      expect(days, 7);
    });

    test('should return negative number for past dates', () {
      // Arrange
      final past = DateTime.now().subtract(const Duration(days: 3));

      // Act
      final days = DateFormatter.daysUntil(past);

      // Assert
      expect(days, -3);
    });
  });

  group('DateFormatter - Date Comparisons', () {
    test('should identify if date is today', () {
      // Arrange
      final today = DateTime.now();
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final tomorrow = DateTime.now().add(const Duration(days: 1));

      // Act & Assert
      expect(DateFormatter.isToday(today), true);
      expect(DateFormatter.isToday(yesterday), false);
      expect(DateFormatter.isToday(tomorrow), false);
    });

    test('should identify if date is tomorrow', () {
      // Arrange
      final today = DateTime.now();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final dayAfter = DateTime.now().add(const Duration(days: 2));

      // Act & Assert
      expect(DateFormatter.isTomorrow(today), false);
      expect(DateFormatter.isTomorrow(tomorrow), true);
      expect(DateFormatter.isTomorrow(dayAfter), false);
    });

    test('should identify if date is yesterday', () {
      // Arrange
      final today = DateTime.now();
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));

      // Act & Assert
      expect(DateFormatter.isYesterday(today), false);
      expect(DateFormatter.isYesterday(yesterday), true);
      expect(DateFormatter.isYesterday(twoDaysAgo), false);
    });

    test('should compare dates ignoring time', () {
      // Arrange
      final date1 = DateTime(2025, 10, 30, 9, 0);
      final date2 = DateTime(2025, 10, 30, 18, 30);
      final date3 = DateTime(2025, 10, 31, 9, 0);

      // Act & Assert
      expect(DateFormatter.isSameDay(date1, date2), true);
      expect(DateFormatter.isSameDay(date1, date3), false);
    });
  });

  group('DateFormatter - Week and Month', () {
    test('should return current week number', () {
      // Arrange
      final date = DateTime(2025, 10, 30);

      // Act
      final weekNumber = DateFormatter.weekNumber(date);

      // Assert
      expect(weekNumber, isA<int>());
      expect(weekNumber, greaterThan(0));
      expect(weekNumber, lessThanOrEqualTo(53));
    });

    test('should return day of week name', () {
      // Arrange
      final monday = DateTime(2025, 10, 27); // Assuming this is Monday

      // Act
      final dayName = DateFormatter.dayOfWeekName(monday);

      // Assert
      expect(dayName, isA<String>());
      expect(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 
              'Saturday', 'Sunday'].contains(dayName), true);
    });

    test('should return month name', () {
      // Arrange
      final date = DateTime(2025, 10, 30);

      // Act
      final monthName = DateFormatter.monthName(date);

      // Assert
      expect(monthName, 'October');
    });

    test('should check if date is in current week', () {
      // Arrange
      final today = DateTime.now();
      final nextWeek = DateTime.now().add(const Duration(days: 8));

      // Act & Assert
      expect(DateFormatter.isThisWeek(today), true);
      expect(DateFormatter.isThisWeek(nextWeek), false);
    });

    test('should check if date is in current month', () {
      // Arrange
      final today = DateTime.now();
      final nextMonth = DateTime(
        today.year,
        today.month + 1,
        today.day,
      );

      // Act & Assert
      expect(DateFormatter.isThisMonth(today), true);
      expect(DateFormatter.isThisMonth(nextMonth), false);
    });
  });

  group('DateFormatter - Parse Date String', () {
    test('should parse ISO 8601 date string', () {
      // Arrange
      const dateString = '2025-10-30T14:30:00.000Z';

      // Act
      final parsed = DateFormatter.parseIsoDate(dateString);

      // Assert
      expect(parsed, isNotNull);
  expect(parsed!.year, 2025);
  expect(parsed.month, 10);
  expect(parsed.day, 30);
    });

    test('should return null for invalid date string', () {
      // Arrange
      const invalidDate = 'not-a-date';

      // Act
      final parsed = DateFormatter.parseIsoDate(invalidDate);

      // Assert
      expect(parsed, isNull);
    });
  });
}
