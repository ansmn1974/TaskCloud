#!/usr/bin/env bash
set -euo pipefail

# Default to 2 workers for gunicorn unless overridden
: "${GUNICORN_WORKERS:=2}"
: "${GUNICORN_BIND:=127.0.0.1:8000}"

# Run database migrations (optional for stateless start; comment out if using managed migrations)
python manage.py migrate --noinput || true

# Start gunicorn (Django WSGI)
(
  exec gunicorn taskcloud.wsgi:application \
    --workers "$GUNICORN_WORKERS" \
    --bind "$GUNICORN_BIND" \
    --access-logfile - \
    --error-logfile -
) &

# Start Caddy (reverse proxy + static)
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
