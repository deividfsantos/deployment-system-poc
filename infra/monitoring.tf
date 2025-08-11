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

resource "kubernetes_manifest" "sample_app_servicemonitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "sample-app-metrics"
      namespace = "infrastructure"
      labels = {
        app     = "sample-app"
        release = "prometheus"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "sample-app"
        }
      }
      namespaceSelector = {
        matchNames = ["applications"]
      }
      endpoints = [
        {
          port     = "http"
          interval = "30s"
          path     = "/metrics"
        }
      ]
    }
  }
  depends_on = [helm_release.prometheus]
}
