# ==============================================================================
# Service Account
# ==============================================================================
resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = var.sa_name
  display_name = var.sa_display_name
  description  = "Service account for AWS workload identity authentication"
}

# ==============================================================================
# Service Account Permissions
# ==============================================================================
resource "google_project_iam_member" "sa_roles" {
  count = length(var.sa_roles)

  project = var.project_id
  role    = var.sa_roles[count.index]
  member  = "serviceAccount:${google_service_account.sa.email}"
}

# ==============================================================================
# Service Account Impersonation Permission
# ==============================================================================
resource "google_service_account_iam_binding" "token_creator" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.serviceAccountTokenCreator"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.aws_pool.name}/*"
  ]
}
