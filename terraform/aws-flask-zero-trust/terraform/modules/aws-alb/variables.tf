variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the LB."
  type        = list(string)
}

variable "load_balancer_type" {
  description = "Type of load balancer to provision (network or application)."
  type        = string
  default     = "application"
}

variable "internal" {
  description = "Provision an internal load balancer. Defaults to false."
  type        = bool
  default     = false
}

variable "access_logs" {
  description = "An Access Logs block."
  type        = map(string)
  default     = {}
}

variable "idle_timeout" {
  description = "(Optional) The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application."
  type        = number
  default     = 60
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "enable_deletion_protection" {
  type        = bool
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer."
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  type        = bool
  description = "If true, cross-zone load balancing of the load balancer will be enabled. This is a network load balancer feature."
  default     = false
}

variable "enable_http2" {
  description = "Indicates whether HTTP/2 is enabled in application load balancers."
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
  type        = string
  default     = "ipv4"
}

variable "subnet_mapping" {
  description = "A list of subnet mapping blocks describing subnets to attach to network load balancer"
  type        = list(map(string))
  default     = []
}

variable "load_balancer_create_timeout" {
  description = "Timeout value when creating the ALB."
  type        = string
  default     = "15m"
}

variable "load_balancer_update_timeout" {
  description = "Timeout value when updating the ALB."
  type        = string
  default     = "15m"
}

variable "load_balancer_delete_timeout" {
  description = "Timeout value when deleting the ALB."
  type        = string
  default     = "15m"
}

variable "enable_http_to_https_redirect" {
  description = "Enable default redirect rule from port 80 to 443."
  type        = bool
  default     = false
}

variable "enable_http" {
  description = "Whether to allow traffic to port 80"
  type        = bool
  default     = false
}

variable "enable_https" {
  description = "Whether to allow traffic to port 443"
  type        = bool
  default     = false
}

variable "cidr_blocks" {
  type        = list(string)
  description = "List of CIDR ranges to allow at security group level. Defaults to 0.0.0.0/0"
  default     = ["0.0.0.0/0"]
}

variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "The description of the all resources."
}
