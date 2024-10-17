locals {
  argocd_deployment_name = "argocd"
  argocd_namespace       = "argocd"
  cluster_name           = "foo-tf"
  kubernetes_context     = "kind-${local.cluster_name}"
  traefik_helm_values = {
    serfice = {
      type = "NodePort"
    }
    ports = {
      web = {
        nodePort = 30000
      }
      websecure = {
        nodePort = 30001
      }
    }
    nodeSelector = {
      "ingress-ready" = "true"
    }
    tolerations = [
      {
        key      = "node-role.kubernetes.io/master"
        operator = "Equal"
        effect   = "NoSchedule"
      }
    ]
  }
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
