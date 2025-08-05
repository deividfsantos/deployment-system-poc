terraform {
  required_providers {
    kubernetes = {
        source = "hashicorp/kubernetes"
        version = "~> 2.10"
    }
    helm = {
        source = "hashicorp/helm"
        version = "~> 2.10"
    }
  }
  required_version = ">= 1.0"
}

provider "kubernetes" {
    config_path = "~/.kube/config"
}

provider "helm" {
    kubernetes {
        config_path = "~/.kube/config"
    }
}