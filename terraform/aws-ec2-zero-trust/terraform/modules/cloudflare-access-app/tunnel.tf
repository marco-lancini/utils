# ==============================================================================
# Tunnel
# ==============================================================================
resource "cloudflare_zero_trust_tunnel_cloudflared" "main" {
  account_id = var.cloudflare_account_id

  name   = var.tunnel_name
  secret = random_password.main.result
}

# Random password to use as the tunnel secret
resource "random_password" "main" {
  length  = 32
  special = false
}

# Tunnel Config
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "main" {
  account_id = var.cloudflare_account_id

  tunnel_id = cloudflare_zero_trust_tunnel_cloudflared.main.id

  config {
    warp_routing {
      enabled = true
    }
    ingress_rule {
      service = var.tunnel_origin
    }
  }
}

# ==============================================================================
# DNS routing for the tunnel:
#   sample.domain.com -> <tunnel-UUID>.cfargotunnel.com
# ==============================================================================
resource "cloudflare_record" "main" {
  zone_id = var.cloudflare_zone_id

  name    = var.tunnel_dnsname
  content = cloudflare_zero_trust_tunnel_cloudflared.main.cname

  type    = "CNAME"
  proxied = "true"
  ttl     = 1

  comment = var.tunnel_name
}
