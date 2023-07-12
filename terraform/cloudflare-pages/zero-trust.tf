locals {
  # ============================================================================
  # Domains
  # ============================================================================
  # Full Custom domain
  full_domain = "${var.hostname}.${var.domain}"
  # List of random domains (primary + subdomains)
  random_domains = toset([
    "*.${cloudflare_pages_project.project.subdomain}",
    cloudflare_pages_project.project.subdomain,
  ])

  # ============================================================================
  # CF Apps IDs
  # ============================================================================
  # Custom domain
  cf_id_custom = var.zero_trust ? [cloudflare_access_application.custom_domain[0].id] : []
  # Random domains
  cf_id_random = [
    for domain in local.random_domains : cloudflare_access_application.random_domains[domain].id
  ]
  # Merged list
  cloudflare_apps_ids = toset(concat(
    local.cf_id_custom,
    local.cf_id_random,
  ))
}


# ==============================================================================
# Cloudflare Access Application
# ==============================================================================
#
# Application for custom domain
#
resource "cloudflare_access_application" "custom_domain" {
  count = var.zero_trust ? 1 : 0

  account_id = var.cloudflare_account_id

  name   = "Pages: ${var.name}"
  domain = local.full_domain

  type                 = "self_hosted"
  session_duration     = "24h"
  app_launcher_visible = true
}

#
# Application for random domains
#
resource "cloudflare_access_application" "random_domains" {
  for_each = var.zero_trust ? local.random_domains : toset([])

  account_id = var.cloudflare_account_id

  name   = "Pages: ${var.name} - ${each.key}"
  domain = each.key

  type                 = "self_hosted"
  session_duration     = "24h"
  app_launcher_visible = false

  depends_on = [
    cloudflare_pages_project.project,
  ]
}


# ==============================================================================
# Access Policies
# ==============================================================================
resource "cloudflare_access_policy" "domains" {
  for_each = local.cloudflare_apps_ids

  account_id     = var.cloudflare_account_id
  application_id = each.key

  name       = "Email Filter for ${var.name} - ${each.key}"
  precedence = "1"
  decision   = "allow"

  # Allowing access to specified email address only
  include {
    email = var.allowed_emails
  }

  require {
    email = var.allowed_emails
  }

  depends_on = [
    cloudflare_pages_project.project,
  ]

}
