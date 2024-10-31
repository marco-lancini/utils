output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2_instance.ec2_instance_id
}

output "ec2_instance_public_dns" {
  description = "The public DNS of the EC2 instance"
  value       = module.ec2_instance.ec2_instance_public_dns
}
