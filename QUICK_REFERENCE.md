# Quick Reference Guide

## 🚀 Get Started in 2 Minutes

```bash
# Clone and navigate
git clone <repo-url> && cd bookmark-manager

# Start services
docker compose up -d

# Check health
curl http://localhost/health/

# Done! 🎉
```

---

## 📋 Essential Commands

### Development

```bash
# Start all services
docker compose up -d

# See logs
docker compose logs -f django

# Stop all services
docker compose down

# View all containers
docker compose ps

# Execute command in container
docker compose exec web sh -c "PYTHONPATH=/app python bookmarks/django_manage.py shell"
```

### Database

```bash
# Connect to database
docker compose exec db psql -U postgres -d bookmarks

# Create migrations
docker compose exec web sh -c "PYTHONPATH=/app python bookmarks/django_manage.py makemigrations"

# Apply migrations
docker compose exec web sh -c "PYTHONPATH=/app python bookmarks/django_manage.py migrate"

# Backup
./backup.sh

# Restore
./restore.sh backups/db_20260418_143000.sql.gz
```

### Monitoring

```bash
# Application health
curl http://localhost/health/

# Kubernetes readiness
curl http://localhost/ready/

# Kubernetes liveness
curl http://localhost/live/

# Container stats
docker stats

# View logs
docker compose logs -f <service>
```

---

## 🐳 Docker Concepts

| Concept | Explanation | Example |
|---------|-------------|---------|
| **Image** | Blueprint for container | `python:3.11-slim` |
| **Container** | Running instance of image | `bookmark_web_1` |
| **Volume** | Persistent storage | `postgres_data:/var/lib/postgresql/data` |
| **Bind Mount** | Host folder → container | `.:/app` |
| **Service** | Named container in compose | `web`, `db`, `nginx` |
| **Network** | Communication between services | Automatic in docker-compose |
| **Port** | External access | `80:80` (host:container) |

---

## 🏗️ Architecture Layers

```
Layer 1 - User Interface
├─ Browser
└─ HTTP Requests

Layer 2 - Web Server
├─ Nginx (Port 80)
├─ Static Files
└─ Request Routing

Layer 3 - Application Server
├─ Gunicorn (Port 8000)
├─ Django App
└─ Business Logic

Layer 4 - Data Layer
├─ PostgreSQL (Port 5432)
├─ Redis (Port 6379)
└─ Persistent Storage
```

---

## 🔐 Environment Variables

| Variable | Purpose | Default |
|----------|---------|---------|
| `DEBUG` | Show errors (dev only) | `1` |
| `SECRET_KEY` | Django security key | Must set |
| `DB_NAME` | Database name | `bookmarks` |
| `DB_USER` | Database user | `postgres` |
| `DB_PASSWORD` | Database password | `postgres` |
| `DB_HOST` | Database host | `db` |
| `REDIS_URL` | Cache connection | `redis://redis:6379/0` |

**Never commit `.env` - use `.env.example` instead**

---

## 📁 Project Structure

```
bookmark-manager/
├── Dockerfile                 # Dev image
├── Dockerfile.prod           # Prod image (multi-stage)
├── docker-compose.yml        # Services setup
├── requirements.txt          # Python packages
├── .env.example             # Config template
├── .gitignore               # Git exclusions
│
├── bookmarks/               # Django project
│   ├── core/               # Main app
│   │   ├── models.py       # Database schemas
│   │   ├── views.py        # Request handlers
│   │   └── urls.py         # URL routes
│   ├── settings.py         # Configuration
│   ├── wsgi.py             # WSGI entry
│   └── django_manage.py    # CLI tool
│
├── nginx/                   # Reverse proxy
│   ├── nginx.conf          # Configuration
│   ├── Dockerfile          # Build image
│   └── entrypoint.sh       # Startup script
│
├── k8s/                     # Kubernetes
│   ├── deployment.yaml     # K8s manifests
│   └── README.md           # K8s guide
│
├── backup.sh               # Backup script
├── restore.sh              # Restore script
│
└── README.md               # This project
```

---

## 🛠️ Problem Solving

### "Services won't start"
```bash
# Check logs
docker compose logs

# Restart services
docker compose restart

# Rebuild images
docker compose build --no-cache
docker compose up -d
```

### "Database connection error"
```bash
# Check postgres is running
docker compose ps postgres

# Check logs
docker compose logs postgres

# Test connection
docker compose exec db psql -U postgres -d bookmarks -c "SELECT 1"
```

### "Static files not loading"
```bash
# Collect static files
docker compose exec web sh -c "PYTHONPATH=/app python bookmarks/django_manage.py collectstatic --noinput"

# Check nginx config
docker compose logs nginx
```

### "Port already in use"
```bash
# Find what's using the port
lsof -i :80        # macOS/Linux
Get-NetTCPConnection -LocalPort 80  # Windows

# Change port in docker-compose.yml
# Or kill the process using it
```

### "Out of disk space"
```bash
# Check Docker disk usage
docker system df

# Clean up
docker system prune -a
docker volume prune
```

---

## 📊 Performance Tips

| Area | Optimization | How |
|------|---------------|-----|
| **Image Size** | Multi-stage build | Dockerfile.prod |
| **Caching** | Use Redis | Already configured |
| **Database** | Index fields | Add to models |
| **Static Files** | Serve via nginx | Already configured |
| **Compression** | Enable gzip | nginx already does |
| **Scaling** | Horizontal | Add K8s HPA |

---

## 🔒 Security Checklist

- ✅ Non-root user in containers
- ✅ .env excluded from git
- ✅ SECRET_KEY randomized
- ✅ DEBUG=0 in production
- ✅ CSRF protection enabled
- ⚠️ Add SSL/TLS (in roadmap)
- ⚠️ Add security headers (in roadmap)
- ⚠️ Regular dependency updates

---

## 📞 Getting Help

### Common Errors

**"ModuleNotFoundError: No module named 'bookmarks'"**
- Solution: Ensure `PYTHONPATH=/app` is set

**"Connection refused"**
- Solution: Check if services are running (`docker compose ps`)

**"No such file or directory"**
- Solution: Check file exists and paths are correct

### Resources

- Docker: https://docs.docker.com/
- Django: https://docs.djangoproject.com/
- PostgreSQL: https://www.postgresql.org/docs/
- Nginx: https://nginx.org/en/docs/
- Kubernetes: https://kubernetes.io/docs/

### Get Support

1. Check README.md
2. Check IMPROVEMENTS.md
3. Check docker logs
4. Check file exists with `ls`
5. Search GitHub issues

---

## 🎯 Interview Talking Points

**"Tell me about your project"**
→ "Bookmark manager demonstrating containerization, orchestration, and DevOps practices"

**"What's your architecture?"**
→ "Nginx reverse proxy → Gunicorn Django app × 3 replicas → PostgreSQL + Redis"

**"How do you scale?"**
→ "Kubernetes HPA auto-scales 3-10 replicas based on CPU/memory"

**"How do you ensure reliability?"**
→ "Health checks, persistent volumes, automated backups, CI/CD testing"

**"What about security?"**
→ "Non-root user, secrets in env vars, HTTPS ready, security scanning in CI/CD"

---

## 📈 Success Metrics

After completing this project, you should be able to:

✅ Explain containerization concepts
✅ Design multi-service architectures
✅ Deploy to Docker Compose and Kubernetes
✅ Implement health monitoring
✅ Create automated backups
✅ Build CI/CD pipelines
✅ Debug container issues
✅ Discuss scalability strategies

---

**Good luck with your interview! 🚀**
