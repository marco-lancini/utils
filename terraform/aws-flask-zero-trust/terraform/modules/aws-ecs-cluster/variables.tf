variable "cluster_name" {
  description = "The name of the ECS cluster"
}

variable "endpoints_gateway_list" {
  description = "A list of VPC Gateway Endpoints to create"
  type        = list(string)
  default     = ["s3", "dynamodb"]
}

variable "endpoints_interface_list" {
  description = "A list of VPC Gateway Endpoints to create (minimum required: ssm, ecr.api, ecr.dkr, logs)"
  type        = list(string)
  default     = []
}
