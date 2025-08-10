#!/bin/bash
set -e

echo "🚀 DevOps Kata Deploy"
echo "===================="

# Start minikube if not running
if ! kubectl cluster-info &>/dev/null; then
    echo "Starting minikube..."
    minikube start --cpus=2 --memory=4096
fi

# Use minikube docker daemon for local builds
echo "Setting up Docker environment..."
eval $(minikube docker-env)

# Build app image locally
echo "Building sample app image..."
cd app/sample-app
docker build -t deividsantos/sample-app:latest .
cd ../..

# Deploy infrastructure
echo "Deploying infrastructure..."
cd infra
tofu init -upgrade
tofu apply -auto-approve
cd ..

# Deploy app
echo "Deploying sample app..."
kubectl apply -f app/sample-app/deployment.yaml

# Wait for pods
echo "Waiting for services..."
kubectl wait --for=condition=available --timeout=300s deployment/jenkins -n infra || echo "Jenkins may need more time"
kubectl wait --for=condition=available --timeout=300s deployment/grafana -n infra || echo "Grafana may need more time"
kubectl wait --for=condition=available --timeout=180s deployment/sample-app -n apps || echo "Sample app may need more time"

echo "✅ Deploy complete!"
echo ""
echo "Access services:"
echo "Jenkins:  kubectl port-forward svc/jenkins 8080:8080 -n infra"
echo "Grafana:  kubectl port-forward svc/grafana 3000:3000 -n infra"
echo "App:      kubectl port-forward svc/sample-app 8080:80 -n apps"
echo ""
echo "📊 Grafana credentials: admin/admin"
echo "🔧 Jenkins credentials: admin/admin123"
