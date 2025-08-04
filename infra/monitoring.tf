resource "helm_release" "prometheus" {
    name = "prometheus"
    repository = "https://prometheus-community.github.io/helm-charts"
    chart = "kube-prometheus-stack"
    namespace = "infrastructure"
    version = "51.0.0"
    values = [
        file("${path.module}/values/prometheus-values.yaml")
    ]
    depends_on = [kubernetes_namespace.infrastructure]
}

resource "kubernetes_config_map" "grafana_dashboards" {
    metadata {
        name = "custom-dashboards"
        namespace = "infrastructure"
        labels = {
          grafana_dashboards = "1"
        }
    }

    data = {
      "application-metrics.json" = file("${path.module}/dashboards/application-metrics.json")
      "infrastructure-metrics.json" = file("${path.module}/dashboards/infrastructure-metrics.json")
    }
    depends_on = [ helm_release.prometheus ]
}

resource "helm_release" "jenkins" {
    name = "jenkins"
    repository = "https://charts.jenkins.io"
    chart = "jenkins"
    namespace = "infrastructure"
    version = "4.3.0"

    values = [
        file("${path.module}/values/jenkins-values.yaml")
    ]
    depends_on = [kubernetes_namespace.infrastructure]
}