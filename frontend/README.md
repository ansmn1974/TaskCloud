# TaskCloud Flutter Frontend

A beautiful, cross-platform to-do list application built with Flutter.

## 🏗️ Project Structure

```
frontend/
├── lib/
│   ├── main.dart                 # Application entry point
│   ├── config/                   # Configuration files (API endpoints, constants)
│   ├── models/                   # Data models (Task, User, Category)
│   ├── screens/                  # Full-screen pages (Home, Login, Task Details)
│   ├── widgets/                  # Reusable UI components (Task Card, Custom Button)
│   ├── services/                 # API services and external integrations
│   ├── providers/                # State management (Provider/Riverpod)
│   └── utils/                    # Helper functions and utilities
│
├── test/                         # Mirror structure of lib/ for testing
│   ├── models/
│   ├── screens/
│   ├── widgets/
│   ├── services/
│   ├── providers/
│   └── utils/
│
├── assets/                       # Images, fonts, and other static files
├── pubspec.yaml                  # Project dependencies
└── README.md                     # This file
```

## 📁 Folder Responsibilities

### `/lib/config`
Contains application configuration files:
- API endpoints and base URLs
- Environment variables
- Theme configurations
- App constants

### `/lib/models`
Data models and entities:
- Task model (id, title, description, dueDate, isCompleted)
- User model
- Category model
- JSON serialization/deserialization logic

### `/lib/screens`
Full-screen pages that represent different views:
- HomeScreen (main task list)
- TaskDetailScreen (view/edit individual task)
- LoginScreen
- SettingsScreen

### `/lib/widgets`
Reusable UI components:
- TaskCard (individual task display)
- CustomButton
- TaskListItem
- LoadingIndicator
- Custom form fields

### `/lib/services`
Business logic and external service integrations:
- ApiService (HTTP requests to Django backend)
- AuthService (authentication logic)
- LocalStorageService (offline data persistence)
- NotificationService

### `/lib/providers`
State management layer:
- TaskProvider (task state and CRUD operations)
- AuthProvider (authentication state)
- ThemeProvider (app theme management)

### `/lib/utils`
Helper functions and utilities:
- Date formatters
- Validators
- Constants
- Extension methods

### `/test`
Unit, widget, and integration tests:
- Mirrors the lib/ structure
- Each file in lib/ should have a corresponding test file
- TDD approach: write tests first!

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode (for mobile development)
- VS Code / Android Studio (recommended IDEs)

### Installation

1. Navigate to the frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Available Commands

```bash
# Run the app
flutter run

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Build for production (Android)
flutter build apk --release

# Build for production (iOS)
flutter build ios --release

# Build for web
flutter build web

# Analyze code
flutter analyze

# Format code
dart format .
```

## 🧪 Testing Strategy

This project follows Test-Driven Development (TDD):

1. **Unit Tests**: Test individual functions and classes
   - Models: serialization, validation
   - Utils: helper functions
   - Services: API calls (mocked)

2. **Widget Tests**: Test UI components in isolation
   - Widgets: render correctly, handle interactions
   - Screens: navigation, user flows

3. **Integration Tests**: Test complete user flows
   - End-to-end scenarios
   - Real user interactions

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/task_model_test.dart

# Run with coverage report
flutter test --coverage
```

## 📦 Dependencies

Key packages used in this project:

- **http** / **dio**: HTTP client for API calls
- **provider** / **riverpod**: State management
- **shared_preferences**: Local data persistence
- **intl**: Internationalization and date formatting
- **flutter_test**: Testing framework
- **mockito**: Mocking for tests

## 🎨 Design System

- **Material Design 3**: Modern UI components
- **Custom Theme**: Brand colors and typography
- **Responsive Layout**: Adapts to different screen sizes
- **Dark Mode**: Full dark theme support

## 🔧 Configuration

### API Configuration
Edit `lib/config/api_config.dart` to set your backend URL:

```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:8000/api';
  // or your production URL: 'https://api.ibn-nabil.com'
}
```

## 📱 Platform Support

- ✅ Android (5.0+)
- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ Windows (10/11)
- 🚧 iOS (requires macOS + Xcode)
- 🚧 macOS (requires macOS + Xcode)
- 🚧 Linux (requires GTK toolchain)

> Note: Desktop and Web platform folders are already generated in this repo (`windows/`, `web/`). If you ever need to re-generate platform folders, run `flutter create .` from the `frontend/` directory.

## 🧭 Cross‑platform testing (CLI)

You can run and test the app on Android, Web, and Windows directly from the CLI.

### 1) Prerequisites

- Flutter SDK installed and on PATH
- For Android: Android Studio (SDK, emulator/device set up)
- For Windows desktop: Visual Studio 2022 with Desktop development with C++ workload
- For Web: a modern browser (Chrome recommended)

### 2) Verify devices

```powershell
flutter devices
```

You should see entries like `windows`, `chrome`, and any connected Android device/emulator.

### 3) Run on Windows (desktop)

```powershell
flutter run -d windows
```

### 4) Run on Web (Chrome)

```powershell
flutter run -d chrome
```

Optional flags:
- `--web-renderer canvaskit` for improved fidelity on some UIs
- `--release` for a production-like run

### 5) Run on Android

Start an emulator from Android Studio or plug in a device, then:

```powershell
flutter run -d <android-device-id>
```

Tip: Use `flutter devices` to copy the device id. You can also run without `-d` if only one device is connected.

---

## � Platform-specific deployment

### Android

1. Bump version in `pubspec.yaml` (e.g., `version: 1.0.0+1`).
2. Create and configure signing keys (for Play Store) if you haven’t already.
3. Build release artifacts:

```powershell
# Universal APK (good for sideloading/testing)
flutter build apk --release

# App Bundle (required for Play Store)
flutter build appbundle --release
```

Artifacts output to `build/app/outputs/`. Upload the `.aab` to Google Play Console for distribution.

### Web

1. Build the production site:

```powershell
flutter build web --release
```

2. Deploy the contents of `build/web/` to any static host (GitHub Pages, Netlify, Firebase Hosting, Nginx, S3+CloudFront, etc.).

Notes:
- If hosting under a subpath, consider `--base-href` and `--pwa-strategy` settings.
- Configure your host for SPA fallback (serve `index.html` for unknown routes) if you add client-side routing.

### Windows (Desktop)

1. Build the desktop app:

```powershell
flutter build windows --release
```

2. Distribute the generated binaries from `build/windows/x64/runner/Release/`.

Packaging options:
- MSIX packaging via the `msix` package or Windows App SDK tooling (recommended for enterprise distribution/install/uninstall).
- ZIP the `Release/` folder for simple sharing (not signed).

> Tip: Code signing your Windows build improves trust and reduces SmartScreen warnings.

## 🤝 Contributing

1. Follow the existing folder structure
2. Write tests before implementing features (TDD)
3. Run `flutter analyze` before committing
4. Format code with `dart format .`
5. Update this README if adding new folders/patterns

## 📄 License

MIT License - see LICENSE file for details

## 🌐 Links

- **Website**: [ibn-nabil.com](https://ibn-nabil.com)
- **Backend API**: See `../backend/README.md`
- **Documentation**: [Flutter Docs](https://docs.flutter.dev/)

---

Built with Flutter 💙
