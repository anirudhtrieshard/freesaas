# K3s Infrastructure Setup

A production-ready Kubernetes infrastructure running on k3s with self-hosted services.

## Services

| Service | Description | Port | Public URL |
|---------|-------------|------|------------|
| Mattermost | Team chat | 30000 | chat.yourdomain.com |
| Jellyfin | Media server | 30003 | media.yourdomain.com |
| Prometheus | Metrics | 30001 | prometheus.yourdomain.com |
| Grafana | Dashboards | 30002 | monitor.yourdomain.com |
| Landing | Directory | 30004 | yourdomain.com |

## Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/anirudhtrieshard/freesaas.git
cd freesaas
```

### 2. Configure Environment
```bash
cp .env.example .env
nano .env  # Edit with your values
```

### 3. Deploy
```bash
export $(cat .env | xargs)
envsubst < mattermost/postgres.yaml | kubectl apply -f -
envsubst < mattermost/mattermost.yaml | kubectl apply -f -
envsubst < jellyfin/jellyfin.yaml | kubectl apply -f -
envsubst < monitoring/prometheus.yaml | kubectl apply -f -
envsubst < monitoring/grafana.yaml | kubectl apply -f -
envsubst < landing/landing.yaml | kubectl apply -f -
```

## Directory Structure
```
k3s-apps/
├── mattermost/         # Chat platform
├── jellyfin/           # Media streaming
├── monitoring/         # Prometheus & Grafana
├── landing/            # Service directory
├── cloudflare/         # Tunnel config templates
└── docs/              # Documentation
```

## Accessing Services

Local: http://SERVER_IP:PORT
Public: Configure Cloudflare Tunnel (see docs/cloudflare-setup.md)

## Security

- Never commit .env file
- Change all default passwords
- Keep images updated
- Use HTTPS for public access

## Troubleshooting

```bash
# Check pods
kubectl get pods --all-namespaces

# View logs
kubectl logs -n <namespace> <pod-name>

# Describe pod
kubectl describe pod -n <namespace> <pod-name>
```
