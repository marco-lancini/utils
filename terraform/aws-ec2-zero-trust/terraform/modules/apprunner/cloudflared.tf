# ==============================================================================
# ECR
# ==============================================================================
resource "aws_ecr_repository" "cloudflared" {
  name = "cloudflared"

  image_tag_mutability = "MUTABLE"
  force_delete         = true

  tags = var.tags
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
