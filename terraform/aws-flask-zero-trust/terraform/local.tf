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
  # Tunnel
  tunnel_name     = "flask"
  tunnel_dnsname  = "flask"
  tunnel_hostname = "${local.tunnel_dnsname}.${local.example_domain}"
  tunnel_origin   = "http://127.0.0.1:5000"

  # Access Application
  cf_app_name = "Flask Example"

  # ECS
  ecs_cluster_name = "flask_cluster"

  # ECR
  ecr_cloudflared_name = "cloudflared"
  ecr_flask_name       = "flask"

}
