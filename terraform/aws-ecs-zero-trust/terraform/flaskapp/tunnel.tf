# ==============================================================================
# Cloudflare Tunnel
# ==============================================================================
#
# Tunnel
#
resource "cloudflare_tunnel" "flask" {
  account_id = var.cloudflare_account_id

  name   = var.tunnel_name
  secret = random_password.flask_token.result
}

# Random password to use as the tunnel secret
resource "random_password" "flask_token" {
  length  = 32
  special = false
}

#
# Tunnel Config
#
resource "cloudflare_tunnel_config" "flask" {
  account_id = var.cloudflare_account_id

  tunnel_id = cloudflare_tunnel.flask.id

  config {
    warp_routing {
      enabled = false
    }
    ingress_rule {
      service = var.tunnel_origin
    }
  }

}

#
# DNS routing for the tunnel:
#   flask.example.com -> <tunnel-UUID>.cfargotunnel.com
#
resource "cloudflare_record" "flask_tunnel" {
  zone_id = var.cloudflare_zone_id

  name  = var.tunnel_dnsname
  value = cloudflare_tunnel.flask.cname

  type    = "CNAME"
  proxied = "true"
  ttl     = 1
}


# ==============================================================================
# Cloudflare Access Application
# ==============================================================================
#
# Application
#
resource "cloudflare_access_application" "flask" {
  account_id = var.cloudflare_account_id

  name   = var.cloudflare_app_name
  domain = var.tunnel_hostname

  type                 = "self_hosted"
  session_duration     = "24h"
  app_launcher_visible = true
  logo_url             = var.cloudflare_app_logo
}

#
# Access Policy
#
resource "cloudflare_access_policy" "flask" {
  account_id     = var.cloudflare_account_id
  application_id = cloudflare_access_application.flask.id

  name       = "Email Filter for ${var.cloudflare_app_name}"
  precedence = "1"
  decision   = "allow"

  include {
    email = var.cloudflare_app_allowed_emails
  }

}
