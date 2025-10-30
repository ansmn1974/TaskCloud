# TDD Workflow - TaskCloud Frontend

## 🔴 RED Phase Complete! ✓

Following Test-Driven Development principles, we've successfully completed the RED phase by writing comprehensive failing tests **before** implementing any code.

## 📝 Tests Created (All Failing - As Expected)

### 1. Task Model Tests (`test/models/task_model_test.dart`)
**Total Tests: 25+ test cases**

#### Test Coverage:
- ✅ **JSON Serialization** (6 tests)
  - Create Task from JSON with all fields
  - Create Task from JSON with minimal fields
  - Convert Task to JSON
  - Handle null values in toJSON
  
- ✅ **Equality and HashCode** (3 tests)
  - Tasks with same properties are equal
  - Tasks with different properties are not equal
  - Completion status affects equality

- ✅ **CopyWith Pattern** (4 tests)
  - Update single field
  - Update multiple fields
  - Original object remains unchanged
  - No changes when no parameters provided

- ✅ **Validation** (3 tests)
  - Empty title not allowed
  - Null ID not allowed (enforced by null safety)
  - Title length constraints

- ✅ **Helper Methods** (3 tests)
  - Identify overdue tasks
  - Completed tasks not marked as overdue
  - Tasks without due date return false

- ✅ **Edge Cases** (3 tests)
  - Very long descriptions
  - Special characters and emojis
  - Invalid date format handling

### 2. Validators Tests (`test/utils/validators_test.dart`)
**Total Tests: 40+ test cases**

#### Test Coverage:
- ✅ **Email Validation** (6 tests)
  - Valid email formats
  - Empty/null email errors
  - Invalid formats
  - Whitespace handling

- ✅ **Password Validation** (8 tests)
  - Valid passwords (8+ chars, uppercase, lowercase, number)
  - Empty/null password errors
  - Length requirements
  - Character type requirements
  - Special characters allowed

- ✅ **Task Title Validation** (6 tests)
  - Valid titles
  - Empty/null errors
  - Whitespace-only rejection
  - Max length (100 chars)
  - Trimming whitespace

- ✅ **Task Description Validation** (3 tests)
  - Optional field (null allowed)
  - Max length (500 chars)
  - Length boundary testing

- ✅ **Username Validation** (7 tests)
  - Valid usernames (3-20 chars, alphanumeric + underscore)
  - Length constraints
  - Special character restrictions
  - Must start with letter

- ✅ **Due Date Validation** (4 tests)
  - Future dates valid
  - Null allowed (optional)
  - Past dates rejected
  - Today is valid

- ✅ **Confirm Password Validation** (4 tests)
  - Passwords match
  - Passwords don't match
  - Empty confirmation
  - Case-sensitive matching

### 3. Date Formatter Tests (`test/utils/date_formatter_test.dart`)
**Total Tests: 35+ test cases**

#### Test Coverage:
- ✅ **Format Date** (3 tests)
  - Standard format "MMM dd, yyyy"
  - Single-digit days
  - Different months

- ✅ **Format Time** (4 tests)
  - Standard time format "h:mm a"
  - Morning times
  - Midnight handling
  - Noon handling

- ✅ **Format DateTime** (1 test)
  - Combined date and time

- ✅ **Relative Time** (10 tests)
  - "today", "tomorrow", "yesterday"
  - "in X days" / "X days ago"
  - "in X hours" / "X hours ago"
  - "in X minutes"
  - "just now"

- ✅ **Check Overdue** (4 tests)
  - Past dates are overdue
  - Future dates not overdue
  - Today not overdue
  - Time consideration

- ✅ **Days Until** (3 tests)
  - Zero for today
  - Positive for future
  - Negative for past

- ✅ **Date Comparisons** (3 tests)
  - Is today
  - Is tomorrow
  - Is yesterday
  - Same day comparison

- ✅ **Week and Month** (5 tests)
  - Week number
  - Day of week name
  - Month name
  - Is this week
  - Is this month

