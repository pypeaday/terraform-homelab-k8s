locals {
  kubernetes_context = "kind-${var.cluster_name}"
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
      secret = {
        argocdServerAdminPassword = bcrypt(var.argocd_password)
      }
    }
    server = {
      ingress = {
        enabled = true
        labels = {
          "user/sandbox" = "true"
        }
        annotations = {
          "kubernetes.io/ingress.class" = "traefik"
        }
        ingressClassName = "traefik"
        extraHosts = [
          {
            name = "argocd.k8s.${var.domain}"
            path = "/"
          }
        ]
        extraRules = [
          {
            host = "argocd.k8s.${var.domain}"
            http = {
              paths = [
                {
                  path     = "/"
                  pathType = "Prefix"
                  backend = {
                    service = {
                      name = "argocd-server"
                      port = {
                        # name = "https"
                        name = "http"
                      }
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}
