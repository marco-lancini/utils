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
  bucket = aws_s3_bucket.backups_gdrive.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Grant access to the task
resource "aws_iam_role_policy" "backup_gdrive_access_s3" {
  name   = "${var.ecs_task_gdrive}-access-s3"
  role   = module.backup_gdrive.task_role_id
  policy = data.aws_iam_policy_document.backup_gdrive_access_s3.json
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
  bucket = aws_s3_bucket.backups_gdrive.id

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

# ==============================================================================
# EFS
# ==============================================================================
resource "aws_efs_file_system" "backup_gdrive" {
  creation_token         = var.efs_backups_gdrive
  availability_zone_name = var.availability_zone_name

  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"
  }

  tags = {
    Name = var.efs_backups_gdrive
  }
}

resource "aws_efs_mount_target" "backup_gdrive" {
  file_system_id = aws_efs_file_system.backup_gdrive.id
  subnet_id      = aws_subnet.backups_subnet.id
  security_groups = [
    aws_default_security_group.backups_vpc_default.id,
    module.backup_gdrive.service_sg_id
  ]
}

# ==============================================================================
# SECRETS
# ==============================================================================
# Secrets are created manually
data "aws_ssm_parameter" "gdrive_rclone_config" {
  name = "GDRIVE_RCLONE_CONFIG"
}

# Grant access to the task
resource "aws_iam_role_policy" "backup_gdrive_access_ssm" {
  name   = "${var.ecs_task_gdrive}-access-ssm"
  role   = module.backup_gdrive.execution_role_id
  policy = data.aws_iam_policy_document.backup_gdrive_access_ssm.json
}

data "aws_iam_policy_document" "backup_gdrive_access_ssm" {
  statement {
    sid    = "AllowECSRunTask"
    effect = "Allow"

    actions = ["ssm:GetParameters"]

    resources = [
      "${data.aws_ssm_parameter.gdrive_rclone_config.arn}",
    ]
  }
}

# ==============================================================================
# SNS NOTIFICATIONS
# ==============================================================================
#
# SNS
#
resource "aws_sns_topic" "backups_notifications" {
  name = var.sns_backups_gdrive
}

#
# Event Rule - Notify on ECS Task Events
#
resource "aws_cloudwatch_event_rule" "backups_ecs_tasks" {
  name        = "${var.ecs_task_github}-status"
  description = "Notify on ECS Task Events"

  event_pattern = <<EOF
{
   "source":[
      "aws.ecs"
   ],
   "detail-type":[
      "ECS Task State Change"
   ],
   "detail":{
      "lastStatus":[
         "RUNNING",
         "STOPPED"
      ]
   }
}
EOF
}

resource "aws_cloudwatch_event_target" "backups_ecs_tasks" {
  rule      = aws_cloudwatch_event_rule.backups_ecs_tasks.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.backups_notifications.arn
}

#
# Policy - Notify on S3 Object Creation
#
resource "aws_sns_topic_policy" "backups_notifications" {
  arn    = aws_sns_topic.backups_notifications.arn
  policy = data.aws_iam_policy_document.sns_backups_notifications_policy.json
}

data "aws_iam_policy_document" "sns_backups_notifications_policy" {
  statement {
    sid     = "1"
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.backups_notifications.arn]
  }

  statement {
    sid     = "2"
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [aws_sns_topic.backups_notifications.arn]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        "${aws_s3_bucket.backups_gdrive.arn}",
      ]
    }
  }
}
