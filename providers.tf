terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.6.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.0"
    }
  }
  backend "s3" {
    # NOTE: check readme for terraform init information
    bucket = "homelab-terraform-state"
    key    = "terraform.state"
    region = "main"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}
