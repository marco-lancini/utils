# ==============================================================================
# ECS
# ==============================================================================
output "cluster_name" {
  description = "The Name of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.id
}

output "cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.arn
}


# ==============================================================================
# NETWORKING
# ==============================================================================
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "subnet_id" {
  description = "The ID of the main Subnet of the VPC"
  value       = aws_subnet.subnet.id
}

output "secondary_subnet_id" {
  description = "The ID of the secondary Subnet of the VPC"
  value       = aws_subnet.secondary_subnet.id
}

output "sg_id" {
  description = "The ID of the default Security Group of the VPC"
  value       = aws_default_security_group.vpc_default_sg.id
}
