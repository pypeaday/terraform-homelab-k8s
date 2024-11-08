resource "kind_cluster" "foo" {
  wait_for_ready = false
  name           = var.cluster_name
  kind_config {
    api_version = "kind.x-k8s.io/v1alpha4"
    kind        = "Cluster"

    node {
      role = "control-plane"
      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]
      extra_port_mappings {
        container_port = 32080
        host_port      = 9080
      }
      extra_port_mappings {
        container_port = 32443
        host_port      = 9443
      }
      extra_port_mappings {
        container_port = 32090
        host_port      = 9090
      }
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}

# # for initial release in the cluster
resource "helm_release" "argocd" {

  depends_on = [kind_cluster.foo]

  chart      = "argo-cd"
  name       = var.argocd_deployment_name
  repository = "https://argoproj.github.io/argo-helm"
  version    = "7.0.0"

  namespace        = var.argocd_namespace
  create_namespace = true

  values = [yamlencode(local.argocd_helm_values)]

  # set {
  #   name  = "server.service.type"
  #   value = "LoadBalancer"
  # }

  # NOTE: ignore all changes because helm won't manage the lifecycle of argocd,
  # the plan is for argocd to manage itself
  # TODO: ignore once I have the config good enough
  # lifecycle {
  #   ignore_changes = all
  # }
}

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
