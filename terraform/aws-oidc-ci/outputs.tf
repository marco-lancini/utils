output "role_name" {
  description = "The name of the dedicated role created"
  value       = aws_iam_role.ci_role.name
}
