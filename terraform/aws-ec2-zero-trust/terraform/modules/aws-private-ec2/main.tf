terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.54.0"
    }
  }
}

data "aws_region" "current" {}