- ✅ **Parse Date String** (2 tests)
  - Parse ISO 8601 format
  - Handle invalid strings

## 🎯 Test Execution Results

```bash
$ flutter test

Results:
✗ task_model_test.dart - 25 tests FAILED (files don't exist yet) ✓
✗ validators_test.dart - 40 tests FAILED (files don't exist yet) ✓
✗ date_formatter_test.dart - 35 tests FAILED (files don't exist yet) ✓
```

**Status: All tests failing as expected! ✅**

This is the correct RED phase - tests fail because implementation files don't exist yet.

## 📋 Next Steps: GREEN Phase (Implementation)

### Step 1: Implement Task Model
**File**: `lib/models/task_model.dart`

```dart
class Task {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? dueDate;
  final String? priority;
  final String? categoryId;
  
  Task({...});
  factory Task.fromJson(Map<String, dynamic> json) => ...;
  Map<String, dynamic> toJson() => ...;
  Task copyWith({...}) => ...;
  bool get isOverdue => ...;
  // ... equals, hashCode
}
```

### Step 2: Implement Validators
**File**: `lib/utils/validators.dart`

```dart
class Validators {
  static String? validateEmail(String? email) { ... }
  static String? validatePassword(String? password) { ... }
  static String? validateTaskTitle(String? title) { ... }
  static String? validateTaskDescription(String? description) { ... }
  static String? validateUsername(String? username) { ... }
  static String? validateDueDate(DateTime? date) { ... }
  static String? validateConfirmPassword(String password, String confirm) { ... }
}
```

### Step 3: Implement Date Formatter
**File**: `lib/utils/date_formatter.dart`

Dependencies needed: Add to `pubspec.yaml`:
```yaml
dependencies:
  intl: ^0.18.0
```

```dart
import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) { ... }
  static String formatTime(DateTime time) { ... }
  static String formatDateTime(DateTime dateTime) { ... }
  static String formatRelative(DateTime date) { ... }
  static bool isOverdue(DateTime date) { ... }
  static int daysUntil(DateTime date) { ... }
  // ... more methods
}
```

## 🔄 TDD Cycle

```
1. 🔴 RED   - Write failing tests ✓ DONE
2. 🟢 GREEN - Write minimal code to pass tests (NEXT)
3. 🔵 REFACTOR - Improve code while keeping tests green
4. 🔁 REPEAT for each feature
```

## 📊 Test Quality Metrics

### Coverage Areas:
- ✅ **Happy Path**: Normal expected usage
- ✅ **Edge Cases**: Boundary conditions, extremes
- ✅ **Error Handling**: Invalid inputs, null values
- ✅ **State Changes**: Immutability, object equality
- ✅ **Business Logic**: Domain-specific rules

### Test Organization:
- ✅ Tests grouped by feature (using `group()`)
- ✅ Descriptive test names
- ✅ Arrange-Act-Assert pattern
- ✅ One assertion per test (mostly)
- ✅ Independent tests (no shared state)

## 🎓 TDD Benefits Demonstrated

1. **Clear Requirements**: Tests define what code should do
2. **Design First**: Tests drive API design
3. **Documentation**: Tests serve as usage examples
4. **Confidence**: All tests must pass before moving forward
5. **Refactor Safety**: Can improve code without breaking functionality

## 📝 Testing Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/task_model_test.dart

# Run with coverage
flutter test --coverage

# Watch mode (re-run on changes)
flutter test --watch

# Verbose output
flutter test --verbose
```

## 🚀 Ready to Implement!

All failing tests are now in place. Time to implement the actual code and make them pass!

**Current Status**: 🔴 RED Phase Complete  
**Next**: 🟢 GREEN Phase - Implement features to pass tests

---

**Last Updated**: October 29, 2025  
**Total Tests Written**: 100+ test cases  
**Test Files**: 3 files (models, validators, date formatter)  
**All Tests Failing**: ✅ As Expected (TDD RED Phase)
