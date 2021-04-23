variable "is_hub" {
  type        = bool
  default     = false
  description = "Whether the current account has to be used as Hub."
}

variable "hub_account_id" {
  type        = string
  description = "The ID of the AWS account to be used as Hub."
}

variable "role_audit_name" {
  type        = string
  default     = "role_security_audit"
  description = "The name of the role used for security auditing."
}

variable "role_assume_name" {
  type        = string
  default     = "role_security_assume"
  description = "The name of the role able to assume role_audit_name."
}

variable "security_user_name" {
  type        = string
  default     = "user_security_audit"
  description = "The name of the IAM user able to assume the roles."
}

variable "max_session_duration" {
  type        = number
  default     = 21600 # 6 hours
  description = "Maximum session duration (in seconds) that you want to set for the specified role."
}
