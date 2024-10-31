# ==============================================================================
# EC2
# ==============================================================================
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2.id
}

output "ec2_instance_public_dns" {
  description = "The public DNS of the EC2 instance"
  value       = aws_instance.ec2.public_dns
}

output "ec2_instance_role_name" {
  description = "The IAM role of the EC2 instance"
  value       = aws_iam_role.instance_role.name
}
