# DevOps Kata - Complete Deployment System

A production-ready Kubernetes-based deployment system implementing all DevOps Kata requirements with CI/CD pipeline featuring Jenkins, monitoring with Prometheus/Grafana, and Infrastructure as Code using OpenTofu.

## ✅ Challenge Requirements Fulfilled

### Core Components
- **✅ Jenkins**: Running in Kubernetes cluster with automated CI/CD pipelines
- **✅ Helm**: Used for deploying Jenkins, Prometheus, and Grafana
- **✅ OpenTofu**: Infrastructure as Code with automated testing
- **✅ Minikube**: Kubernetes cluster management
- **✅ Prometheus**: Metrics collection with automatic service discovery
- **✅ Grafana**: Data visualization with custom dashboards

### Architecture Requirements
- **✅ 2 Namespaces**: `infrastructure` (Jenkins, Prometheus, Grafana) and `applications` (deployed apps)
- **✅ Jenkins in K8s**: Jenkins runs inside the Kubernetes cluster
- **✅ Pipeline Testing**: Tests run automatically and pipeline fails if tests fail
- **✅ OpenTofu Testing**: Automated infrastructure tests with validation
- **✅ Automatic Monitoring**: All deployed apps integrate with Prometheus/Grafana by default
- **✅ Useful Dashboards**: Application and infrastructure metrics with meaningful data

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                       │
├─────────────────────────────────────────────────────────────┤
│  Infrastructure Namespace                                   │
│  ┌─────────┐ ┌─────────────┐ ┌─────────┐                  │
│  │ Jenkins │ │ Prometheus  │ │ Grafana │                  │
│  │   CI/CD │ │  Monitoring │ │Dashboard│                  │
│  └─────────┘ └─────────────┘ └─────────┘                  │
├─────────────────────────────────────────────────────────────┤
│  Applications Namespace                                     │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │Sample-App-1 │ │Sample-App-2 │ │   Future    │          │
│  │+ Metrics    │ │+ Metrics    │ │    Apps     │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

## New Features & Improvements

### 🚀 Automatic Prometheus Integration
- **Service Discovery**: Apps are automatically discovered and monitored
- **Built-in Metrics**: All apps include Prometheus metrics by default
- **Custom Metrics**: HTTP requests, response times, resource usage
- **ServiceMonitor**: Automatic Prometheus scraping configuration

### 🧪 OpenTofu Testing
- **Configuration Validation**: Syntax and logic validation
- **Plan Testing**: Dry-run execution and validation  
- **Security Checks**: Basic security scanning
- **File Verification**: Required files and dependencies check

### 📊 Enhanced Monitoring
- **Application Dashboards**: Request rates, response times, errors
- **Infrastructure Dashboards**: CPU, memory, disk usage
- **Real-time Alerts**: Configurable alerting rules
- **Cross-namespace Discovery**: Prometheus monitors all namespaces

### 🔄 Improved CI/CD
- **Fail-Fast Testing**: Pipeline stops immediately on test failure
- **Automatic Deployment**: Kubernetes manifests with proper configuration
- **Health Checks**: Liveness and readiness probes
- **Rollback Capability**: Automatic rollback on deployment failure

## Project Structure

```
├── app/
│   └── sample-app/          # Go application source code
│       ├── Dockerfile       # Container definition
│       ├── jenkinsfile      # CI/CD pipeline definition
│       ├── main.go          # Application entry point
│       ├── main_test.go     # Unit tests
│       └── go.mod           # Go module definition
├── infra/                   # Terraform infrastructure as code
│   ├── jenkins.tf           # Jenkins deployment configuration
│   ├── monitoring.tf        # Prometheus/Grafana setup
│   ├── namespaces.tf        # Kubernetes namespace definitions
│   ├── providers.tf         # Terraform provider configuration
│   ├── dashboards/          # Grafana dashboard configurations
│   │   ├── application-metrics.json
│   │   └── infrastructure-metrics.json
│   └── values/              # Helm chart values
│       ├── jenkins-values.yaml
│       └── prometheus-values.yaml
├── deploy-infra.sh          # Infrastructure deployment script
├── setup-cluster.sh         # Cluster setup script
└── pre-requisites-install.sh # Prerequisites installation script
```

