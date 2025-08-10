resource "helm_release" "prometheus" {
    name = "prometheus"
    repository = "https://prometheus-community.github.io/helm-charts"
    chart = "kube-prometheus-stack"
    namespace = "infrastructure"
    version = "51.0.0"
    timeout = 900
    wait = true
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
          grafana_dashboard = "1"
        }
    }

    data = {
      "application-metrics.json" = file("${path.module}/dashboards/application-metrics.json")
      "infrastructure-metrics.json" = file("${path.module}/dashboards/infrastructure-metrics.json")
    }
    depends_on = [ kubernetes_namespace.infrastructure ]
}
