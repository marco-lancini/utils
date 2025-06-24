# ==============================================================================
# GCP
# ==============================================================================
variable "project_id" {
  type        = string
  description = "The project_id where to create WIF pool and service account"
}

#
# Service Account
#
variable "sa_name" {
  type        = string
  description = "The name of the Service Account used by AWS workloads"
}

variable "sa_display_name" {
  type        = string
  description = "Display name for the service account"
}

variable "sa_roles" {
  type        = list(string)
  description = "List of roles to assign to the service account"
  default     = []
}

#
# WI Pool
#
variable "wi_pool_id" {
  type        = string
  description = "Workload Identity Pool ID"
}

variable "wi_pool_display_name" {
  type        = string
  description = "Workload Identity Pool Display Name"
}

#
# WI Provider
#
variable "wi_pool_provider_id" {
  type        = string
  description = "Workload Identity Pool Provider ID"
}

variable "wi_pool_provider_display_name" {
  type        = string
  description = "Workload Identity Pool Provider Display Name"
}

# ==============================================================================
# AWS
# ==============================================================================
variable "aws_account_id" {
  type        = string
  description = "AWS Account ID to trust"
}

variable "aws_roles" {
  type        = list(string)
  description = "List of AWS IAM role names that can impersonate the GCP service account"
  default     = []
}
