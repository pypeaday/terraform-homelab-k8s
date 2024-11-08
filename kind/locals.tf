locals {
  kubernetes_context = "kind-${var.cluster_name}"
  traefik_helm_values = {
    providers = {
      kubernetesCRD = {
        namespaces   = [var.traefik_namespace, "default", "all"]
        ingressClass = "traefik"
      }
      kubernetesIngress = {
        namespaces   = [var.traefik_namespace, "default", "all"]
        ingressClass = "traefik"
      }
    }
    service = {
      # type = "LoadBalancer"
      type = "NodePort"
      # externalIPs = var.traefik_external_ips
    }
    ports = {
      traefik = {
        # expose   = true
        nodePort = 32090
      }
      web = {
        nodePort = 32080
      }
      websecure = {
        nodePort = 32443
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
      domain = var.domain
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
            name = "argocd.${var.domain}"
            path = "/"
          }
        ]
        extraRules = [
          {
            host = "argocd.${var.domain}"
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
