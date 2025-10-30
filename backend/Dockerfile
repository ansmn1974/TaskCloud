# TaskCloud Backend Dockerfile
# Multi-purpose image running Django (gunicorn) behind Caddy for HTTPS/HTTP

FROM python:3.13-slim AS app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps first (leverage cache)
COPY backend/requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && pip install -r /app/requirements.txt gunicorn

# Add Caddy APT repo and install Caddy
RUN apt-get update && apt-get install -y --no-install-recommends \
    debian-keyring debian-archive-keyring apt-transport-https \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
    && apt-get update && apt-get install -y caddy \
    && rm -rf /var/lib/apt/lists/*

# Copy project
COPY backend /app

# Collect static assets for production
ENV DJANGO_DEBUG=false \
    DJANGO_SECRET_KEY=docker-build-temp-key
RUN python manage.py collectstatic --noinput

# Copy Caddyfile and entrypoint
COPY backend/Caddyfile /etc/caddy/Caddyfile
COPY backend/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Network
EXPOSE 8080

# Healthcheck: basic schema availability check
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD curl -fsS http://localhost:8080/api/schema/ >/dev/null || exit 1

# Default env (override in production)
ENV DJANGO_ALLOWED_HOSTS="*" \
    CADDY_DOMAIN=localhost \
    CADDY_EMAIL=admin@example.com

CMD ["/entrypoint.sh"]
