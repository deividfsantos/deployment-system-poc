# 🚀 DevOps Kata - Deploy System

**Sistema DevOps compl## 📁 Estrutura

```
├── deploy.sh          # Script único de deploy
├── test-infra.sh      # Testes automatizados OpenTofu
├── test-metrics.sh    # Gera tráfego para dashboards  
├── app/               # Aplicação Go simples
└── infra/             # OpenTofu configs + testes
```

## 🎮 Como usar

1. `./test-infra.sh` - Testar infraestrutura OpenTofu
2. `./deploy.sh` - Deploy tudo
3. `./test-metrics.sh` - Gerar dados para dashboards
4. Usar os port-forwards acima  
5. Jenkins → criar pipeline do GitHub
6. Ver métricas no Grafanates - Versão minimalista**

## ⚡ Quick Start

```bash
# 1. Pré-requisitos (macOS)
brew install minikube kubectl helm

# 2. Instalar OpenTofu
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh | sh

# 3. Deploy
./deploy.sh
```

## 🎯 Requisitos Cumpridos

✅ Jenkins em Kubernetes  
✅ Helm para deploys  
✅ OpenTofu para infraestrutura  
✅ Minikube como cluster  
✅ Prometheus + Grafana  
✅ 2 namespaces (infra/apps)  
✅ Pipeline com testes  
✅ Métricas integradas  

## 🖥️ Acesso

Após deploy, execute em terminais separados:

```bash
# Jenkins (admin/admin123)
kubectl port-forward svc/jenkins 8080:8080 -n infra

# Grafana (admin/admin) 
kubectl port-forward svc/grafana 3000:3000 -n infra

# App
kubectl port-forward svc/sample-app 8080:80 -n apps
```

## 📊 Dashboards Grafana

O sistema inclui dashboards básicos:
- **Sample App Metrics**: Mostra métricas HTTP da aplicação
- Dashboards são carregados automaticamente no Grafana

## 🐳 Build da Imagem Docker

A imagem Docker é construída automaticamente:
- **Deploy local**: `./deploy.sh` builda a imagem localmente no minikube
- **Pipeline Jenkins**: Faz build e push para Docker Hub
- **ImagePullPolicy**: Configurado como `IfNotPresent` para usar imagens locais

## � Estrutura

```
├── deploy.sh          # Script único de deploy
├── app/               # Aplicação Go simples
└── infra/             # OpenTofu configs
```

## 🎮 Como usar

1. `./deploy.sh` - Deploy tudo
2. Usar os port-forwards acima  
3. Jenkins → criar pipeline do GitHub
4. Ver métricas no Grafana

Simples assim! 🎉
