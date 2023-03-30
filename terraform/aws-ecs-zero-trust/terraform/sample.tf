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
  # Resources
  #
  # General
  app_name = "flask"

  # Access Application
  cf_app_name = "Flask Example"

  # Tunnel
  tunnel_dnsname  = "flask"
  tunnel_hostname = "${local.tunnel_dnsname}.${local.example_domain}"
  tunnel_port     = 5000
  tunnel_origin   = "http://127.0.0.1:${local.tunnel_port}"
}


# ==============================================================================
# Sample webapp behind Cloudflare Tunnel
# ==============================================================================
module "web" {
  source = "./flaskapp"

  # Cloudflare Config
  cloudflare_account_id = local.cloudflare_account_id
  cloudflare_zone_id    = data.cloudflare_zone.example.zone_id

  # Cloudflare Access App
  cloudflare_app_name           = local.cf_app_name
  cloudflare_app_allowed_emails = local.allowed_emails

  # Cloudflare Tunnel
  tunnel_name     = local.app_name
  tunnel_dnsname  = local.tunnel_dnsname
  tunnel_hostname = local.tunnel_hostname
  tunnel_port     = local.tunnel_port
  tunnel_origin   = local.tunnel_origin

  # ECS Task/Service
  service_name               = local.app_name
  ecs_cluster_name           = "${local.app_name}_cluster"
  ecr_flask_name             = "${local.app_name}_flask_server"
  container_cloudflared_name = "${local.app_name}_cloudflared"
  container_flask_name       = "${local.app_name}_flask_server"
}
