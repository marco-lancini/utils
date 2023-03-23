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

  #
  # Resources
  #
  # Tunnel
  tunnel_name    = "flask"
  tunnel_dnsname = "flask" # flask.example.com
  tunnel_origin  = "http://127.0.0.1:5000"

  # ECR
  ecr_cloudflared_name = "cloudflared"
  ecr_flask_name       = "flask"

}
