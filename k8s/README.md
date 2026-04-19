# Kubernetes Deployment Guide

## Quick Start

```bash
# 1. Create namespace and deploy
kubectl apply -f k8s/deployment.yaml

# 2. Wait for rollout
kubectl rollout status deployment/django -n bookmark-manager
kubectl rollout status deployment/nginx -n bookmark-manager

# 3. Get external IP
kubectl get svc nginx -n bookmark-manager

# 4. Access application
# Use the EXTERNAL-IP from above
```

## What's Deployed

### Namespace
- `bookmark-manager` - Isolated environment for all resources

### Database (PostgreSQL)
- **Type:** StatefulSet (1 replica, can scale)
- **Storage:** 10GB persistent volume
- **Probes:** Liveness + Readiness checks
- **Service:** `postgres:5432` (internal)

### Cache (Redis)
- **Type:** Deployment (1 replica)
- **Storage:** emptyDir (in-memory, lost on restart)
- **Service:** `redis:6379` (internal)

### Application (Django)
- **Type:** Deployment (3 replicas for HA)
- **Init Containers:** Run migrations + collect static files
- **Probes:** Health endpoints (`/health/`, `/ready/`, `/live/`)
- **HPA:** Auto-scales 3-10 replicas based on CPU/memory
- **Service:** `django:8000` (internal)

### Reverse Proxy (Nginx)
- **Type:** Deployment (2 replicas)
- **Service:** LoadBalancer (public access on port 80/443)

## Common Commands

```bash
# View deployment status
kubectl get all -n bookmark-manager

# Check pod logs
kubectl logs -f deployment/django -n bookmark-manager

# Scale manually
kubectl scale deployment django --replicas=5 -n bookmark-manager

# Port forward for debugging
kubectl port-forward svc/django 8000:8000 -n bookmark-manager

# Check HPA status
kubectl get hpa -n bookmark-manager

# Delete deployment
kubectl delete namespace bookmark-manager
```

## Environment Variables

Edit in `deployment.yaml` before applying:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: django-config
data:
  DEBUG: "0"           # Set to "0" for production
  DB_HOST: postgres
  REDIS_URL: redis://redis:6379/0
```

## Secrets

Change these in `deployment.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: django-secret
stringData:
  SECRET_KEY: <generate-new-key>
  DB_PASSWORD: <strong-password>
  POSTGRES_PASSWORD: <strong-password>
```

Generate secure random key:
```bash
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

## Production Checklist

- [ ] Change all secrets
- [ ] Set DEBUG=0
- [ ] Configure ingress for HTTPS
- [ ] Setup persistent volume for Redis
- [ ] Enable pod security policies
- [ ] Configure resource limits
- [ ] Setup monitoring (Prometheus)
- [ ] Configure log aggregation
- [ ] Enable backup for PostgreSQL
- [ ] Test disaster recovery

## Scaling

Current setup auto-scales Django pods based on CPU/memory.

Manual override:
```bash
kubectl patch hpa django-hpa -p '{"spec":{"maxReplicas":20}}' -n bookmark-manager
```

## Networking

- Pods communicate internally via DNS: `postgres:5432`, `redis:6379`, `django:8000`
- External access: via `nginx` LoadBalancer service
- All communication inside cluster (no external exposure except through nginx)

## Troubleshooting

**Pods stuck in pending:**
```bash
kubectl describe pod <pod-name> -n bookmark-manager
# Check: PVC binding, resource availability, image pull errors
```

**Django migrations failing:**
```bash
kubectl logs <pod-name> -c migrate -n bookmark-manager
```

**Can't reach application:**
```bash
# Check nginx logs
kubectl logs deployment/nginx -n bookmark-manager

# Test connectivity
kubectl exec deployment/django -n bookmark-manager -- curl http://localhost:8000/health/
```

## References

- https://kubernetes.io/docs/tutorials/kubernetes-basics/
- https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- https://kubernetes.io/docs/concepts/services-networking/service/
