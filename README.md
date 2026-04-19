# Bookmark Manager - Production-Ready Web Application

A full-stack Django bookmark management application demonstrating modern containerization, deployment, and DevOps practices.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                          User                                │
└────────────────────────────┬────────────────────────────────┘
                             │
                    ┌────────▼────────┐
                    │    Nginx        │ (Reverse Proxy)
                    │  (Port 80/443)  │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        │            ┌───────▼───────┐            │
        │            │  Gunicorn     │ × 3 (HA)   │
        │            │  (Django App) │            │
        │            └───────┬───────┘            │
        │                    │                    │
   ┌────▼────┐   ┌──────────▼──────────┐   ┌────▼────┐
   │ Static  │   │  Django Core Apps   │   │  Media  │
   │  Files  │   │  - Bookmarks        │   │  Files  │
   └─────────┘   └──────────┬──────────┘   └────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
    ┌───▼────┐        ┌─────▼─────┐       ┌────▼───┐
    │PostgreSQL       │   Redis   │       │ Volumes│
    │Database         │ (Cache)   │       │(Persist)
    └────────┘        └───────────┘       └────────┘
```

## Quick Start

### Prerequisites
- Docker & Docker Compose (v2.0+)
- Git

### Local Development

```bash
# Clone repository
git clone <repo-url>
cd bookmark-manager

# Create environment file
cp .env.example .env

# Start services
docker compose up -d

# Create database tables
docker compose exec web sh -c "PYTHONPATH=/app python bookmarks/django_manage.py makemigrations"
docker compose exec web sh -c "PYTHONPATH=/app python bookmarks/django_manage.py migrate"

# Create admin user
docker compose exec web sh -c "PYTHONPATH=/app python bookmarks/django_manage.py createsuperuser"

# Access application
# - Application: http://localhost
# - Admin panel: http://localhost/admin
# - API health: http://localhost/health/
```

### Docker Compose Services

| Service | Port | Purpose |
|---------|------|---------|
| nginx | 80 | Reverse proxy, static files |
| django | 8000 | Django application (internal) |
| postgres | 5433 | PostgreSQL database |
| redis | 6379 | Cache & sessions |

## Environment Variables

Create `.env` file (see `.env.example`):

```env
# Django Settings
DEBUG=1                              # 0 for production
SECRET_KEY=your-secret-key-here     # Generate: python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"

# Database
DB_NAME=bookmarks
DB_USER=postgres
DB_PASSWORD=postgres

# Features
REDIS_URL=redis://redis:6379/0
```

**SECURITY:** Never commit `.env` to version control. Use `.env.example` for documentation.

## Features

✅ **Bookmark Management**
- Save, edit, delete bookmarks
- Mark favorites
- Search functionality
- Cache optimization (Redis)

✅ **Production Ready**
- Docker containerization
- Multi-service orchestration
- Health checks & monitoring
- Automated backups
- SSL/TLS support

✅ **High Availability**
- Stateless Django (horizontal scaling)
- Database persistence (PostgreSQL)
- Session caching (Redis)
- Nginx load balancing

## Deployment

### Docker Compose (Single Host)

```bash
# Development
docker compose up -d

# Production (with .env configured)
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### Kubernetes (Multi-Host)

```bash
# Prerequisites: kubectl configured, Docker images pushed to registry

# Edit k8s/deployment.yaml with your values
nano k8s/deployment.yaml

# Deploy
kubectl apply -f k8s/deployment.yaml

# Verify
kubectl get all -n bookmark-manager
```

See [k8s/README.md](k8s/README.md) for detailed Kubernetes setup.

### Cloud Platforms

**AWS ECS:**
```bash
# Push image to ECR
aws ecr get-login-password | docker login --username AWS --password-stdin <account>.dkr.ecr.us-east-1.amazonaws.com
docker tag bookmark-manager-web:latest <account>.dkr.ecr.us-east-1.amazonaws.com/bookmark-manager:latest
docker push <account>.dkr.ecr.us-east-1.amazonaws.com/bookmark-manager:latest

# Create task definition and service in AWS console
```

**DigitalOcean App Platform:**
```bash
# Push to Docker Hub
docker push yourusername/bookmark-manager:latest

# Connect in DigitalOcean App Platform dashboard
```

## Maintenance

### Backups

```bash
# Automated daily backup (add to crontab)
0 2 * * * /path/to/bookmark-manager/backup.sh

# Manual backup
./backup.sh

# Restore from backup
./restore.sh backups/db_20260418_143000.sql.gz
```

### Monitoring

```bash
# View logs
docker compose logs -f web

# Container stats
docker stats

# Health check
curl http://localhost/health/
```

### Database Migrations

```bash
# Create new migration after model changes
docker compose exec web sh -c "PYTHONPATH=/app python bookmarks/django_manage.py makemigrations core"

# Apply migrations
docker compose exec web sh -c "PYTHONPATH=/app python bookmarks/django_manage.py migrate"

# See migration status
docker compose exec web sh -c "PYTHONPATH=/app python bookmarks/django_manage.py showmigrations"
```

### Updates

```bash
# Pull latest code
git pull origin main

# Rebuild images
docker compose build

# Apply migrations + restart
docker compose up -d

# Verify health
curl http://localhost/health/
```

## Security

### Development vs Production

**Development (.env)**
```env
DEBUG=1                 # Show errors
SECRET_KEY=dev-key      # Insecure key
```

**Production (.env.prod)**
```env
DEBUG=0                 # Hide errors
SECRET_KEY=<random>     # Secure random key
ALLOWED_HOSTS=example.com,www.example.com
```

### Best Practices

