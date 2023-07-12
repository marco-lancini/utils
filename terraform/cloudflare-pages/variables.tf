# ==============================================================================
# Cloudflare
# ==============================================================================
variable "cloudflare_account_id" {
  description = "The Cloudflare account ID"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare zone ID"
  type        = string
}


# ==============================================================================
# Cloudflare Pages Project
# ==============================================================================
variable "name" {
  description = "The name of the project"
  type        = string
}

variable "production_branch" {
  description = "The name of the production branch"
  type        = string
  default     = "main"
}

variable "environment_variables" {
  description = "A map of environment variables to set for the project"
  type        = map(string)
  default     = {}
}

# ==============================================================================
# Custom Domain
# ==============================================================================
variable "domain" {
  description = "The TLD to use for the project (e.g., example.com)"
  type        = string
  default     = null
}

variable "hostname" {
  description = "The hostname to use for the project (e.g., www)"
  type        = string
  default     = null
}


# ==============================================================================
# Zero Trust
# ==============================================================================
variable "zero_trust" {
  description = "Whether to enable Zero Trust for the project. False = publicly accessible, True = Zero Trust enabled"
  type        = bool
  default     = false
}

variable "allowed_emails" {
  description = "A list of emails to allow access to the Cloudflare Access application"
  type        = list(string)
}
