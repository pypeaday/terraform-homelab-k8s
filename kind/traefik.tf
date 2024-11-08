# TODO It'd be nice actually to use an argocd app as apart of the cluster setup
# for this. helm release is fine but feels anti-patternish. but I want traefik
# apart of the cluster setup, not my apps setup
# resource "helm_release" "traefik" {

#   depends_on = [kind_cluster.foo]

#   name       = "traefik"
#   chart      = "traefik"
#   repository = "https://traefik.github.io/charts"

#   namespace        = var.traefik_namespace
#   create_namespace = true

#   values = [yamlencode(local.traefik_helm_values)]
# }

resource "argocd_application" "traefik" {

  depends_on = [helm_release.argocd]

  metadata {
    name      = "traefik"
    namespace = var.argocd_namespace
    labels = {
      test = "true"
    }
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.traefik_namespace
    }

    source {
      chart    = "traefik"
      repo_url = "https://traefik.github.io/charts"

      helm {
        # release_name = local.argocd_deployment_name
        # parameter {
        #   name  = "image.tag"
        #   value = "1.2.3"
        # }
        # parameter {
        #   name  = "someotherparameter"
        #   value = "true"
        # }
        # value_files = ["values-test.yml"]
        values = yamlencode(local.traefik_helm_values)
      }
    }
    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
    }
  }

}
