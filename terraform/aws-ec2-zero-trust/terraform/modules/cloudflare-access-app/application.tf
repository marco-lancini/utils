# ==============================================================================
# Application
# ==============================================================================
resource "cloudflare_zero_trust_access_application" "main" {
  account_id = var.cloudflare_account_id

  name   = var.cloudflare_app_name
  domain = var.tunnel_hostname

  type                  = "self_hosted"
  session_duration      = "24h"
  app_launcher_visible  = true
  app_launcher_logo_url = var.cloudflare_app_logo
}

# ==============================================================================
# Access Policy
# ==============================================================================
resource "cloudflare_zero_trust_access_policy" "main" {
  account_id     = var.cloudflare_account_id
  application_id = cloudflare_zero_trust_access_application.main.id

  name       = "Email Filter"
  precedence = "1"
  decision   = "allow"

  # Allowing access to specified email address only
  include {
    email = var.cloudflare_app_allowed_emails
  }

  require {
    email = var.cloudflare_app_allowed_emails
  }
}
