output "tunnel_secret_ssm_name" {
  description = "The name of the SSM parameter containing the Cloudflare Zero Trust App tunnel secret"
  value       = aws_ssm_parameter.main.name
}

output "tunnel_secret_ssm_arn" {
  description = "The ARN of the SSM parameter containing the Cloudflare Zero Trust App tunnel secret"
  value       = aws_ssm_parameter.main.arn
}
