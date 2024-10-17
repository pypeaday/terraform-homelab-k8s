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

variable "traefik_external_ips" {
  type = list(string)
  # TODO: change to your host IP
  default = ["192.168.1.143"]
}
