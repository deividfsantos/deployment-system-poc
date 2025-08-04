resource "kubernetes_namespace" "infrastructure" {
    metadata { 
        name = "infrastructure"
    }
}

resource "kubernetes_namespace" "applications" {
    metadata { 
        name = "applications"
    }
}