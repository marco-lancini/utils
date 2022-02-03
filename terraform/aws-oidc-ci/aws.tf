# ==============================================================================
# Create a dedicated role
# ==============================================================================
resource "aws_iam_role" "ci_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.allow_ci.json
}

# ==============================================================================
# Configure permissions for the role
# ==============================================================================
resource "aws_iam_role_policy_attachment" "github_admin" {
  count = var.grant_admin_permissions ? 1 : 0

  role       = aws_iam_role.ci_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "github_backup" {
  count = var.grant_admin_permissions ? 1 : 0

  role       = aws_iam_role.ci_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSBackupFullAccess"
}

# ==============================================================================
# Configure an assume-role policy
# ==============================================================================
data "aws_iam_policy_document" "allow_ci" {
  # Allow access to Github
  dynamic "statement" {
    for_each = var.allow_github ? [1] : []

    content {
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]
      principals {
        type        = "Federated"
        identifiers = [aws_iam_openid_connect_provider.github[0].arn]
      }
      condition {
        test     = "StringLike"
        variable = "${aws_iam_openid_connect_provider.github[0].url}:sub"
        values   = [for repo in var.github_repos : "repo:${var.github_org}/${repo}"]
      }
    }
  }

  # Allow access to Gitlab
  dynamic "statement" {
    for_each = var.allow_gitlab ? [1] : []

    content {
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]
      principals {
        type        = "Federated"
        identifiers = [aws_iam_openid_connect_provider.gitlab[0].arn]
      }
      condition {
        test     = "StringEquals"
        variable = "${aws_iam_openid_connect_provider.gitlab[0].url}:sub"
        values   = [for repo in var.gitlab_repos : "${repo}"]
      }
    }
  }
}
