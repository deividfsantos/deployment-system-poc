
resource "helm_release" "jenkins" {
    name = "jenkins"
    repository = "https://charts.jenkins.io"
    chart = "jenkins"
    namespace = "infrastructure"

    timeout = 12000
    wait = true
    values = [
        file("${path.module}/values/jenkins-values.yaml")
    ]
    depends_on = [
        kubernetes_namespace.infrastructure, 
        helm_release.prometheus
    ]
}

resource "kubernetes_cluster_role" "jenkins_deploy" {
  metadata {
    name = "jenkins-deploy"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "services", "pods"]
    verbs      = ["get", "list", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_cluster_role_binding" "jenkins_deploy_binding" {
  metadata {
    name = "jenkins-deploy-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.jenkins_deploy.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "jenkins"
    namespace = "infrastructure"
  }

  depends_on = [
    kubernetes_cluster_role.jenkins_deploy,
    helm_release.jenkins
  ]
}
