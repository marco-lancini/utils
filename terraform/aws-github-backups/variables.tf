variable "ecs_cluster_name" {
  description = "Name of the ECS Cluster"
  default     = "backup-tasks-ecs-cluster"
}

variable "s3_backups_github" {
  description = "Name of the S3 bucket where to store output"
  type        = string
}

variable "ecr_backups_github" {
  description = "Name of the ECR repo hosting the Docker image of python-github-backup"
  type        = string
  default     = "python-github-backup"
}

variable "ecr_image_version_github" {
  description = "Version of the Docker image of python-github-backup"
  type        = string
  default     = "latest"
}

variable "ecs_task_github" {
  description = "Name of the ECS task"
  type        = string
  default     = "github-backup"
}

variable "sns_backups_github" {
  description = "Name of the SNS topic"
  type        = string
  default     = "github-backup"
}

variable "python_github_org" {
  description = "Name of the Github user to backup"
  type        = string
}

variable "python_github_output_directory" {
  description = "Path of the output folder for python-github-backup"
  type        = string
  default     = "/tmp/output/"
}

variable "python_github_zip_directory" {
  description = "Path of the output ZIP file for python-github-backup"
  type        = string
  default     = "/tmp/zip/"
}
