#!/usr/bin/env bash
set -euo pipefail

# Default to 2 workers for gunicorn unless overridden
: "${GUNICORN_WORKERS:=2}"
: "${GUNICORN_BIND:=0.0.0.0:8000}"

echo "Waiting for PostgreSQL..."
while ! nc -z ${POSTGRES_HOST:-postgres} ${POSTGRES_PORT:-5432}; do
  sleep 1
done
echo "PostgreSQL is ready!"

# Run database migrations
echo "Running migrations..."
python manage.py migrate --noinput

# Start gunicorn (Django WSGI) - bind to 0.0.0.0 for external reverse proxy
echo "Starting gunicorn on ${GUNICORN_BIND}..."
exec gunicorn taskcloud.wsgi:application \
  --workers "$GUNICORN_WORKERS" \
  --bind "$GUNICORN_BIND" \
  --access-logfile - \
  --error-logfile - \
  --log-level info
