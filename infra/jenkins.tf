
resource "helm_release" "jenkins" {
    name = "jenkins"
    repository = "https://charts.jenkins.io"
    chart = "jenkins"
    namespace = "infrastructure"
    version = "4.3.0"

    timeout = 12000
    wait = true
    values = [
        file("${path.module}/values/jenkins-values.yaml")
    ]
    depends_on = [kubernetes_namespace.infrastructure, helm_release.prometheus]
}

# resource "kubernetes_config_map" "jenkins_pipeline" {
#   metadata {
#     name = "sample-app-pipeline"
#     namespace = "infrastructure"
#   }

#   data = {
#     "Jenkinsfile" = file("../app/sample-app/jenkinsfile")
#   }
#   depends_on = [ helm_release.jenkins ]
# }