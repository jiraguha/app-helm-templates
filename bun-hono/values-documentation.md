# Bun-Hono Helm Chart: Values Documentation

This document provides a comprehensive explanation of all configuration values available in the Bun-Hono Helm chart's `values.yaml` file.

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
| `appName` | Name of the application | `bun-hono-app` |
| `replicaCount` | Number of replicas (pods) to run | `2` |
| `fullnameOverride` | Override for the fully qualified app name | `""` |
| `skaffoldEnabled` | Enable Skaffold integration for development | `false` |

## Image Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Container image repository | `registry.example.com/your-org/bun-hono-app` |
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

## Logging Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `logLevel.root` | Root log level | `info` |
| `logLevel.packages` | Package-specific log levels | `{}` |

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
| `http.port` | HTTP port for the application | `3000` |
| `http.containerPort` | Container port for HTTP | `3000` |

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
appName: my-hono-app
replicaCount: 3
image:
  repository: my-registry/my-org/my-hono-app
  tag: v1.0.0
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

### Enabling Ingress

```yaml
ingress:
  enabled: true
  className: nginx
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

### Configuring Environment Variables

```yaml
container:
  environment:
    NODE_ENV: production
    LOG_LEVEL: info
  secrets:
    - name: db-credentials-secretNameRef
      env:
        VALUE_REF: VALUE_IN_CONTAINER
        DB_USERNAME: username
        DB_PASSWORD: password
```
### Setting Up Pod Disruption Budget

```yaml
podDisruptionBudget:
  minAvailable: 1
```

## Advanced Configuration

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
  prometheus.io/port: "3000"
```

### Custom Domain and Path

```yaml
ingress:
  enabled: true
  # Override the automatically generated hostname completely
  hostnameOverride: "api.example.org"
  # Configure custom path settings
  path:
    prefix: "/api/v1"
    type: "Prefix"  # Can be "Prefix", "Exact", or "ImplementationSpecific"
```
This will generate a domain like: `bun-hono-app.production.company.com` OR
This will use `api.example.org` as the hostname and route all traffic with the path prefix `/api/v1/*` to your application.