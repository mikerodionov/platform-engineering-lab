terraform {
  required_version = ">= 1.10.0"

  # S3 Backend configuration
  # (Bucket details are injected via backend.hcl during 'terraform init')
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}
