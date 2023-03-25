terraform {
  required_version = ">= 0.13.7"

  required_providers {
    aws = ">= 3.40"
  }
}

data "aws_region" "current" {}
