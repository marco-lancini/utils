# ==============================================================================
# BUCKETS
# ==============================================================================
resource "aws_s3_bucket" "backups_github" {
  bucket        = var.s3_backups_github
  force_destroy = true

  lifecycle_rule {
    id      = "${var.s3_backups_github}-glacier"
    enabled = true

    transition {
      days          = 1
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }

    abort_incomplete_multipart_upload_days = 30
  }

}

resource "aws_s3_bucket_public_access_block" "backups_github_block" {
  bucket = aws_s3_bucket.backups_github.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Grant access to the task
resource "aws_iam_role_policy" "backup_github_access_s3" {
  name   = "${var.ecs_task_github}-access-s3"
  role   = module.backup_github.task_role_id
  policy = data.aws_iam_policy_document.backup_github_access_s3.json
}

data "aws_iam_policy_document" "backup_github_access_s3" {
  statement {
    sid    = "AllowECSRunTask"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [
      "${aws_s3_bucket.backups_github.arn}",
      "${aws_s3_bucket.backups_github.arn}/*",
    ]
  }
}

# Notifications
resource "aws_s3_bucket_notification" "backup_github_notification" {
  bucket = aws_s3_bucket.backups_github.id

  topic {
    topic_arn = aws_sns_topic.backups_github.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

# ==============================================================================
# ECR
# ==============================================================================
resource "aws_ecr_repository" "python-github-backup" {
  name                 = var.ecr_backups_github
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "python-github-backup" {
  repository = aws_ecr_repository.python-github-backup.name

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
# SECRET
# ==============================================================================
# Secret is created manually
data "aws_ssm_parameter" "backup_github_pat" {
  name = "GITHUB_PAT_BACKUP"
}

# Grant access to the task
resource "aws_iam_role_policy" "backup_github_access_ssm" {
  name   = "${var.ecs_task_github}-access-ssm"
  role   = module.backup_github.execution_role_id
  policy = data.aws_iam_policy_document.backup_github_access_ssm.json
}

data "aws_iam_policy_document" "backup_github_access_ssm" {
  statement {
    sid    = "AllowECSRunTask"
    effect = "Allow"

    actions = ["ssm:GetParameters"]

    resources = [
      "${data.aws_ssm_parameter.backup_github_pat.arn}"
    ]
  }
}

# ==============================================================================
# SNS NOTIFICATIONS
# ==============================================================================
# SNS
resource "aws_sns_topic" "backups_github" {
  name = var.sns_backups_github
}

# Event Rule
resource "aws_cloudwatch_event_rule" "backups_github" {
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

resource "aws_cloudwatch_event_target" "backups_github" {
  rule      = aws_cloudwatch_event_rule.backups_github.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.backups_github.arn
}

# Policy
resource "aws_sns_topic_policy" "backups_github" {
  arn    = aws_sns_topic.backups_github.arn
  policy = data.aws_iam_policy_document.sns_backups_github_policy.json
}

data "aws_iam_policy_document" "sns_backups_github_policy" {
  statement {
    sid     = "1"
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.backups_github.arn]
  }

  statement {
    sid     = "2"
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [aws_sns_topic.backups_github.arn]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        "${aws_s3_bucket.backups_github.arn}",
      ]
    }
  }
}
