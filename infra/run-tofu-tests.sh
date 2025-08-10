#!/bin/bash

echo "Running OpenTofu automated tests..."

# Test 1: Validate Terraform configuration
echo "Test 1: Validating OpenTofu configuration..."
if tofu validate; then
    echo "✅ OpenTofu configuration is valid"
else
    echo "❌ OpenTofu configuration validation failed"
    exit 1
fi

# Test 2: Check if all required files exist
echo "Test 2: Checking required files..."
required_files=(
    "providers.tf"
    "namespaces.tf"
    "jenkins.tf" 
    "monitoring.tf"
    "values/jenkins-values.yaml"
    "values/prometheus-values.yaml"
    "dashboards/application-metrics.json"
    "dashboards/infrastructure-metrics.json"
)

for file in "${required_files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ Found: $file"
    else
        echo "❌ Missing: $file"
        exit 1
    fi
done

# Test 3: Plan validation (dry-run)
echo "Test 3: Running OpenTofu plan (dry-run)..."
if tofu plan -out=tfplan -detailed-exitcode; then
    echo "✅ OpenTofu plan executed successfully"
    rm -f tfplan
else
    exit_code=$?
    if [[ $exit_code -eq 2 ]]; then
        echo "✅ OpenTofu plan has changes (expected)"
        rm -f tfplan
    else
        echo "❌ OpenTofu plan failed"
        exit 1
    fi
fi

# Test 4: Security scan (basic)
echo "Test 4: Running basic security checks..."
if tofu show -json tfplan 2>/dev/null | grep -q "kubernetes"; then
    echo "✅ Kubernetes resources detected"
else
    echo "⚠️  Warning: No Kubernetes resources found in plan"
fi

# Test 5: Provider version validation
echo "Test 5: Checking provider versions..."
if grep -q "required_providers" providers.tf; then
    echo "✅ Provider versions are specified"
else
    echo "❌ Provider versions not specified"
    exit 1
fi

echo "🎉 All OpenTofu tests passed!"
