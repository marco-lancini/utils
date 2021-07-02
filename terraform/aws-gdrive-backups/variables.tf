variable "ecs_cluster_name" {
  description = "Name of the ECS Cluster"
  default     = "backup-tasks-ecs-cluster"
}

variable "s3_backups_gdrive" {
  description = "Name of the S3 bucket where to store output"
  type        = string
}

variable "ecr_backups_gdrive" {
  description = "Name of the ECR repo hosting the Docker image"
  type        = string
  default     = "rclone-gdrive-backup"
}

variable "ecr_image_version_gdrive" {
  description = "Version of the Docker image"
  type        = string
  default     = "latest"
}

variable "ecs_task_gdrive" {
  description = "Name of the ECS task"
  type        = string
  default     = "gdrive-backup"
}

variable "sns_backups_gdrive" {
  description = "Name of the SNS topic"
  type        = string
  default     = "gdrive-backup"
}

variable "efs_backups_gdrive" {
  description = "Name of the EFS file system"
  type        = string
}

variable "availability_zone_name" {
  description = "Name of the AZ for the EFS file system"
  type        = string
}
