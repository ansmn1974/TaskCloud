# TaskCloud Backend (Django REST Framework)

This backend will provide a secure REST API for the TaskCloud Flutter app. It follows TDD, clean project structure, and production-ready practices.

## Goals

- Session-based task expiration on server: tasks auto-delete ~1 hour after creation (server-only; local app persists until user deletes).
- JWT auth ready (can be enabled later).
- Clean separation of apps: `core`, `tasks`, `users`.
- Well-documented, covered by tests.

## Project Structure (planned)

```
backend/
├── manage.py
├── pyproject.toml            # or requirements.txt + pip-tools
├── .env.example              # sample env vars (never commit real secrets)
├── taskcloud/                # project settings
│   ├── __init__.py
│   ├── settings.py           # 12-factor settings using env vars
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
├── apps/
│   ├── core/
│   │   ├── apps.py
│   │   └── management/commands/  # utilities
│   ├── tasks/
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   ├── selectors.py       # query/read paths
│   │   ├── services.py        # write business logic
│   │   └── tests/
│   └── users/
│       ├── models.py
│       ├── serializers.py
│       ├── views.py
│       ├── urls.py
│       └── tests/
└── tests/                      # high-level API tests
```

## TDD Workflow

1. Write failing tests (pytest + DRF APITestCase or APIClient).
2. Implement minimal models/serializers/views to pass tests.
3. Refactor and keep tests green.

Recommended stack:
- pytest, pytest-django, model-bakery/factory-boy
- django-environ for settings via `.env`
- drf-spectacular for OpenAPI schema
- django-cors-headers for local dev

## Environment & Security

- Copy `.env.example` → `.env` and fill in values.
- Never commit `.env` or secrets.
- Use `DEBUG=false` and secure settings in production.

Example `.env.example` (planned):
```
DJANGO_SECRET_KEY=replace-me
DJANGO_DEBUG=true
DJANGO_ALLOWED_HOSTS=*
DATABASE_URL=sqlite:///db.sqlite3
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5000
```

## API Contract (initial)

- `POST /api/tasks/` create a task
- `GET /api/tasks/` list tasks
- `PATCH /api/tasks/{id}/` update fields (title, description, is_completed, due_date)
- `DELETE /api/tasks/{id}/` delete a task

Task fields:
- `id: UUID`
- `title: string (max 200)`
- `description: string (optional)`
- `created_at: datetime (server)`
- `due_date: datetime (optional)`
- `is_completed: boolean`

## 1-hour auto-delete policy (server-only)

- Server will remove tasks ~60 minutes after `created_at`.
- Implementation options:
  - DB-level: a periodic job (Celery beat/Redis) deleting expired rows.
  - App-level: filter out expired tasks and soft-delete or hard-delete via cron/APS scheduler.
- For MVP, a simple management command + cron/Windows Task Scheduler can be used.
- The Flutter app keeps local copies until user deletion; server expiration is communicated via UI.

## Local Development (planned)

```
python -m venv .venv
. .venv/bin/activate  # Windows: .venv\\Scripts\\activate
pip install -U pip
pip install -r requirements.txt  # or: pip install -e . with pyproject
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
```

Run tests:
```
pytest -q
```

## Deployment (high-level)

- Use environment variables for all secrets and settings.
- Containerize with Docker and a production server (gunicorn/uvicorn) behind Nginx.
- Use a managed Postgres (e.g., RDS, Cloud SQL) or a self-hosted instance.
- Apply periodic job for pruning expired tasks.

## Next Steps

- Initialize Django project and apps.
- Write model tests for `Task` and API tests for CRUD.
- Implement minimal serializers/views/urls to pass tests.
- Add `drf-spectacular` and publish OpenAPI schema.
