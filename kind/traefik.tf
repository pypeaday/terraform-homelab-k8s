# TODO It'd be nice actually to use an argocd app as apart of the cluster setup
# for this. helm release is fine but feels anti-patternish. but I want traefik
# apart of the cluster setup, not my apps setup
resource "helm_release" "traefik" {

  depends_on = [kind_cluster.foo]

  name       = "traefik"
  chart      = "traefik"
  repository = "https://traefik.github.io/charts"

  namespace        = var.traefik_namespace
  create_namespace = true

  values = [yamlencode(local.traefik_helm_values)]
}
