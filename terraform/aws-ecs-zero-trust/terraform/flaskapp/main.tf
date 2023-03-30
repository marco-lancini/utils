terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.54.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.2.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 1.1.0"
}
