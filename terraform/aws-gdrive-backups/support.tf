# ==============================================================================
# BUCKETS
# ==============================================================================
resource "aws_s3_bucket" "backups_gdrive" {
  bucket        = var.s3_backups_gdrive
  force_destroy = true

  lifecycle_rule {
    id      = "${var.s3_backups_gdrive}-glacier"
    enabled = true

    transition {
      days          = 1
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }

    abort_incomplete_multipart_upload_days = 30
  }

}

resource "aws_s3_bucket_public_access_block" "backups_gdrive_block" {
  bucket   = aws_s3_bucket.backups_gdrive.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Grant access to the task
resource "aws_iam_role_policy" "backup_gdrive_access_s3" {
  name     = "${var.ecs_task_gdrive}-access-s3"
  role     = module.backup_gdrive.task_role_id
  policy   = data.aws_iam_policy_document.backup_gdrive_access_s3.json
}

data "aws_iam_policy_document" "backup_gdrive_access_s3" {
  statement {
    sid    = "AllowECSRunTask"
    effect = "Allow"

    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:ListMultipartUploadParts",
      "s3:ListMultipartUploads",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      "${aws_s3_bucket.backups_gdrive.arn}",
      "${aws_s3_bucket.backups_gdrive.arn}/*",
    ]
  }
}

# Notifications
resource "aws_s3_bucket_notification" "backup_gdrive_notification" {
  bucket   = aws_s3_bucket.backups_gdrive.id

  topic {
    topic_arn = aws_sns_topic.backups_notifications.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

# ==============================================================================
# ECR
# ==============================================================================
resource "aws_ecr_repository" "rclone-gdrive-backup" {
  name                 = var.ecr_backups_gdrive
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "rclone-gdrive-backup" {
  repository = aws_ecr_repository.rclone-gdrive-backup.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 1 days",
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

