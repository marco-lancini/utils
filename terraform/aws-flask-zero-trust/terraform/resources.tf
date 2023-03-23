# ==============================================================================
# ECR
# ==============================================================================
#
# Cloudflared
#
resource "aws_ecr_repository" "cloudflared" {
  #checkov:skip=CKV_AWS_33:Ensure ECR image scanning on push is enabled
  #checkov:skip=CKV_AWS_51:Ensure ECR Image Tags are immutable
  name                 = local.ecr_cloudflared_name
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
  name                 = local.ecr_flask_name
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
