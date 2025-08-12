
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

# ServiceAccount for Jenkins deployments
resource "kubernetes_service_account" "jenkins_deployer" {
  metadata {
    name      = "jenkins-deployer"
    namespace = "infrastructure"
  }
}

resource "kubernetes_role" "manage_deployments" {
  metadata {
    name      = "manage-deployments"
    namespace = "applications"
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "replicasets"]
    verbs      = ["get", "list", "watch", "update", "patch", "delete", "create"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
  # Permissions for Helm secrets (releases are stored as secrets)
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
  # Permissions for ConfigMaps (Helm may use them)
  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_role_binding" "jenkins_deploy" {
  metadata {
    name      = "jenkins-deploy"
    namespace = "applications"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins_deployer.metadata[0].name
    namespace = kubernetes_service_account.jenkins_deployer.metadata[0].namespace
  }

  role_ref {
    kind     = "Role"
    name     = kubernetes_role.manage_deployments.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role" "list_namespaces" {
  metadata {
    name = "list-namespaces"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["list"]
  }
}

resource "kubernetes_cluster_role_binding" "jenkins_list_namespaces" {
  metadata {
    name = "jenkins-list-namespaces"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins_deployer.metadata[0].name
    namespace = kubernetes_service_account.jenkins_deployer.metadata[0].namespace
  }

  role_ref {
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.list_namespaces.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}