## Prerequisites

- Docker Desktop or equivalent container runtime
- Kubernetes cluster (local or cloud)
- kubectl configured to access your cluster
- Terraform >= 1.0
- Helm >= 3.0
- Docker Hub account for image registry

## Quick Start

### 1. Install Prerequisites

Run the prerequisites installation script:

```bash
./pre-requisites-install.sh
```

### 2. Setup Kubernetes Cluster

If you need to create a local cluster:

```bash
./setup-cluster.sh
```

### 3. Deploy Infrastructure

Deploy the complete infrastructure stack:

```bash
./deploy-infra.sh
```

This script will:
- Apply Terraform configurations
- Deploy Jenkins with Kubernetes agents
- Setup Prometheus and Grafana monitoring
- Create necessary namespaces and secrets

### 4. Configure Docker Hub Credentials

Create a Docker Hub secret for the CI/CD pipeline:

```bash
kubectl create secret docker-registry regcred \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=<YOUR_DOCKERHUB_USERNAME> \
  --docker-password=<YOUR_DOCKERHUB_TOKEN> \
  --docker-email=<YOUR_EMAIL> \
  -n infrastructure
```

## Application Endpoints

The sample application exposes the following endpoints:

- **Root Endpoint**: `GET /` - Returns "Hello World! - Sample App POC"
- **Health Check**: `GET /health` - Returns "OK" for health monitoring

## Testing and Verification

### 1. Check Infrastructure Status

Verify that all components are running:

```bash
# Check namespaces
kubectl get namespaces

# Check infrastructure pods
kubectl get pods -n infrastructure

# Check application pods
kubectl get pods -n applications

# Check services
kubectl get services -n infrastructure
kubectl get services -n applications
```

### 2. Access Jenkins

Forward Jenkins port and access the web interface:

```bash
# Port forward Jenkins
kubectl port-forward service/jenkins 8080:8080 -n infrastructure
```

Access Jenkins at: **http://localhost:8080**

Get the admin password:
```bash
kubectl get secret jenkins -o jsonpath="{.data.jenkins-admin-password}" -n infrastructure | base64 --decode
```

Default credentials:
- Username: `admin`
- Password: (use the command above to retrieve)

### 3. Access Grafana

Forward Grafana port and access dashboards:

```bash
# Port forward Grafana
kubectl port-forward service/prometheus-grafana 3000:80 -n infrastructure
```

Access Grafana at: **http://localhost:3000**

Default credentials:
- Username: `admin`
- Password: `prom-operator`

### 4. Access Prometheus

Forward Prometheus port for direct access:

```bash
# Port forward Prometheus
kubectl port-forward service/prometheus-kube-prometheus-prometheus 9090:9090 -n infrastructure
```

Access Prometheus at: **http://localhost:9090**

### 5. Test the Sample Application

Once deployed through Jenkins pipeline, test the application:

```bash
# Port forward the application
kubectl port-forward service/sample-app 8080:80 -n applications
```

Test endpoints:
```bash
# Test root endpoint
curl http://localhost:8080
# Expected output: Hello World! - Sample App POC

# Test health endpoint
curl http://localhost:8080/health
# Expected output: OK
```

## CI/CD Pipeline

The Jenkins pipeline automatically:

1. **Test Stage**: Runs Go unit tests, code quality checks, and coverage analysis
2. **Build Stage**: Uses Kaniko to build Docker image from source (only if tests pass)
3. **Push Stage**: Pushes the image to Docker Hub registry
4. **Deploy Stage**: Deploys the application to Kubernetes
5. **Health Check Stage**: Verifies the deployment is healthy

### Pipeline Features

- **Quality Gates**: Pipeline stops if tests fail, preventing broken code deployment
- **Test Coverage**: Generates test coverage reports for code quality monitoring
- **Code Quality**: Runs `go vet` for static analysis and race condition detection
- **Zero-Downtime Deployment**: Uses Kubernetes rolling updates
- **Automated Rollback**: Rolls back deployment on failure

### Test Stage Details

