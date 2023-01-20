terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.29.0"
    }
    local = {
      source = "hashicorp/local"
    }
  }
  required_version = ">= 1.1.0"
}
