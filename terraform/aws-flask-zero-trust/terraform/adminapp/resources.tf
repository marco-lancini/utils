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
#
# Cloudflared
#
resource "aws_ecr_repository" "cloudflared" {
  #checkov:skip=CKV_AWS_33:Ensure ECR image scanning on push is enabled
  #checkov:skip=CKV_AWS_51:Ensure ECR Image Tags are immutable
  name                 = var.ecr_cloudflared_name
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "cloudflared" {
  repository = aws_ecr_repository.cloudflared.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire untagged images older than 1 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

#
# Flask Server
#
resource "aws_ecr_repository" "flask" {
  #checkov:skip=CKV_AWS_33:Ensure ECR image scanning on push is enabled
  #checkov:skip=CKV_AWS_51:Ensure ECR Image Tags are immutable
  name                 = var.ecr_flask_name
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "flask" {
  repository = aws_ecr_repository.flask.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire untagged images older than 1 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
