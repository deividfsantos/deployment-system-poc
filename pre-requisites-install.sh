#!/bin/bash

set -e

echo "🚀 Installing Prerequisites for DevOps Kata Deployment System..."

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "Detected OS: $OS, Architecture: $ARCH"

# Install OpenTofu
echo "📦 Installing OpenTofu..."
if command -v tofu &> /dev/null; then
    echo "✅ OpenTofu already installed: $(tofu version)"
else
    case $OS in
        "Darwin")
            if command -v brew &> /dev/null; then
                brew tap opentofu/tap
                brew install opentofu
            else
                echo "❌ Homebrew not found. Please install Homebrew first or install OpenTofu manually."
                exit 1
            fi
            ;;
        "Linux")
            # Download and install OpenTofu for Linux
            curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
            chmod +x install-opentofu.sh
            sudo ./install-opentofu.sh --install-method deb
            rm install-opentofu.sh
            ;;
        *)
            echo "❌ Unsupported OS: $OS"
            exit 1
            ;;
    esac
fi

# Install kubectl
echo "📦 Installing kubectl..."
if command -v kubectl &> /dev/null; then
    echo "✅ kubectl already installed: $(kubectl version --client --short 2>/dev/null || kubectl version --client)"
else
    case $OS in
        "Darwin")
            if command -v brew &> /dev/null; then
                brew install kubectl
            else
                curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
                chmod +x kubectl
                sudo mv kubectl /usr/local/bin/
            fi
            ;;
        "Linux")
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            chmod +x kubectl
            sudo mv kubectl /usr/local/bin/
            ;;
    esac
fi

# Install Helm
echo "📦 Installing Helm..."
if command -v helm &> /dev/null; then
    echo "✅ Helm already installed: $(helm version --short)"
else
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Install Docker (if not present)
echo "📦 Checking Docker..."
if command -v docker &> /dev/null; then
    echo "✅ Docker already installed: $(docker version --format '{{.Server.Version}}' 2>/dev/null || echo 'Docker daemon not running')"
else
    echo "❌ Docker not found. Please install Docker Desktop manually."
    echo "   Download from: https://www.docker.com/products/docker-desktop"
fi

# Install minikube
echo "📦 Installing minikube..."
if command -v minikube &> /dev/null; then
    echo "✅ minikube already installed: $(minikube version --short)"
else
    case $OS in
        "Darwin")
            curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-darwin-amd64
            sudo install minikube-darwin-amd64 /usr/local/bin/minikube
            rm minikube-darwin-amd64
            ;;
        "Linux")
            curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
            sudo install minikube-linux-amd64 /usr/local/bin/minikube
            rm minikube-linux-amd64
            ;;
    esac
fi

echo "🎉 Prerequisites installation completed!"
echo ""
echo "📋 Installed tools:"
echo "   ✅ OpenTofu: $(tofu version | head -n1)"
echo "   ✅ kubectl: $(kubectl version --client --short 2>/dev/null || kubectl version --client | head -n1)"
echo "   ✅ Helm: $(helm version --short)"
echo "   ✅ minikube: $(minikube version --short)"
echo "   ✅ Docker: $(docker version --format '{{.Server.Version}}' 2>/dev/null || echo 'Please start Docker daemon')"
echo ""
echo "🚀 Next steps:"
echo "   1. Start Docker Desktop (if not running)"
echo "   2. Run: ./setup-cluster.sh"
echo "   3. Run: ./deploy-infra.sh"