# TaskCloud Backend - VPS Deployment Guide

This guide walks you through deploying the TaskCloud Django backend to your Hostinger VPS with Postgres and Caddy.

## Prerequisites

- VPS with Docker and Docker Compose installed
- Caddy already configured and running (serving api.ibn-nabil.com)
- SSH access to your VPS
- GitHub repository: https://github.com/ansmn1974/TaskCloud

## Deployment Steps

### 1. Connect to VPS

```bash
ssh your-username@your-vps-ip
```

### 2. Clone Repository

```bash
cd /var/www  # or your preferred location
git clone https://github.com/ansmn1974/TaskCloud.git
cd TaskCloud/backend
```

### 3. Create Production Environment File

Create `.env` file with your production values:

```bash
nano .env
```

Add the following (replace with your actual values):

```env
# Django Settings
DJANGO_SECRET_KEY=your-super-secret-key-here-min-50-chars
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=api.ibn-nabil.com

# Postgres Database
POSTGRES_DB=taskcloud_db
POSTGRES_USER=taskcloud_user
POSTGRES_PASSWORD=your-secure-postgres-password

# Database URL (ensure it matches the above credentials)
DATABASE_URL=postgres://taskcloud_user:your-secure-postgres-password@postgres:5432/taskcloud_db

# Gunicorn Workers (adjust based on CPU cores: 2-4 x cores)
GUNICORN_WORKERS=4
```

**Important Security Notes:**
- Generate a strong SECRET_KEY: `python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'`
- Use a strong POSTGRES_PASSWORD (minimum 16 characters with mixed case, numbers, symbols)
- Keep DEBUG=False in production
- Never commit `.env` to git

### 4. Build and Start Containers

```bash
# Build and start in detached mode
docker-compose up -d --build
```

This will:
- Pull Postgres 16 image
- Build Django app container
- Wait for Postgres to be healthy
- Run database migrations
- Start gunicorn on 0.0.0.0:8000

### 5. Verify Deployment

Check container status:
```bash
docker-compose ps
```

Both containers should show "healthy" status.

Check logs:
```bash
# View all logs
docker-compose logs

# Follow logs in real-time
docker-compose logs -f

# View just the app logs
docker-compose logs taskcloud
```

Test health endpoint (local):
```bash
curl http://localhost:8000/health/
# Expected: {"status":"healthy"}
```

Test API endpoint (local):
```bash
curl http://localhost:8000/api/tasks/
# Expected: [] (empty list initially)
```

Test through Caddy (public):
```bash
curl https://api.ibn-nabil.com/health/
# Expected: {"status":"healthy"}
```

Test API through Caddy:
```bash
curl https://api.ibn-nabil.com/api/tasks/
# Expected: [] (empty list)
```

### 6. Create Superuser (Optional)

To access Django admin at https://api.ibn-nabil.com/admin/:

```bash
docker-compose exec taskcloud python manage.py createsuperuser
```

Follow prompts to set username, email, and password.

## Common Commands

### View Logs
```bash
docker-compose logs -f taskcloud
```

### Restart Services
```bash
docker-compose restart
```

### Stop Services
```bash
docker-compose down
```

### Update Code
```bash
git pull origin main
docker-compose up -d --build
```

### Run Migrations
```bash
docker-compose exec taskcloud python manage.py migrate
```

### Collect Static Files (if needed)
```bash
docker-compose exec taskcloud python manage.py collectstatic --noinput
```

### Backup Database
```bash
docker-compose exec postgres pg_dump -U taskcloud_user taskcloud_db > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore Database
```bash
docker-compose exec -T postgres psql -U taskcloud_user taskcloud_db < backup_file.sql
```

## Troubleshooting

### Container Won't Start
```bash
# Check logs
docker-compose logs taskcloud

# Check if port 8000 is available
sudo netstat -tlnp | grep 8000
```

### Database Connection Issues
```bash
# Verify Postgres is running
docker-compose ps postgres

# Check Postgres logs
docker-compose logs postgres

# Test connection from app container
docker-compose exec taskcloud python manage.py dbshell
```

### Caddy Can't Reach Backend
```bash
# Verify gunicorn is listening
docker-compose exec taskcloud netstat -tlnp | grep 8000

# Check if port binding is correct
docker-compose ps taskcloud

# Test from VPS host
curl http://127.0.0.1:8000/health/
```

### Permission Issues
```bash
# Ensure proper ownership (if needed)
sudo chown -R $USER:$USER /var/www/TaskCloud
```

## Security Checklist

- [ ] `.env` file is not in git (check `.gitignore`)
- [ ] `DJANGO_DEBUG=False` in production
- [ ] Strong `DJANGO_SECRET_KEY` (50+ characters)
- [ ] Strong `POSTGRES_PASSWORD` (16+ characters)
- [ ] `ALLOWED_HOSTS` set to `api.ibn-nabil.com`
- [ ] Caddy HTTPS is working (check certificate)
- [ ] Health endpoint returns 200 at https://api.ibn-nabil.com/health/
- [ ] Firewall configured (only 80, 443, SSH open)
- [ ] Regular database backups scheduled

## API Endpoints

Once deployed, your API will be available at:

- **Health Check**: `GET https://api.ibn-nabil.com/health/`
- **List/Create Tasks**: `GET/POST https://api.ibn-nabil.com/api/tasks/`
- **Task Detail**: `GET/PUT/PATCH/DELETE https://api.ibn-nabil.com/api/tasks/{uuid}/`
- **API Schema**: `GET https://api.ibn-nabil.com/api/schema/`
- **Swagger UI** (DEBUG only): `GET https://api.ibn-nabil.com/api/schema/swagger-ui/`
- **ReDoc** (DEBUG only): `GET https://api.ibn-nabil.com/api/schema/redoc/`

## Next Steps

1. **Test API endpoints** with curl or Postman
2. **Update Flutter frontend** with production API base URL: `https://api.ibn-nabil.com`
3. **Implement 1-hour auto-delete** management command with cron
4. **Set up monitoring** (consider UptimeRobot or similar)
5. **Configure automated backups** (cron job with pg_dump)

## Support

For issues or questions:
- GitHub Issues: https://github.com/ansmn1974/TaskCloud/issues
- Website: https://ibn-nabil.com
