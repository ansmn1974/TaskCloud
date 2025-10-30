# Pre-Commit Checklist

Use this checklist before committing code to ensure code quality and security.

## 🔐 Security Check

- [ ] No hardcoded API keys or secrets
- [ ] No passwords or credentials in code
- [ ] `.env` file not staged (only `.env.example`)
- [ ] No sensitive Firebase config files staged
- [ ] No certificate or key files (.pem, .key, .jks)
- [ ] Run: `git diff --cached | grep -i "password\|secret\|key\|token"`

## 🧪 Testing

- [ ] All tests pass: `flutter test` (frontend)
- [ ] All tests pass: `python manage.py test` (backend)
- [ ] No failing tests
- [ ] New features have corresponding tests (TDD)
- [ ] Code coverage maintained or improved

## 📝 Code Quality

- [ ] Code follows project style guidelines
- [ ] No debug print statements or console.logs
- [ ] No commented-out code blocks
- [ ] Code is properly formatted
  - Flutter: `dart format .`
  - Python: `black . && isort .`
- [ ] No linter warnings: `flutter analyze`
- [ ] Documentation updated for new features

## 🎯 Functionality

- [ ] Code builds successfully
  - Flutter: `flutter build apk --debug`
  - Django: `python manage.py check`
- [ ] Manual testing completed for changes
- [ ] Edge cases handled
- [ ] Error handling implemented
- [ ] No breaking changes (or documented if necessary)

## 📦 Files & Structure

- [ ] Only relevant files staged
- [ ] No build artifacts staged
- [ ] No coverage reports staged
- [ ] No temporary files staged
- [ ] No node_modules or venv folders staged

## ✍️ Commit Message

- [ ] Clear, descriptive commit message
- [ ] Follows convention: `type: description`
  - Examples: `feat:`, `fix:`, `docs:`, `test:`, `refactor:`
- [ ] References issue number if applicable: `#123`

## 🚫 Never Commit to Main/Master

- [ ] Working on a feature branch (not main/master)
- [ ] Branch name is descriptive: `feature/add-task-list`
- [ ] Plan to create Pull Request, not push directly

## 🔍 Quick Commands

```bash
# 1. Check what you're committing
git status
git diff --staged

# 2. Search for secrets
git diff --cached | grep -iE "password|secret|key|token|api"

# 3. Check for unintended files
git status --ignored

# 4. Verify .gitignore is working
git check-ignore -v .env
git check-ignore -v secrets.dart

# 5. Run tests
cd frontend && flutter test
cd backend && python manage.py test

# 6. Format code
cd frontend && dart format .
cd backend && black . && isort .

# 7. Analyze code
cd frontend && flutter analyze
```

## ✅ If All Checks Pass

```bash
# Commit with descriptive message
git commit -m "feat: add task completion toggle functionality

- Added toggle button to task card
- Updated task provider with completion logic
- Added tests for task completion
- Closes #42"

# Push to feature branch
git push origin feature/your-feature-name

# Create Pull Request on GitHub
```

## ❌ If Checks Fail

1. **Fix issues first**
2. **Do not commit broken code**
3. **Do not push to main/master**
4. **Never use `--force` on shared branches**

---

**Remember**: Quality > Speed. Take time to ensure code is clean, tested, and secure.
