# ==============================================================================
# role_security_audit: in each Spoke account
# ==============================================================================
resource "aws_iam_role" "role_security_audit" {
  name                 = var.role_audit_name
  max_session_duration = var.max_session_duration

  # Allow the role_security_assume role (that we will create in the Hub account)
  # to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "AWS" : "arn:aws:iam::${var.hub_account_id}:role/${var.role_assume_name}"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "security_audit" {
  role       = aws_iam_role.role_security_audit.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

# ==============================================================================
# role_assume_name: in the Hub, able to assume roles in each Spoke
# ==============================================================================
resource "aws_iam_role" "role_security_assume" {
  # If is_hub = true, then deploy also the assume role
  count = var.is_hub ? 1 : 0

  name                 = var.role_assume_name
  max_session_duration = var.max_session_duration

  # Allow security_user_name to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "AWS" : "arn:aws:iam::${var.hub_account_id}:user/${var.security_user_name}"
        }
      },
    ]
  })

}

# Allow this role to assume the role_security_audit role in every Spoke account
resource "aws_iam_policy" "policy_assume_audit" {
  count = var.is_hub ? 1 : 0
  name  = "policy_assume_audit"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sts:AssumeRole"]
        Effect   = "Allow"
        Resource = "arn:aws:iam::*:role/role-security-audit"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_assume_audit" {
  count      = var.is_hub ? 1 : 0
  role       = aws_iam_role.role_security_assume[count.index].name
  policy_arn = aws_iam_policy.policy_assume_audit[count.index].arn
}

# Grant the permission to describe EC2 regions
resource "aws_iam_policy" "policy_describe_regions" {
  count = var.is_hub ? 1 : 0
  name  = "policy_describe_regions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ec2:DescribeRegions"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_describe_regions" {
  count      = var.is_hub ? 1 : 0
  role       = aws_iam_role.role_security_assume[count.index].name
  policy_arn = aws_iam_policy.policy_describe_regions[count.index].arn
}

# ==============================================================================
# security_user_name: in the Hub, able to assume role_security_assume in Hub
# ==============================================================================
resource "aws_iam_user" "security_user" {
  count = var.is_hub ? 1 : 0
  name  = var.security_user_name
}

resource "aws_iam_user_policy" "security_user_assume" {
  #checkov:skip=CKV_AWS_40:Ensure IAM policies are attached only to groups or roles
  count = var.is_hub ? 1 : 0
  name  = "security_user_assume"
  user  = aws_iam_user.security_user[count.index].name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:iam::${var.hub_account_id}:role/${var.role_assume_name}"
    }
  ]
}
EOF
}
