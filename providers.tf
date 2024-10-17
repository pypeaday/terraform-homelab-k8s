terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.6.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.0"
    }
  }
}

provider "kind" {}

provider "kubernetes" {
  config_path = "./${local.cluster_name}-config"
}

provider "helm" {
  # Configuration options
  kubernetes {
    config_path = "./${local.cluster_name}-config"
  }
}

# provider "argocd" {

#   password = data.kubernetes_secret.argocd_admin.data["password"]
#   username = "admin"

#   # core = true

#   # auth_token                  = data.kubernetes_secret.argocd_admin.data["password"]
#   port_forward_with_namespace = local.argocd_namespace
#   kubernetes {
#     config_context = local.kubernetes_context
#   }

# }
