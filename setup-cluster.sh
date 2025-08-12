
echo "Starting minikube cluster" 
minikube start \
    --driver=docker \
    --cpus=4 \
    --memory=8192 \
    --disk-size=5GB \
    --kubernetes-version=v1.33.0

minikube addons enable ingress
minikube addons enable metrics-server
minikube addons enable dashboard

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add jenkins https://charts.jenkins.io
helm repo add stable https://charts.helm.sh/stable
helm repo update

kubectl get nodes
kubectl get pods --all-namespaces