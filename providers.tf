terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.6.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.0"
    }
  }
  backend "s3" {
    # endpoint = {
    #   s3 = "http://192.168.1.9:9004" # Minio endpoint
    # }
    endpoint = "http://192.168.1.9:9004"
    # NOTE: check readme for terraform init information
    bucket = "terraform-homelab-k8s"
    key    = "terraform.state"
    region = "main"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}

provider "argocd" {

  password = var.argocd_password
  username = "admin"
  # auth_token = var.argocd_password

  # server_addr = kind_cluster.foo.endpoint
  # server_addr = "cd.argoproj.io"

  # core     = true
  # insecure = true

  port_forward_with_namespace = var.argocd_namespace
  grpc_web                    = true
  kubernetes {
    host = module.kind_cluster.foo.endpoint

    cluster_ca_certificate = module.kind_cluster.foo.cluster_ca_certificate

    config_context = module.kind_cluster.output.kubernetes_context
  }

  # client_cert_file = jsonencode(kind_cluster.foo.client_certificate)
  # client_cert_key  = kind_cluster.foo.client_key
}
