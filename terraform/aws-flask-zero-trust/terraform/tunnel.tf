# ==============================================================================
# Cloudflare Tunnel
# ==============================================================================
#
# Tunnel
#
resource "cloudflare_tunnel" "flask" {
  account_id = local.cloudflare_account_id

  name   = local.tunnel_name
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
  account_id = local.cloudflare_account_id

  tunnel_id = cloudflare_tunnel.flask.id

  config {
    warp_routing {
      enabled = false
    }
    ingress_rule {
      service = local.tunnel_origin
    }
  }

}

#
# DNS routing for the tunnel:
#   flask.example.com -> <tunnel-UUID>.cfargotunnel.com
#
resource "cloudflare_record" "flask_tunnel" {
  zone_id = data.cloudflare_zone.example.zone_id

  name  = local.tunnel_dnsname
  value = cloudflare_tunnel.flask.cname

  type    = "CNAME"
  proxied = "true"
  ttl     = 1
}
