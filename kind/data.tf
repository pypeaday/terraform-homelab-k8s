# TODO: cannot read this... something is not configured right with hitting the k8s api and I'm just not sure what it is
# │ Error: Get "http://localhost/api/v1/namespaces/argocd/secrets/argocd-initial-admin-secret": dial tcp [::1]:80: connect: connection refused

data "kubernetes_secret" "argocd_admin" {

  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = helm_release.argocd.namespace
  }

}
