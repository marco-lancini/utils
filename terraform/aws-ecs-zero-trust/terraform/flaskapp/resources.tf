# ==============================================================================
# SECRETS
# ==============================================================================
resource "aws_ssm_parameter" "tunnel_credentials" {
  name        = var.parameter_credentials_name
  description = "${var.tunnel_name} Cloudflared Tunnel: credentials JSON"
  type        = "SecureString"

  value = <<EOF
{
  "AccountTag": "${var.cloudflare_account_id}",
  "TunnelSecret": "${cloudflare_tunnel.flask.secret}",
  "TunnelID": "${cloudflare_tunnel.flask.id}"
}
EOF

}


# ==============================================================================
# ECS Cluster
# ==============================================================================
module "flask_cluster" {
  source = "../modules/aws-ecs-cluster"

  cluster_name = var.ecs_cluster_name
}


# ==============================================================================
# ECR
# ==============================================================================
# Cloudflared
resource "aws_ecr_repository" "cloudflared" {
  name                 = var.ecr_cloudflared_name
  image_tag_mutability = "MUTABLE"
}


# Flask Server
resource "aws_ecr_repository" "flask" {
  name                 = var.ecr_flask_name
  image_tag_mutability = "MUTABLE"
}
