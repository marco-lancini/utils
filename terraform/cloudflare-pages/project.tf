# ==============================================================================
# Cloudflare Pages Project
# ==============================================================================
resource "cloudflare_pages_project" "project" {
  account_id        = var.cloudflare_account_id
  name              = var.name
  production_branch = var.production_branch

  deployment_configs {
    preview {
      always_use_latest_compatibility_date = true
      d1_databases                         = {}
      durable_object_namespaces            = {}
      environment_variables                = var.environment_variables
      fail_open                            = false
      kv_namespaces                        = {}
      r2_buckets                           = {}
      secrets                              = {}
    }

    production {
      always_use_latest_compatibility_date = false
      d1_databases                         = {}
      durable_object_namespaces            = {}
      environment_variables                = var.environment_variables
      fail_open                            = false
      kv_namespaces                        = {}
      r2_buckets                           = {}
      secrets                              = {}
    }
  }
}


# ==============================================================================
# Custom Domain
# ==============================================================================
resource "cloudflare_pages_domain" "domain" {
  count = var.domain != null ? 1 : 0

  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.project.name
  domain       = local.full_domain
}

# DNS record for the custom domain
resource "cloudflare_record" "domain" {
  count = var.domain != null ? 1 : 0

  zone_id = var.cloudflare_zone_id
  name    = var.hostname
  value   = cloudflare_pages_project.project.domains[0]
  type    = "CNAME"
  proxied = "true"
  ttl     = 1
  comment = "Page: ${cloudflare_pages_project.project.name}"
}
