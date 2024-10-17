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
