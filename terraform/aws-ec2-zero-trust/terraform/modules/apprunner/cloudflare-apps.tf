# ==============================================================================
# Cloudflare Access Applications
# ==============================================================================
module "cf_apps" {
  for_each = var.apps
  source   = "../cloudflare-access-app"

  # Cloudflare Config
  cloudflare_account_id = var.cloudflare_account_id
  cloudflare_zone_id    = var.cloudflare_zone_id

  # Cloudflare Tunnel
  tunnel_name     = "${var.prefix}_${each.value.name}"
  tunnel_dnsname  = each.value.name
  tunnel_hostname = each.value.hostname
  tunnel_origin   = each.value.origin

  # Cloudflare Access Application
  cloudflare_app_name           = "${var.prefix}_${each.value.name}"
  cloudflare_app_allowed_emails = var.cloudflare_app_allowed_emails

  tags = var.tags
}