The test stage includes:
- **Unit Tests**: All Go unit tests with verbose output (`go test -v`)
- **Race Detection**: Tests run with race condition detection (`-race` flag)
- **Code Coverage**: Generates coverage report (`-coverprofile=coverage.out`)
- **Static Analysis**: Runs `go vet` to catch potential issues
- **Dependency Verification**: Verifies Go module integrity (`go mod verify`)

**Important**: If any test fails, the pipeline stops and no deployment occurs.

### Manual Pipeline Execution

1. Access Jenkins at http://localhost:8080
2. Navigate to "sample-app-pipeline"
3. Click "Build Now"
4. Monitor the pipeline execution in the console output

### Pipeline Configuration

The pipeline is defined in `app/sample-app/jenkinsfile` and includes:

- **Kubernetes Agent**: Uses pods for isolated build environments
- **Kaniko Container**: For secure Docker image builds
- **kubectl Container**: For Kubernetes deployments
- **Docker Hub Integration**: Automated image registry operations

## Monitoring and Observability

### Grafana Dashboards

The system includes pre-configured dashboards:

1. **Infrastructure Metrics**: Cluster resource utilization, node status
2. **Application Metrics**: Application performance, request metrics

### Prometheus Metrics

Key metrics collected:
- Kubernetes cluster metrics
- Application HTTP metrics
- Jenkins build metrics
- Container resource usage

### Alerting

Prometheus Alertmanager is configured for:
- High CPU/Memory usage alerts
- Pod restart alerts
- Application availability alerts

## Troubleshooting

### Common Issues

1. **Pipeline Authentication Errors**
   - Verify Docker Hub secret exists: `kubectl get secret regcred -n infrastructure`
   - Recreate secret if necessary with correct credentials

2. **Application Not Accessible**
   - Check pod status: `kubectl get pods -n applications`
   - Review pod logs: `kubectl logs -l app=sample-app -n applications`

3. **Jenkins Build Failures**
   - Check Jenkins agent logs in the build console
   - Verify Kaniko container has access to Docker config

4. **Monitoring Issues**
   - Verify Prometheus targets: http://localhost:9090/targets
   - Check Grafana data sources configuration

### Debugging Commands

```bash
# Check cluster events
kubectl get events --sort-by=.metadata.creationTimestamp

# Describe resources for detailed information
kubectl describe deployment sample-app -n applications
kubectl describe pod <pod-name> -n applications

# Check resource usage
kubectl top pods -n applications
kubectl top nodes

# View application logs
kubectl logs -l app=sample-app -n applications --follow
```

## Development Workflow

### Making Changes

1. Modify application code in `app/sample-app/`
2. Commit and push changes to trigger the pipeline
3. Monitor the Jenkins pipeline execution
4. Verify deployment in the applications namespace

### Testing Locally

Run the application locally for development:

```bash
cd app/sample-app
go run main.go
```

Access locally at: http://localhost:8080

### Running Tests

Execute unit tests:

```bash
cd app/sample-app

# Run all tests
go test ./...

# Run tests with verbose output
go test -v ./...

# Run tests with coverage
go test -v -coverprofile=coverage.out ./...
go tool cover -html=coverage.out -o coverage.html

# Run tests with race detection
go test -race ./...

# Run static analysis
go vet ./...
```

### Test Coverage

The application includes comprehensive tests for:
- **HTTP Handlers**: Tests for all API endpoints
- **Response Validation**: Ensures correct HTTP status codes and response bodies
- **Error Handling**: Tests for error scenarios and edge cases

## Security Considerations

- Docker Hub credentials are stored as Kubernetes secrets
- Jenkins uses service accounts with minimal required permissions
- Network policies can be added for additional security
- RBAC is configured for proper access control

## Cleanup

To remove all deployed resources:

```bash
# Remove application deployments
kubectl delete namespace applications

# Remove infrastructure (keep monitoring for other projects)
helm uninstall jenkins -n infrastructure

# Or remove everything
kubectl delete namespace infrastructure
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly using the verification steps
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## Support

For issues and questions:
- Check the troubleshooting section above
- Review logs using the debugging commands
- Open an issue in the GitHub repository