- ✅ Run containers as non-root user
- ✅ Use environment variables for secrets
- ✅ Enable HTTPS/SSL
- ✅ Regular security updates
- ✅ Database backups
- ✅ Monitoring & alerts
- ✅ Limit container resources

### SSL/TLS

```bash
# Generate self-signed certificate (dev)
openssl req -x509 -newkey rsa:4096 -nodes -out cert.pem -keyout key.pem -days 365

# Use Let's Encrypt (production)
# See nginx/ssl/ for Certbot setup
```

## Development

### Project Structure

```
bookmark-manager/
├── bookmarks/              # Django project
│   ├── core/              # Main app (models, views)
│   ├── settings.py        # Configuration
│   ├── wsgi.py            # WSGI entry point
│   └── django_manage.py   # Django management
├── nginx/                 # Nginx config
│   ├── nginx.conf         # Reverse proxy config
│   ├── entrypoint.sh      # Wait for web service
│   └── Dockerfile         # Nginx image
├── docker-compose.yml     # Local development
├── docker-compose.prod.yml # Production overrides
├── Dockerfile             # Django development image
├── Dockerfile.prod        # Django production image (multi-stage)
├── k8s/                   # Kubernetes manifests
├── backup.sh              # Backup script
└── restore.sh             # Restore script
```

### Adding Features

1. **Create Django app:**
   ```bash
   docker compose exec web python bookmarks/django_manage.py startapp myapp
   ```

2. **Create model:**
   ```python
   # myapp/models.py
   class MyModel(models.Model):
       name = models.CharField(max_length=200)
   ```

3. **Create migrations:**
   ```bash
   docker compose exec web sh -c "PYTHONPATH=/app python bookmarks/django_manage.py makemigrations"
   docker compose exec web sh -c "PYTHONPATH=/app python bookmarks/django_manage.py migrate"
   ```

4. **Create views & URLs**
5. **Test & deploy**

### Testing

```bash
# Run all tests
docker compose exec web python bookmarks/django_manage.py test

# Run specific test
docker compose exec web python bookmarks/django_manage.py test bookmarks.core.tests.BookmarkTestCase

# Test with coverage
docker compose exec web coverage run --source='.' manage.py test
docker compose exec web coverage report
```

## API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/` | GET | List all bookmarks |
| `/add/` | POST | Create bookmark |
| `/health/` | GET | Health check (monitoring) |
| `/ready/` | GET | Readiness probe (K8s) |
| `/live/` | GET | Liveness probe (K8s) |
| `/admin/` | GET | Admin panel |

## CI/CD Pipeline

GitHub Actions workflow: `.github/workflows/ci-cd.yml`

**Stages:**
1. **Test:** Run pytest, linting
2. **Build:** Build Docker images
3. **Security Scan:** Trivy vulnerability scan
4. **Deploy Staging:** Push to develop branch
5. **Deploy Production:** Push to tagged release

**Secrets needed in GitHub:**
- `DEPLOY_KEY` - SSH key for deployments
- `DEPLOY_HOST_STAGING` - Staging server
- `DEPLOY_HOST_PROD` - Production server
- `DEPLOY_USER` - Deployment user

## Monitoring & Alerts

### Health Checks

```bash
# Application health
curl http://localhost/health/

# Database connectivity
curl http://localhost/ready/

# Container liveness
curl http://localhost/live/
```

### Logs

```bash
# All services
docker compose logs

# Specific service
docker compose logs -f django

# Last 100 lines
docker compose logs --tail=100 nginx
```

### Container Stats

```bash
docker stats
```

## Troubleshooting

### Services won't start

```bash
# Check logs
docker compose logs

# Check Docker daemon
docker ps

# Restart all services
docker compose restart

# Rebuild images
docker compose build --no-cache
docker compose up -d
```

### Database connection error

```bash
# Check PostgreSQL is running
docker compose ps postgres

# Check logs
docker compose logs postgres

# Verify connection
docker compose exec db psql -U postgres -d bookmarks -c "SELECT 1"
```

### Static files not serving

```bash
# Collect static files
docker compose exec web sh -c "PYTHONPATH=/app python bookmarks/django_manage.py collectstatic --noinput"

# Check volume
docker volume inspect bookmark-manager_static_volume
```

### Cache not working

```bash
# Check Redis is running
docker compose ps redis

# Test connection
docker compose exec redis redis-cli ping

# View cached keys
docker compose exec redis redis-cli KEYS "*"
```

## Performance Optimization

### Database
- Index frequently queried fields
- Use select_related() for foreign keys
- Use prefetch_related() for reverse relations
- Monitor slow queries

### Caching
- Cache expensive queries (already done in views)
- Set appropriate TTLs
- Clear cache on data updates

### Frontend
- Minify CSS/JavaScript
- Enable gzip compression (nginx)
- Use CDN for static files
- Enable browser caching headers

### Application
- Use connection pooling (PgBouncer)
- Optimize gunicorn workers (4 × CPU cores)
- Enable keep-alive connections
- Monitor response times

## Contributing

1. Fork repository
2. Create feature branch: `git checkout -b feature/my-feature`
3. Commit changes: `git commit -am 'Add my feature'`
4. Push to branch: `git push origin feature/my-feature`
5. Submit pull request

## License

MIT License - See LICENSE file

## Support

For issues, questions, or improvements:
1. Check existing issues
2. Create detailed bug report
3. Include logs and environment details

## Resources

- **Django:** https://docs.djangoproject.com/
- **Docker:** https://docs.docker.com/
- **PostgreSQL:** https://www.postgresql.org/docs/
- **Nginx:** https://nginx.org/en/docs/
- **Kubernetes:** https://kubernetes.io/docs/
- **GitHub Actions:** https://docs.github.com/en/actions

---


