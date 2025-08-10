#!/bin/bash

echo "🧪 Testing Sample App and Generating Metrics"
echo "============================================"

# Port forward sample app in background
kubectl port-forward svc/sample-app 8080:80 -n apps &
PID=$!

# Cleanup function
cleanup() {
    kill $PID 2>/dev/null
}
trap cleanup EXIT

# Wait for port forward
sleep 3

echo "Generating HTTP requests to create metrics data..."

# Generate some traffic
for i in {1..20}; do
    curl -s http://localhost:8080/ > /dev/null
    curl -s http://localhost:8080/health > /dev/null
    sleep 0.5
done

echo "✅ Generated 40 requests!"
echo ""
echo "📊 Check metrics at:"
echo "- App metrics: http://localhost:8080/metrics"
echo "- Grafana: http://localhost:3000 (admin/admin)"
echo ""
echo "📈 In Grafana, look for 'Sample App Metrics' dashboard"
