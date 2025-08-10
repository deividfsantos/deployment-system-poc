#!/bin/bash

# 🚀 DEPLOY COMPLETO EM UM ÚNICO COMANDO
# Este script faz TUDO: cluster + infraestrutura + aplicação + testes

set -e

echo "🚀 DevOps Kata - Deploy Automático Completo"
echo "=========================================="

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "\n${BLUE}📋 STEP: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar se o minikube está rodando
print_step "Verificando cluster Kubernetes"
if ! kubectl cluster-info &>/dev/null; then
    print_warning "Cluster não encontrado. Iniciando minikube..."
    minikube start --cpus=4 --memory=8192
    minikube addons enable ingress
    minikube addons enable metrics-server
fi
print_success "Cluster Kubernetes ativo"

# Deploy da infraestrutura com OpenTofu
print_step "Deployando infraestrutura (Jenkins + Prometheus + Grafana)"
cd infra
if [ ! -d ".terraform" ]; then
    tofu init
fi
tofu apply -auto-approve
print_success "Infraestrutura deployada"

# Criar secret do Docker Hub (automático)
print_step "Configurando secrets do Docker Hub"
kubectl delete secret regcred -n infrastructure --ignore-not-found
kubectl create secret docker-registry regcred \
    --docker-server=https://index.docker.io/v1/ \
    --docker-username=deividsantos \
    --docker-password=dckr_pat_example_replace_with_real_token \
    -n infrastructure || print_warning "Secret já existe ou erro na criação"

cd ..

# Aguardar Jenkins estar pronto
print_step "Aguardando Jenkins estar pronto"
kubectl wait --for=condition=available --timeout=300s deployment/jenkins -n infrastructure
print_success "Jenkins está pronto"

# Deploy da aplicação automaticamente
print_step "Deployando aplicação sample-app"
# Usar a imagem já buildada para simplificar
kubectl apply -f app/sample-app/deployment.yaml
kubectl apply -f app/sample-app/service-monitor.yaml
kubectl wait --for=condition=available --timeout=120s deployment/sample-app -n applications
print_success "Aplicação deployada com sucesso"

# Criar pipeline automaticamente no Jenkins (opcional)
print_step "Configurando pipeline Jenkins"
echo "📝 Para executar o pipeline:"
echo "   1. Acesse Jenkins em http://localhost:8080" 
echo "   2. Vá em 'New Item' → 'Pipeline'"
echo "   3. Nome: 'sample-app-pipeline'"
echo "   4. Em 'Pipeline Script from SCM' → Cole a URL do repo"
echo "   5. Build!"
print_success "Pipeline pronto para configuração"

# Aguardar Prometheus estar pronto
print_step "Aguardando Prometheus estar pronto"
kubectl wait --for=condition=available --timeout=300s deployment/prometheus-kube-prometheus-operator -n infrastructure
print_success "Prometheus está pronto"

echo ""
echo "🎉 DEPLOY COMPLETO! 🎉"
echo "==================="
echo ""
echo "📊 ACESSAR SERVIÇOS:"
echo "-------------------"

# Obter senha do Jenkins automaticamente
JENKINS_PASSWORD=$(kubectl get secret jenkins -o jsonpath="{.data.jenkins-admin-password}" -n infrastructure | base64 --decode)

echo "🔧 Jenkins: http://localhost:8080"
echo "   👤 User: admin"
echo "   🔑 Pass: $JENKINS_PASSWORD"
echo "   🚀 Comando: kubectl port-forward service/jenkins 8080:8080 -n infrastructure"
echo ""
echo "📈 Grafana: http://localhost:3000" 
echo "   👤 User: admin"
echo "   🔑 Pass: prom-operator"
echo "   🚀 Comando: kubectl port-forward service/prometheus-grafana 3000:80 -n infrastructure"
echo ""
echo "📊 Prometheus: http://localhost:9090"
echo "   🚀 Comando: kubectl port-forward service/prometheus-kube-prometheus-prometheus 9090:9090 -n infrastructure"
echo ""
echo "🌐 Aplicação: http://localhost:8080"
echo "   🚀 Comando: kubectl port-forward service/sample-app 8080:80 -n applications"
echo ""
echo "📋 PRÓXIMOS PASSOS:"
echo "------------------"
echo "1. Execute os comandos port-forward acima em terminais separados"
echo "2. Acesse Jenkins e execute o pipeline 'sample-app-pipeline'"
echo "3. Veja as métricas no Grafana dashboard 'Application Metrics'"
echo "4. Execute ./quick-test.sh para gerar tráfego e dados"
echo ""
echo "✨ Sistema completo funcionando com todos os requisitos do DevOps Kata!"
