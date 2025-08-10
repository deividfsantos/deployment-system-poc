resource "helm_release" "prometheus" {
    name = "prometheus"
    repository = "https://prometheus-community.github.io/helm-charts"
    chart = "prometheus"
    namespace = "infra"

    set {
        name = "server.global.scrape_interval"
        value = "15s"
    }

    # Enable service discovery for kubernetes pods
    set {
        name = "server.global.external_labels.cluster"
        value = "devops-kata"
    }

    depends_on = [kubernetes_namespace.infra]
}

resource "helm_release" "grafana" {
    name = "grafana"
    repository = "https://grafana.github.io/helm-charts"
    chart = "grafana"
    namespace = "infra"

    set {
        name = "adminPassword"
        value = "admin"
    }

    # Add Prometheus as datasource
    set {
        name = "datasources.datasources\\.yaml.apiVersion"
        value = "1"
    }

    set {
        name = "datasources.datasources\\.yaml.datasources[0].name"
        value = "Prometheus"
    }

    set {
        name = "datasources.datasources\\.yaml.datasources[0].type"
        value = "prometheus"
    }

    set {
        name = "datasources.datasources\\.yaml.datasources[0].url"
        value = "http://prometheus-server:80"
    }

    depends_on = [kubernetes_namespace.infra, helm_release.prometheus]
}

# ConfigMap with dashboard
resource "kubernetes_config_map" "dashboards" {
    metadata {
        name = "sample-app-dashboard"
        namespace = "infra"
        labels = {
            grafana_dashboard = "1"
        }
    }
    
    data = {
        "sample-app.json" = file("${path.module}/dashboards/sample-app.json")
    }
    
    depends_on = [kubernetes_namespace.infra]
}
