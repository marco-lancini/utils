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
# Cloudflare Access App
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
# Cloudflare Tunnel
# ==============================================================================
variable "tunnel_name" {
  description = "The name of the Cloudflare Tunnel"
  type        = string
}

variable "tunnel_dnsname" {
  description = "The DNS name of the Cloudflare Tunnel"
  type        = string
}

variable "tunnel_hostname" {
  description = "The hostname of the Cloudflare Tunnel"
  type        = string
}

variable "tunnel_port" {
  description = "The port of the origin monitored by Cloudflare Tunnel"
  type        = number
}

variable "tunnel_origin" {
  description = "The URL of the origin monitored by Cloudflare Tunnel"
  type        = string
}

# ==============================================================================
# ECS Task/Service
# ==============================================================================
variable "service_name" {
  description = "The name of the ECS Service"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  type        = string
}

variable "ecr_cloudflared_name" {
  description = "The name of the ECR repository for cloudflared"
  type        = string
  default     = "cloudflared"
}

variable "ecr_flask_name" {
  description = "The name of the ECR repository for Flask"
  type        = string
  default     = "flask"
}

variable "container_cloudflared_name" {
  description = "The name of the Container for cloudflared"
  type        = string
}

variable "container_flask_name" {
  description = "The name of the Container for Flask"
  type        = string
}

variable "parameter_credentials_name" {
  description = "The name of the SSM Parameter storing the Tunnel credentials"
  type        = string
  default     = "FLASK_TUNNEL_CREDENTIALS"
}
