# TaskCloud Frontend - Complete Project Structure

## 📂 Directory Overview

```
frontend/
│
├── lib/                                    # Main application code
│   ├── main.dart                          # App entry point
│   │
│   ├── config/                            # Configuration files
│   │   ├── README.md                      # Config documentation
│   │   ├── api_config.dart               # API endpoints (to be created)
│   │   ├── app_config.dart               # App constants (to be created)
│   │   └── theme_config.dart             # Theme definitions (to be created)
│   │
│   ├── models/                            # Data models
│   │   ├── README.md                      # Models documentation
│   │   ├── task_model.dart               # Task entity (to be created)
│   │   ├── user_model.dart               # User entity (to be created)
│   │   └── category_model.dart           # Category entity (to be created)
│   │
│   ├── screens/                           # Full-screen pages
│   │   ├── README.md                      # Screens documentation
│   │   ├── home_screen.dart              # Main task list (to be created)
│   │   ├── task_detail_screen.dart       # Task details (to be created)
│   │   ├── add_task_screen.dart          # Create task (to be created)
│   │   ├── login_screen.dart             # Authentication (to be created)
│   │   └── settings_screen.dart          # App settings (to be created)
│   │
│   ├── widgets/                           # Reusable components
│   │   ├── README.md                      # Widgets documentation
│   │   ├── task_card.dart                # Task card widget (to be created)
│   │   ├── task_list_item.dart           # List item widget (to be created)
│   │   ├── custom_button.dart            # Custom button (to be created)
│   │   ├── custom_text_field.dart        # Custom input (to be created)
│   │   └── loading_indicator.dart        # Loading widget (to be created)
│   │
│   ├── services/                          # Business logic & API
│   │   ├── README.md                      # Services documentation
│   │   ├── api_service.dart              # HTTP API calls (to be created)
│   │   ├── auth_service.dart             # Authentication (to be created)
│   │   ├── local_storage_service.dart    # Local storage (to be created)
│   │   └── notification_service.dart     # Notifications (to be created)
│   │
│   ├── providers/                         # State management
│   │   ├── README.md                      # Providers documentation
│   │   ├── task_provider.dart            # Task state (to be created)
│   │   ├── auth_provider.dart            # Auth state (to be created)
│   │   └── theme_provider.dart           # Theme state (to be created)
│   │
│   └── utils/                             # Helper functions
│       ├── README.md                      # Utils documentation
│       ├── constants.dart                 # App constants (to be created)
│       ├── validators.dart                # Input validators (to be created)
│       ├── date_formatter.dart            # Date utilities (to be created)
│       ├── extensions.dart                # Dart extensions (to be created)
│       └── helpers.dart                   # Misc helpers (to be created)
│
├── test/                                  # Test files (mirrors lib/)
│   ├── README.md                          # Testing documentation
│   ├── widget_test.dart                   # Default widget test
│   │
│   ├── models/                            # Model tests
│   │   ├── task_model_test.dart          # (to be created)
│   │   ├── user_model_test.dart          # (to be created)
│   │   └── category_model_test.dart      # (to be created)
│   │
│   ├── screens/                           # Screen tests
│   │   ├── home_screen_test.dart         # (to be created)
│   │   ├── task_detail_screen_test.dart  # (to be created)
│   │   └── login_screen_test.dart        # (to be created)
│   │
│   ├── widgets/                           # Widget tests
│   │   ├── task_card_test.dart           # (to be created)
│   │   └── custom_button_test.dart       # (to be created)
│   │
│   ├── services/                          # Service tests
│   │   ├── api_service_test.dart         # (to be created)
│   │   └── auth_service_test.dart        # (to be created)
│   │
│   ├── providers/                         # Provider tests
│   │   └── task_provider_test.dart       # (to be created)
│   │
│   └── utils/                             # Utility tests
│       ├── validators_test.dart           # (to be created)
│       └── date_formatter_test.dart       # (to be created)
│
├── integration_test/                      # Integration tests (to be created)
│
├── assets/                                # Static resources
│   ├── images/                           # App images
│   ├── icons/                            # App icons
│   └── fonts/                            # Custom fonts
│
├── android/                               # Android native code
├── ios/                                   # iOS native code
├── web/                                   # Web assets
├── windows/                               # Windows native code
├── macos/                                 # macOS native code
├── linux/                                 # Linux native code
│
├── pubspec.yaml                          # Project dependencies
├── pubspec.lock                          # Locked dependency versions
├── analysis_options.yaml                 # Dart analyzer config
├── .gitignore                            # Git ignore rules
├── .metadata                             # Flutter metadata
├── README.md                             # Project documentation
└── STRUCTURE.md                          # This file
```

