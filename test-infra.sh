#!/bin/bash
set -e

echo "🧪 Running OpenTofu Infrastructure Tests"
echo "========================================"

cd infra

# Validate OpenTofu syntax
echo "Validating OpenTofu configuration..."
tofu fmt -check
tofu validate

# Run Go tests (terratest)
echo "Running infrastructure tests..."
go mod tidy
go test -v -timeout 30m

echo "✅ All infrastructure tests passed!"

cd ..
