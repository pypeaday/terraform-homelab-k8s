resource "kind_cluster" "foo" {
  wait_for_ready = false
  name           = var.cluster_name
  kind_config {
    api_version = "kind.x-k8s.io/v1alpha4"
    kind        = "Cluster"

    node {
      role = "control-plane"
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

}
