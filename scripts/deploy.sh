#!/bin/bash
set -e

echo "K3s Infrastructure Deployment Script"
echo "====================================="

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found!"
    echo "Please copy .env.example to .env and configure it."
    exit 1
fi

# Load environment variables
export $(cat .env | grep -v '^#' | xargs)

# Check if envsubst is installed
if ! command -v envsubst &> /dev/null; then
    echo "Error: envsubst not found. Please install gettext package."
    exit 1
fi

echo "Deploying services..."

# Deploy Mattermost (PostgreSQL + App)
echo "[1/6] Deploying Mattermost..."
envsubst < mattermost/postgres.yaml | kubectl apply -f -
sleep 5  # Wait for PostgreSQL to initialize
envsubst < mattermost/mattermost.yaml | kubectl apply -f -

# Deploy Jellyfin
echo "[2/6] Deploying Jellyfin..."
envsubst < jellyfin/jellyfin.yaml | kubectl apply -f -

# Deploy Prometheus
echo "[3/6] Deploying Prometheus..."
envsubst < monitoring/prometheus.yaml | kubectl apply -f -

# Deploy Grafana
echo "[4/6] Deploying Grafana..."
envsubst < monitoring/grafana.yaml | kubectl apply -f -

# Deploy Landing Page
echo "[5/6] Deploying Landing Page..."
envsubst < landing/landing.yaml | kubectl apply -f -

echo "[6/6] Deployment complete!"

echo ""
echo "Checking deployment status..."
kubectl get pods --all-namespaces | grep -E '(mattermost|media|monitoring|landing)'

echo ""
echo "Services available at:"
echo "  Mattermost:   http://${SERVER_IP}:30000"
echo "  Prometheus:   http://${SERVER_IP}:30001"
echo "  Grafana:      http://${SERVER_IP}:30002"
echo "  Jellyfin:     http://${SERVER_IP}:30003"
echo "  Landing:      http://${SERVER_IP}:30004"
