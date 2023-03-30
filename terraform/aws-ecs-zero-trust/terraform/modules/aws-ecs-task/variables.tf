# ==============================================================================
# MAIN Settings
# ==============================================================================
variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "platform_version" {
  description = "The platform version on which to run your service. Only applicable for launch_type set to FARGATE."
  default     = "LATEST"
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

# ==============================================================================
# CONTAINERS
# ==============================================================================
variable "container_definitions" {
  description = "JSON map encoded container definition"
  default     = null
}

variable "container_exposed_port" {
  description = "The main port to expose"
  type        = number
  default     = null
}

variable "container_exposed_to_internet" {
  description = "Whether to expose expose_port to the Internet"
  type        = bool
  default     = false
}

# ==============================================================================
# CLOUDWATCH
# ==============================================================================
variable "log_retention_in_days" {
  description = "Number of days the logs will be retained in CloudWatch."
  default     = 30
  type        = number
}

variable "logs_kms_key" {
  type        = string
  description = "The KMS key ARN to use to encrypt container logs."
  default     = ""
}

# ==============================================================================
# NETWORKING
# ==============================================================================
variable "cluster_id" {
  description = "The Amazon Resource Name (ARN) that identifies the cluster."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}

variable "vpc_sg_id" {
  description = "The ID of the VPC default security group"
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}

variable "sg_name_prefix" {
  description = "A prefix used for Security group name."
  type        = string
  default     = ""
}

# ==============================================================================
# PERFORMANCE
# ==============================================================================
variable "task_definition_cpu" {
  description = "Amount of CPU to reserve for the task."
  default     = 256
  type        = number
}

variable "task_definition_memory" {
  description = "The soft limit (in MiB) of memory to reserve for the task."
  default     = 512
  type        = number
}

# ==============================================================================
# IAM
# ==============================================================================
variable "repository_credentials" {
  default     = ""
  description = "name or ARN of a secrets manager secret (arn:aws:secretsmanager:region:aws_account_id:secret:secret_name)"
  type        = string
}

variable "create_repository_credentials_iam_policy" {
  default     = false
  description = "Set to true if you are specifying `repository_credentials` variable, it will attach IAM policy with necessary permissions to task role."
}

variable "repository_credentials_kms_key" {
  default     = "alias/aws/secretsmanager"
  description = "key id, key ARN, alias name or alias ARN of the key that encrypted the repository credentials"
  type        = string
}

variable "enable_execute_command" {
  type        = bool
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service."
  default     = true
}

# ==============================================================================
# TASK CONFIGURATION
# ==============================================================================
variable "task_container_protocol" {
  description = "Protocol that the container exposes."
  default     = "HTTP"
  type        = string
}

variable "volume" {
  description = "(Optional) A set of volume blocks that containers in your task may use. This is a list of maps, where each map should contain \"name\", \"host_path\", \"docker_volume_configuration\" and \"efs_volume_configuration\". Full set of options can be found at https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html"
  default     = []
}

variable "task_definition_ephemeral_storage" {
  description = "The total amount, in GiB, of ephemeral storage to set for the task."
  default     = 0
  type        = number
}

variable "placement_constraints" {
  type        = list(any)
  description = "(Optional) A set of placement constraints rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10. This is a list of maps, where each map should contain \"type\" and \"expression\""
  default     = []
}

variable "proxy_configuration" {
  type        = list(any)
  description = "(Optional) The proxy configuration details for the App Mesh proxy. This is a list of maps, where each map should contain \"container_name\", \"properties\" and \"type\""
  default     = []
}

# ==============================================================================
# SERVICE
# ==============================================================================
variable "create_service" {
  type        = bool
  default     = false
  description = "Whether the task should be managed by a service."
}

variable "desired_count" {
  description = "The number of instances of the task definitions to place and keep running."
  default     = 1
  type        = number
}

variable "task_container_assign_public_ip" {
  description = "Assigned public IP to the container."
  default     = false
  type        = bool
}

variable "propagate_tags" {
  type        = string
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are SERVICE and TASK_DEFINITION."
  default     = "TASK_DEFINITION"
}

variable "capacity_provider_strategy" {
  type        = list(any)
  description = "(Optional) The capacity_provider_strategy configuration block. This is a list of maps, where each map should contain \"capacity_provider \", \"weight\" and \"base\""
  default     = []
}

variable "force_new_deployment" {
  type        = bool
  description = "Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g. myimage:latest), roll Fargate tasks onto a newer platform version."
  default     = false
}

variable "wait_for_steady_state" {
  type        = bool
  description = "If true, Terraform will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing."
  default     = false
}

variable "deployment_minimum_healthy_percent" {
  default     = 50
  description = "The lower limit of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = number
}

variable "deployment_maximum_percent" {
  default     = 200
  description = "The upper limit of the number of running tasks that can be running in a service during a deployment"
  type        = number
}

variable "health_check_grace_period_seconds" {
  default     = 300
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200. Only valid for services configured to use load balancers."
  type        = number
}

variable "deployment_controller_type" {
  default     = "ECS"
  type        = string
  description = "Type of deployment controller. Valid values: CODE_DEPLOY, ECS, EXTERNAL. Default: ECS."
}

variable "service_registry_arn" {
  default     = ""
  description = "ARN of aws_service_discovery_service resource"
  type        = string
}

# ==============================================================================
# LOAD BALANCER
# ==============================================================================
variable "load_balanced" {
  type        = bool
  default     = true
  description = "Whether the task should be loadbalanced."
}

variable "target_groups" {
  type        = any
  default     = []
  description = "The name of the target groups to associate with ecs service"
}

variable "alb_enable_http" {
  description = "Whether to allow HTTP Ingress to the ALB"
  default     = false
}

variable "alb_enable_https" {
  description = "Whether to allow HTTPS Ingress to the ALB"
  default     = false
}

variable "health_check" {
  description = "A health block containing health check settings for the target group. Overrides the defaults."
  type        = map(string)
  default     = {}
}
