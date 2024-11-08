module "kind" {
  source = "./kind"

  argocd_deployment_name = var.argocd_deployment_name
  argocd_namespace       = var.argocd_namespace

  domain = var.domain

  argocd_password = var.argocd_password

  cluster_name = var.cluster_name

  traefik_namespace    = var.traefik_namespace
  traefik_external_ips = ["192.168.1.143"]
}
