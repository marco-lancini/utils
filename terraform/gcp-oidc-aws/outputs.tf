# ==============================================================================
# Service Account
# ==============================================================================
output "service_account_email" {
  description = "Email of the service account"
  value       = google_service_account.sa.email
}

output "service_account_name" {
  description = "Name of the service account"
  value       = google_service_account.sa.name
}

# ==============================================================================
# Workload Identity
# ==============================================================================
output "workload_identity_pool_id" {
  description = "ID of the workload identity pool"
  value       = google_iam_workload_identity_pool.aws_pool.name
}

output "workload_identity_provider_name" {
  description = "Name of the workload identity provider"
  value       = google_iam_workload_identity_pool_provider.aws_provider.name
}

output "workload_identity_provider_audience" {
  description = "Audience for the workload identity provider (for AWS STS calls)"
  value       = "//iam.googleapis.com/${google_iam_workload_identity_pool.aws_pool.name}/providers/${google_iam_workload_identity_pool_provider.aws_provider.workload_identity_pool_provider_id}"
}
