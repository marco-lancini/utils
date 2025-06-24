terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.2.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.44.0"
    }
  }
  required_version = ">= 1.1.0"
}
