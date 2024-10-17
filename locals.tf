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
