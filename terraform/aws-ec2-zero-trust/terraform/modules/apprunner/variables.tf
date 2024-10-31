# ==============================================================================
# GENERAL
# ==============================================================================
variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "prefix" {
  description = "A prefix for the names of the resources"
  type        = string
  default     = ""
}

# ==============================================================================
# INSTANCE
# ==============================================================================
variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
}

variable "instance_state" {
  description = "The state of the EC2 instance"
  type        = string
}

variable "instance_enable_ssh_access" {
  description = "Enable SSH access to the EC2 instance"
  type        = bool
  default     = false
}

variable "instance_public_key" {
  description = "The public key for the EC2 instance"
  type        = string
}

# ==============================================================================
# CLOUDFLARE
# ==============================================================================
variable "cloudflare_account_id" {
  description = "The Cloudflare Account ID"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare Zone to use for DNS"
  type        = string
}

variable "cloudflare_app_allowed_emails" {
  description = "A list of emails to allow access to the Cloudflare Access application"
  type        = list(string)
}

# ==============================================================================
# APPS
# ==============================================================================
variable "apps" {
  description = "A map of apps to deploy"
  type = map(object({
    name     = string
    origin   = string
    hostname = string
  }))
}
