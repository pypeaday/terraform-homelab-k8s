variable "domain" {
  type    = string
  default = "k8s.paynepride.com"
}

variable "argocd_password" {
  type    = string
  default = "admin"
}

variable "cluster_name" {
  type    = string
  default = "foo-tf"
}

variable "argocd_deployment_name" {
  type    = string
  default = "argocd"
}

variable "argocd_namespace" {
  type    = string
  default = "argocd"
}

variable "traefik_namespace" {
  type    = string
  default = "traefik"
}

variable "traefik_external_ips" {
  type    = list(string)
  default = []
}
