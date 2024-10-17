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


provider "kubernetes" {
  config_path = pathexpand("./${var.cluster_name}-config")
}

provider "helm" {
  # Configuration options
  kubernetes {
    config_path = pathexpand("./${var.cluster_name}-config")
  }
}

# provider "argocd" {

#   password = data.kubernetes_secret.argocd_admin.data["password"]
#   username = "admin"

#   #   server_addr = kind_cluster.foo.endpoint

#   # core = true

#   # auth_token                  = data.kubernetes_secret.argocd_admin.data["password"]
#   port_forward_with_namespace = local.argocd_namespace
#   kubernetes {

#     cluster_ca_certificate = kind_cluster.foo.cluster_ca_certificate

#     config_context = local.kubernetes_context
#   }

#   client_cert_file = jsonencode(kind_cluster.foo.client_certificate)
#   client_cert_key  = kind_cluster.foo.client_key
# }
