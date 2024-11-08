# resource "argocd_repository" "public_traefik_helm" {
#   depends_on = [helm_release.argocd]

#   repo = "https://traefik.github.io/charts"
#   name = "traefik"
#   type = "helm"
# }

# resource "argocd_repository" "public_argocd_helm" {
#   depends_on = [helm_release.argocd]

#   repo = "https://argoproj.github.io/argo-helm"
#   name = "argocd"
#   type = "helm"
# }

# # Public Git repository
# resource "argocd_repository" "public_git" {
#   repo = "git@github.com:user/somerepo.git"
# }
