locals {
  argocd_deployment_name = "argocd"
  argocd_namespace       = "argocd"
  cluster_name           = "foo-tf"
  kubernetes_context     = "kind-${local.cluster_name}"
  argocd_helm_values = {
    global = {
      domain = "localhost"
      podLabels = {
        testLabel = "baz"
      }
    }
    configs = {
      params = {
        "server.insecure" = true
      }
    }
  }

}

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

resource "kind_cluster" "foo" {
  wait_for_ready = false
  name           = local.cluster_name
  kind_config {
    api_version = "kind.x-k8s.io/v1alpha4"
    kind        = "Cluster"

    node {
      role = "control-plane"
    }

    node {
      role = "worker"
    }
  }
}

provider "kubernetes" {
  config_path = "./${local.cluster_name}-config"
}

provider "helm" {
  # Configuration options
  kubernetes {
    config_path = "./${local.cluster_name}-config"
  }
}

# for initial release in the cluster
resource "helm_release" "argocd" {

  depends_on = [kind_cluster.foo]

  chart      = "argo-cd"
  name       = local.argocd_deployment_name
  repository = "https://argoproj.github.io/argo-helm"
  version    = "7.0.0"

  namespace        = local.argocd_namespace
  create_namespace = true

  values = [yamlencode(local.argocd_helm_values)]

  # set {
  #   name  = "server.service.type"
  #   value = "LoadBalancer"
  # }

  lifecycle {
    ignore_changes = all
  }
}


data "kubernetes_secret" "argocd_admin" {

  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = helm_release.argocd.namespace
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

# TODO: having problems using terraform to make the argocd app - but for homelab
# I think I'll just use terraform to make a cluster with argocd and then use
# helm charts and a repo for argocd apps
# resource "argocd_application" "argocd" {

#   # depends_on = [kind_cluster.foo]

#   metadata {
#     name      = helm_release.argocd.name
#     namespace = helm_release.argocd.namespace
#     labels = {
#       test = "true"
#     }
#   }

#   spec {
#     destination {
#       server    = "https://kubernetes.default.svc"
#       namespace = local.argocd_namespace
#     }

#     source {
#       # repo_url = "TODO: build charts and upload somewhere"
#       # repo_url = "https://github.com/pypeaday/helm-charts.git"
#       # path            = "argocd"
#       # target_revision = "HEAD"

#       repo_url        = "https://argoproj.github.io/argo-helm"
#       chart           = "argo-cd"
#       target_revision = "7.0.0"

#       helm {
#         # release_name = local.argocd_deployment_name
#         # parameter {
#         #   name  = "image.tag"
#         #   value = "1.2.3"
#         # }
#         # parameter {
#         #   name  = "someotherparameter"
#         #   value = "true"
#         # }
#         # value_files = ["values-test.yml"]
#         values = yamlencode(local.argocd_helm_values)
#       }
#     }
#   }
# }
