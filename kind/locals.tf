locals {
  kubernetes_context = "kind-${var.cluster_name}"
  traefik_helm_values = {
    service = {
      # type = "NodePort"
      externalIPs = var.traefik_external_ips
    }
    ports = {
      web = {
        nodePort = 30000
        # port       = 80
        # targetPort = 80
      }
      websecure = {
        nodePort = 30001
        # port       = 443
        # targetPort = 443
      }
    }
    # additionalArguments = [
    #   "--entrypoints.web.address=:30000",
    #   "--entrypoints.websecure.address=:30001"
    # ]
    nodeSelector = {
      "ingress-ready" = "true"
    }
    tolerations = [
      {
        key      = "node-role.kubernetes.io/master"
        operator = "Equal"
        effect   = "NoSchedule"
      },
      # for kind
      {
        key      = "node-role.kubernetes.io/control-plane"
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
