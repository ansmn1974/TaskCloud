# TaskCloud Backend Dockerfile
# Production Django app with gunicorn, works with external reverse proxy

FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# System deps (including PostgreSQL client for psycopg2 and netcat for health checks)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates build-essential libpq-dev netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps first (leverage cache)
COPY requirements.txt /app/
RUN pip install --upgrade pip && \
    pip install -r requirements.txt gunicorn psycopg2-binary

# Copy project
COPY . /app/

# Collect static assets for production
ENV DJANGO_DEBUG=false \
    DJANGO_SECRET_KEY=docker-build-temp-key
RUN python manage.py collectstatic --noinput

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Network: expose gunicorn port for reverse proxy
EXPOSE 8000

# Healthcheck for reverse proxy
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD curl -fsS http://localhost:8000/health/ >/dev/null || exit 1

CMD ["/entrypoint.sh"]