## 🎯 Folder Purposes (Quick Reference)

| Folder | Purpose | Example Files |
|--------|---------|---------------|
| `config/` | App configuration, constants, API endpoints | api_config.dart, theme_config.dart |
| `models/` | Data structures and entities | task_model.dart, user_model.dart |
| `screens/` | Full-screen pages/routes | home_screen.dart, login_screen.dart |
| `widgets/` | Reusable UI components | task_card.dart, custom_button.dart |
| `services/` | Business logic, API calls, external services | api_service.dart, auth_service.dart |
| `providers/` | State management (Provider/Riverpod) | task_provider.dart, auth_provider.dart |
| `utils/` | Helper functions, validators, formatters | validators.dart, date_formatter.dart |
| `test/` | All test files (mirrors lib/ structure) | *_test.dart files |

## 📝 File Naming Conventions

- **Snake case**: `task_model.dart`, `home_screen.dart`, `api_service.dart`
- **Test files**: Same name + `_test.dart` suffix
- **Classes**: PascalCase (e.g., `TaskModel`, `HomeScreen`)
- **Functions/variables**: camelCase (e.g., `getTasks`, `isLoading`)
- **Constants**: camelCase or UPPER_SNAKE_CASE

## 🔄 Development Workflow

### 1. TDD Cycle (for each feature)

```
1. Write test first        → test/models/task_model_test.dart
2. Run test (should fail)  → flutter test
3. Write minimal code      → lib/models/task_model.dart
4. Run test (should pass)  → flutter test
5. Refactor if needed
6. Repeat
```

### 2. Adding a New Feature

**Example: Add Task Priority**

1. **Model** (with test first)
   - Create: `test/models/task_priority_test.dart`
   - Implement: `lib/models/task_priority.dart`

2. **Service** (with test first)
   - Create: `test/services/priority_service_test.dart`
   - Implement: `lib/services/priority_service.dart`

3. **Provider** (with test first)
   - Create: `test/providers/priority_provider_test.dart`
   - Implement: `lib/providers/priority_provider.dart`

4. **Widget** (with test first)
   - Create: `test/widgets/priority_selector_test.dart`
   - Implement: `lib/widgets/priority_selector.dart`

5. **Screen Integration**
   - Update: `lib/screens/add_task_screen.dart`
   - Test: `test/screens/add_task_screen_test.dart`

## ✅ Current Status

### Created ✓
- [x] Base project structure
- [x] All primary folders (config, models, screens, widgets, services, providers, utils)
- [x] Corresponding test folders
- [x] Documentation (README.md in each folder)
- [x] Main project README

### To Be Created (Next Steps)
- [ ] Core models (Task, User, Category)
- [ ] API service with Django backend integration
- [ ] Authentication service
- [ ] Task provider for state management
- [ ] Main screens (Home, Login, Task Detail)
- [ ] Reusable widgets (TaskCard, CustomButton)
- [ ] Utils (validators, formatters, extensions)
- [ ] Comprehensive tests for all components

## 🚀 Next Steps

1. **Install dependencies** (add to pubspec.yaml)
   - http/dio for API calls
   - provider/riverpod for state management
   - shared_preferences for local storage
   - mockito for testing

2. **Create models** (TDD approach)
   - Task model with full CRUD tests
   - User model with auth tests
   - Category model with tests

3. **Build services**
   - API service with mock backend
   - Auth service with JWT handling
   - Local storage service

4. **Implement providers**
   - Task provider with state management
   - Auth provider with session handling

5. **Design screens**
   - Home screen with task list
   - Login/register screens
   - Task detail/edit screens

6. **Create widgets**
   - Task card component
   - Custom form fields
   - Loading/error states

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Provider Documentation](https://pub.dev/packages/provider)

---

**Last Updated**: October 29, 2025  
**Status**: Initial Structure Complete ✓  
**Next**: Begin TDD implementation of core models
