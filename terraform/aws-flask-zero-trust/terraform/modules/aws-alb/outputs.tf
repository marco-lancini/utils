output "arn" {
  description = "The ARN of the load balancer."
  value       = aws_lb.main.arn
}

output "name" {
  description = "The name of the load balancer."
  value       = element(split("/", aws_lb.main.name), 2)
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.main.dns_name
}

output "zone_id" {
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
  value       = aws_lb.main.zone_id
}

output "origin_id" {
  description = "First part of the DNS name of the load balancer."
  value       = element(split(".", aws_lb.main.dns_name), 0)
}

output "security_group_id" {
  description = "The ID of the security group."
  value       = concat(aws_security_group.main[*].id, [""])[0]
}

output "arn_suffix" {
  description = "The ARN suffix for use with CloudWatch Metrics."
  value       = aws_lb.main.arn_suffix
}
