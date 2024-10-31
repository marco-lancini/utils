# ==============================================================================
# INSTANCE
# ==============================================================================
variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_user_data" {
  description = "The user data for the EC2 instance"
  type        = string
  default     = ""
}

variable "instance_state" {
  description = "The state of the EC2 instance"
  type        = string
  default     = "running"
}

variable "instance_key_name" {
  description = "The key name for the EC2 instance"
  type        = string
  default     = null
}

# ==============================================================================
# NETWORKING
# ==============================================================================
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/28"
}

variable "vpc_enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "public_subnet_cidr" {
  description = "The CIDR blocks for the public subnet"
  type        = string
  default     = "10.0.0.0/28"
}

variable "enable_ssh_access" {
  description = "A boolean flag to allow/disallow SSH traffic to the EC2 instance"
  type        = bool
  default     = false
}

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
