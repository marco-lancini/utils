# ==============================================================================
# Sample config
# ==============================================================================
data "cloudflare_zone" "example" {
  account_id = local.cloudflare_account_id
  name       = local.example_domain
}

locals {
  #
  # Cloudflare Zone
  #
  cloudflare_account_id = "1234567890"
  example_domain        = "example.com"
  allowed_emails = [
    "marco@example.com"
  ]

  #
  # AppRunner Config
  #
  enable_apprunner = local.accounts["OPS"].config.tf_enable_apprunner

  apprunner_prefix                     = "apprunner"
  apprunner_instance_type              = "t2.micro"
  apprunner_instance_state             = "running"
  apprunner_instance_public_key        = "ssh-rsa ..."
  apprunner_instance_enable_ssh_access = true

  apprunner_apps = {
    sample = {
      name     = "sample"
      origin   = "http://nginx:80"
      hostname = "sample.${local.example_domain}"
    }
    other = {
      name     = "other"
      origin   = "http://127.0.0.1:8080"
      hostname = "other.${local.example_domain}"
    }
  }

}

# ==============================================================================
# AppRunner
# ==============================================================================
module "apprunner" {
  count = local.enable_apprunner ? 1 : 0

  source = "./modules/apprunner"

  # EC2 Config
  prefix                     = local.apprunner_prefix
  instance_type              = local.apprunner_instance_type
  instance_state             = local.apprunner_instance_state
  instance_enable_ssh_access = local.apprunner_instance_enable_ssh_access
  instance_public_key        = local.apprunner_instance_public_key

  # Cloudflare Config
  cloudflare_account_id         = local.cloudflare_account_id
  cloudflare_zone_id            = data.cloudflare_zone.example.zone_id
  cloudflare_app_allowed_emails = local.allowed_emails

  # Apps
  apps = local.apprunner_apps

  tags = {
    App = "AppRunner"
  }
}
