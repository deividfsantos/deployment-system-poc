
resource "helm_release" "jenkins" {
    name = "jenkins"
    repository = "https://charts.jenkins.io"
    chart = "jenkins"
    namespace = "infra"

    set {
        name = "controller.adminPassword"
        value = "admin123"
    }

    set {
        name = "controller.serviceType"
        value = "ClusterIP"
    }

    depends_on = [kubernetes_namespace.infra]
}