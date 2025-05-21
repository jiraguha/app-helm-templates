# FastAPI Helm Chart: Values Documentation

This document provides a comprehensive explanation of all configuration values available in the FastAPI Helm chart's `values.yaml` file.

## Global Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `certificateIssuer` | Certificate issuer for TLS certificates (used with cert-manager) | `"letsencrypt-cluster-prod"` |
| `environment` | Environment name (dev, staging, prod, etc.) | `dev` |
| `mainDnsDomain` | Main DNS domain for generating ingress hostnames | `example.com` |
| `namespace` | Kubernetes namespace to deploy resources | `apps` |

## Application Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `appName` | Name of the application | `fastapi-app` |
| `replicaCount` | Number of replicas (pods) to run | `2` |
| `fullnameOverride` | Override for the fully qualified app name | `""` |
| `skaffoldEnabled` | Enable Skaffold integration for development | `false` |
| `logLevel` | Default logging level | `info` |

## Image Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Container image repository | `registry.example.com/your-org/fastapi-app` |
| `image.tag` | Container image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `Always` |
| `image.ref` | Image reference for versioning | `none` |
| `imagePullSecrets` | Secrets for pulling images from private registries | `[{name: docker-registry-secret}]` |

## Pod Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `restartPolicy` | Pod restart policy | `Always` |
| `serviceAccountName` | Service account name for pod | `default` |
| `podAnnotations` | Annotations to add to pods | `{}` |

## Configuration Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `enableDefaultConfig` | Enable default configuration | `true` |
| `internalConfig` | Manage ConfigMap within the chart | `true` |

## Network Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `80` |
| `http.port` | HTTP port for the application | `80` |
| `http.containerPort` | Container port for HTTP | `8000` |

## Python Specific Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `python.command` | Command to start FastAPI with Uvicorn | `["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]` |
| `python.useGunicorn` | Use Gunicorn for production | `false` |
| `python.gunicorn.workers` | Number of Gunicorn workers | `4` |
| `python.gunicorn.workerClass` | Gunicorn worker class | `uvicorn.workers.UvicornWorker` |
| `python.gunicorn.command` | Full Gunicorn command | `["gunicorn", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", "app.main:app", "-b", "0.0.0.0:8000"]` |

## Ingress Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.annotations` | Additional ingress annotations | `{}` |
| `ingress.externalDnsEnabled` | Enable ExternalDNS integration | `true` |
| `ingress.className` | Ingress class name | `nginx` |
| `ingress.hostnameOverride` | Override hostname pattern completely | `""` |
| `ingress.path.prefix` | URL path prefix | `"/"` |
| `ingress.path.type` | Path type (Prefix, Exact, ImplementationSpecific) | `"Prefix"` |

## Container Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `container.environment` | Environment variables to inject | `{}` |
| `container.secrets` | Secrets to inject as environment variables | `{}` |

## Resource Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `resources` | CPU/Memory resource requests/limits | `{}` |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | Tolerations for pod assignment | `[]` |
| `affinity` | Affinity rules for pod assignment | `{}` |

## Health Check Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `livenessProbe.httpGet.path` | Path for liveness probe | `/health` |
| `livenessProbe.httpGet.port` | Port for liveness probe | `http` |
| `livenessProbe.initialDelaySeconds` | Initial delay for liveness probe | `10` |
| `livenessProbe.periodSeconds` | Period between liveness probes | `10` |
| `readinessProbe.httpGet.path` | Path for readiness probe | `/health` |
| `readinessProbe.httpGet.port` | Port for readiness probe | `http` |
| `readinessProbe.initialDelaySeconds` | Initial delay for readiness probe | `5` |
| `readinessProbe.periodSeconds` | Period between readiness probes | `10` |

## Autoscaling Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `hpa` | HorizontalPodAutoscaler settings | `{}` |
| `hpa.minReplicas` | Minimum number of replicas | Same as `replicaCount` |
| `hpa.maxReplicas` | Maximum number of replicas | Not set |
| `hpa.cpuMax` | Target CPU utilization percentage | Not set |
| `hpa.memoryMax` | Target memory utilization percentage | Not set |

## Availability Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podDisruptionBudget` | PodDisruptionBudget settings | `{}` |
| `podDisruptionBudget.minAvailable` | Minimum number of available pods | Not set |

## Usage Examples

### Basic Configuration

```yaml
appName: my-fastapi-app
replicaCount: 3
image:
  repository: my-registry/my-org/my-fastapi-app
  tag: v1.0.0
logLevel: info
```

### Production Setup with Gunicorn

```yaml
environment: production
python:
  useGunicorn: true
  gunicorn:
    workers: 8
    command: ["gunicorn", "-w", "8", "-k", "uvicorn.workers.UvicornWorker", "app.main:app", "-b", "0.0.0.0:8000"]
resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 200m
    memory: 256Mi
```

### Configuring Resources

```yaml
resources:
  limits:
    cpu: 200m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi
```

### Enabling Ingress with Custom Domain and Path

```yaml
ingress:
  enabled: true
  className: nginx
  # Override the automatically generated hostname completely
  hostnameOverride: "api.example.org"
  # Configure custom path settings
  path:
    prefix: "/api/v1"
    type: "Prefix"  # Can be "Prefix", "Exact", or "ImplementationSpecific"
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "50m"
```

### Setting Up Horizontal Pod Autoscaler

```yaml
hpa:
  minReplicas: 2
  maxReplicas: 10
  cpuMax: 80
  memoryMax: 75
```

### Configuring Environment Variables and Secrets

```yaml
container:
  environment:
    DATABASE_HOST: postgres.example.com
    REDIS_HOST: redis.example.com
  secrets:
    - name: db-credentials
      env:
        DATABASE_USERNAME: username
        DATABASE_PASSWORD: password
```

### Setting Up Pod Disruption Budget

```yaml
podDisruptionBudget:
  minAvailable: 1
```

### Custom Health Check Endpoints

```yaml
livenessProbe:
  httpGet:
    path: /api/health/live
    port: http
  initialDelaySeconds: 30
  periodSeconds: 15

readinessProbe:
  httpGet:
    path: /api/health/ready
    port: http
  initialDelaySeconds: 10
  periodSeconds: 10
```

### Prometheus Metrics

```yaml
podAnnotations:
  prometheus.io/scrape: "true"
  prometheus.io/path: "/metrics"
  prometheus.io/port: "8000"
```