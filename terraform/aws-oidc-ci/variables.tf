# ==============================================================================
# AWS
# ==============================================================================
variable "role_name" {
  description = "Name of the role to create"
  type        = string
  default     = "GithubActionsRole"
}

variable "grant_admin_permissions" {
  description = "Whether to grant Administrator role"
  type        = bool
  default     = false
}

# ==============================================================================
# GITHUB
# ==============================================================================
variable "allow_github" {
  description = "Whether to allow Github to access AWS"
  default     = false
}

variable "github_url" {
  description = "The URL of the token endpoint for Github"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "github_org" {
  description = "Github Org to trust"
  type        = string
}

variable "github_repos" {
  description = "Github repos to trust"
  type        = list(string)
  default     = []
}

# ==============================================================================
# GITLAB
# ==============================================================================
variable "allow_gitlab" {
  description = "Whether to allow Gitlab to access AWS"
  default     = false
}

variable "gitlab_url" {
  description = "The URL of the token endpoint for Gitlab"
  type        = string
  default     = "https://gitlab.com"
}

variable "gitlab_repos" {
  description = "Gitlab repos to trust"
  type        = list(string)
  default     = []
}
