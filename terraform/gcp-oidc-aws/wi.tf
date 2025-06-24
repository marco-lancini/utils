# ==============================================================================
# Workload Identity Pool
# ==============================================================================
resource "google_iam_workload_identity_pool" "aws_pool" {
  project = var.project_id

  workload_identity_pool_id = var.wi_pool_id
  display_name              = var.wi_pool_display_name
  description               = "Workload Identity Pool for AWS resources - Account ${var.aws_account_id}"
  disabled                  = false
}

# ==============================================================================
# Workload Identity Pool Provider (AWS)
# ==============================================================================
locals {
  # Build conditions for allowed AWS roles
  aws_role_conditions = [
    for role in var.aws_roles :
    "assertion.arn.contains('assumed-role/${role}/')"
  ]

  # Build final attribute condition - must match account AND one of the allowed roles
  attribute_condition = length(local.aws_role_conditions) > 0 ? "assertion.account == '${var.aws_account_id}' && (${join(" || ", local.aws_role_conditions)})" : "assertion.account == '${var.aws_account_id}'"
}


resource "google_iam_workload_identity_pool_provider" "aws_provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.aws_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.wi_pool_provider_id
  display_name                       = var.wi_pool_provider_display_name
  description                        = "AWS OIDC provider for workload identity - Account ${var.aws_account_id}"

  aws {
    account_id = var.aws_account_id
  }

  # Restrict access only to specified AWS Accounts and Roles
  attribute_condition = local.attribute_condition

  attribute_mapping = {
    "google.subject"        = "assertion.arn"
    "attribute.aws_role"    = "assertion.arn.contains('assumed-role') ? assertion.arn.extract('{account_arn}assumed-role/{role_name}/') : assertion.arn"
    "attribute.aws_arn"     = "assertion.arn"
    "attribute.aws_account" = "assertion.account"
  }
}

# ==============================================================================
# Service Account IAM Binding
# ==============================================================================
resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    for role in var.aws_roles :
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.aws_pool.name}/attribute.aws_role/arn:aws:sts::${var.aws_account_id}:assumed-role/${role}/*"
  ]
}
