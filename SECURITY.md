# Security Configuration Guide

## 🔐 Security Best Practices for TaskCloud

This guide ensures you never accidentally commit sensitive information to your repository.

## ⚠️ NEVER COMMIT THESE

### 1. Environment Variables & Secrets
```dart
// ❌ NEVER hardcode in files:
const apiKey = 'sk_live_abc123...';
const databaseUrl = 'postgresql://user:password@host:5432/db';
const jwtSecret = 'my-secret-key';

// ✅ ALWAYS use environment configuration:
final apiKey = Environment.apiKey;
final databaseUrl = Environment.databaseUrl;
```

### 2. API Keys & Credentials
- Google API keys
- Firebase configuration
- OAuth client secrets
- Database passwords
- JWT secrets
- Third-party service tokens

### 3. Certificate & Key Files
- `.pem` files
- `.key` files
- `.p12` certificates
- Android keystores (`.jks`, `.keystore`)
- iOS provisioning profiles

## 📋 Files to NEVER Commit

### Backend (Django)
```
.env
.env.local
.env.production
db.sqlite3
*.pem
*.key
settings_local.py
secrets.json
```

### Frontend (Flutter)
```
.env
secrets.dart
api_keys.dart
google-services.json
GoogleService-Info.plist
firebase_options.dart
android/key.properties
android/app/upload-keystore.jks
```

## ✅ Safe Configuration Pattern

### Step 1: Create Environment Files (Git-ignored)

**`.env.example`** (Safe to commit - no real values):
```bash
# API Configuration
API_BASE_URL=http://localhost:8000
API_KEY=your_api_key_here

# Firebase (get from Firebase Console)
FIREBASE_API_KEY=your_firebase_key
FIREBASE_PROJECT_ID=your_project_id

# Database
DATABASE_URL=your_database_url
```

**`.env`** (NOT committed - contains real values):
```bash
API_BASE_URL=https://api.ibn-nabil.com
API_KEY=sk_live_actual_key_here
FIREBASE_API_KEY=AIzaSyC...actual_key
DATABASE_URL=postgresql://real_connection_string
```

### Step 2: Load Environment Variables

**Flutter - `lib/config/environment.dart`**:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
}
```

**Usage**:
```dart
void main() async {
  await Environment.load();
  runApp(MyApp());
}

// Use in code
final response = await http.get(
  '${Environment.apiBaseUrl}/tasks',
  headers: {'Authorization': 'Bearer ${Environment.apiKey}'},
);
```

## 🛡️ Pre-Commit Checklist

Before committing code, verify:

```bash
# 1. Check what you're about to commit
git status
git diff

# 2. Search for potential secrets
git diff | grep -i "password\|secret\|key\|token\|api"

# 3. Check for hardcoded credentials
git grep -i "password\|secret\|api_key" -- '*.dart' '*.py'

# 4. Verify .gitignore is working
git check-ignore -v .env
git check-ignore -v secrets.dart

# 5. Test that secrets are NOT staged
git diff --cached | grep -i "password\|secret\|key"
```

## 🚫 Common Mistakes to Avoid

### ❌ Mistake 1: Hardcoded Credentials
```dart
class ApiService {
  final String apiKey = 'sk_live_abc123...'; // ❌ NEVER DO THIS
}
```

### ✅ Correct Way:
```dart
class ApiService {
  final String apiKey;
  ApiService({required this.apiKey}); // ✅ Inject from environment
}
```

### ❌ Mistake 2: Committing .env Files
```bash
git add .env  # ❌ NEVER DO THIS
```

### ✅ Correct Way:
```bash
git add .env.example  # ✅ Template without real values
```

### ❌ Mistake 3: Secrets in Comments
```dart
// TODO: Replace with real key: sk_live_abc123...  // ❌ Still exposed!
const apiKey = Environment.apiKey;
```

### ✅ Correct Way:
```dart
// TODO: Configure API key in .env file  // ✅ Safe comment
const apiKey = Environment.apiKey;
```

## 🔍 Detecting Accidentally Committed Secrets

If you accidentally committed secrets:

### 1. Remove from History (Immediate)
```bash
# Remove file from last commit
git rm --cached secrets.dart
git commit --amend -m "Remove secrets file"

# If already pushed, you MUST:
# 1. Change all exposed credentials immediately
# 2. Use git-filter-branch or BFG Repo-Cleaner to remove from history
```

### 2. Rotate All Exposed Credentials
- Generate new API keys
- Update database passwords
- Regenerate JWT secrets
- Revoke old tokens

### 3. Never Force Push to Main
```bash
# ❌ DANGEROUS - rewrites history
git push --force origin main

# ✅ Create new commit to remove secrets
git rm secrets.dart
git commit -m "Remove sensitive data"
git push origin main
```

## 📦 Coverage Files

Coverage reports contain file paths and may expose project structure:

```bash
# NEVER commit these:
coverage/
*.lcov
coverage_badge.svg
test/.test_coverage.dart
```

## 🎯 Branch Protection Rules

### Main/Master Branch Should:
1. ✅ Require pull request reviews
2. ✅ Require status checks to pass
3. ✅ Require branches to be up to date
4. ✅ Prohibit force pushes
5. ✅ Require signed commits (optional but recommended)

### Never Push Directly:
```bash
# ❌ Don't do this on main:
git push origin main

# ✅ Always use feature branches:
git checkout -b feature/add-task-feature
git push origin feature/add-task-feature
# Then create Pull Request
```

## 🔐 Additional Security Measures

### 1. Use Git Secrets Tool
```bash
# Install git-secrets
git secrets --install
git secrets --register-aws

# Scan for secrets
git secrets --scan
```

### 2. Enable Two-Factor Authentication
- GitHub account
- Deployment services
- Cloud providers

### 3. Regular Security Audits
```bash
# Check for vulnerabilities
flutter pub outdated
flutter pub audit

# Python dependencies (backend)
pip-audit
safety check
```

### 4. Sensitive Data in Code Reviews
- Never approve PRs with hardcoded credentials
- Check for .env files in commits
- Verify secrets are in .gitignore

## 📚 Quick Reference

### Safe to Commit:
✅ `.env.example` (template)
✅ Source code
✅ Tests
✅ Documentation
✅ Configuration templates
✅ README files

### NEVER Commit:
❌ `.env` (real values)
❌ `secrets.dart`
❌ API keys
❌ Passwords
❌ Certificates
❌ Coverage reports
❌ Database files
❌ Build artifacts
❌ WIP/test code on main branch

## 🆘 Emergency: Secrets Exposed

If secrets are exposed in your repository:

1. **Immediately revoke/rotate all exposed credentials**
2. **Remove from Git history using BFG Repo-Cleaner**
3. **Force push cleaned history**
4. **Notify team members to re-clone**
5. **Update all affected systems with new credentials**
6. **Document incident for future prevention**

---

**Remember**: It's easier to prevent secrets exposure than to clean up after. Always double-check before committing!

**Website**: [ibn-nabil.com](https://ibn-nabil.com)  
**Last Updated**: October 29, 2025
