terraform {
  required_version = ">= 0.13.7"

  required_providers {
    aws = ">= 3.34"
  }
}

data "aws_region" "current" {}
