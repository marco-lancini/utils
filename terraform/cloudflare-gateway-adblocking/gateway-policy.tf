# ==============================================================================
# POLICY: Block Ads
# ==============================================================================
locals {
  # Iterate through each pihole_domain_list resource and extract its ID
  pihole_domain_lists = [for k, v in cloudflare_teams_list.pihole_domain_lists : v.id]

  # Format the values: remove dashes and prepend $
  pihole_domain_lists_formatted = [for v in local.pihole_domain_lists : format("$%s", replace(v, "-", ""))]

  # Create filters to use in the policy
  pihole_ad_filters = formatlist("any(dns.domains[*] in %s)", local.pihole_domain_lists_formatted)
  pihole_ad_filter  = join(" or ", local.pihole_ad_filters)
}

resource "cloudflare_teams_rule" "block_ads" {
  account_id = local.cloudflare_account_id

  name        = "Block Ads"
  description = "Block Ads domains"

  enabled    = true
  precedence = 11

  # Block domain belonging to lists (defined below)
  filters = ["dns"]
  action  = "block"
  traffic = local.pihole_ad_filter

  rule_settings {
    block_page_enabled = false
  }
}

