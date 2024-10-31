# ==============================================================================
# Cloudflare Config
# ==============================================================================
variable "cloudflare_account_id" {
  description = "The Cloudflare Account ID"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare Zone to use for DNS"
  type        = string
}


# ==============================================================================
# Cloudflare Tunnel
# ==============================================================================
variable "tunnel_name" {
  description = "The name of the Cloudflare Tunnel"
  type        = string
}

variable "tunnel_dnsname" {
  description = "The DNS name of the Cloudflare Tunnel"
  type        = string
  default     = "admin"
}

variable "tunnel_hostname" {
  description = "The hostname of the Cloudflare Tunnel"
  type        = string
}

variable "tunnel_origin" {
  description = "The URL of the origin monitored by Cloudflare Tunnel"
  type        = string
}

# ==============================================================================
# Cloudflare Access Application
# ==============================================================================
variable "cloudflare_app_name" {
  description = "The name of the Cloudflare Access application"
  type        = string
}

variable "cloudflare_app_logo" {
  description = "The logo of the Cloudflare Access application"
  type        = string
  default     = ""
}

variable "cloudflare_app_allowed_emails" {
  description = "A list of emails to allow access to the Cloudflare Access application"
  type        = list(string)
}

# ==============================================================================
# Other
# ==============================================================================
variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default     = {}
}
