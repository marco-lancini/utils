# ==============================================================================
# GITHUB
# ==============================================================================
data "tls_certificate" "github" {
  url = var.github_url
}

resource "aws_iam_openid_connect_provider" "github" {
  count = var.allow_github ? 1 : 0

  url = var.github_url
  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = ["${data.tls_certificate.github.certificates.0.sha1_fingerprint}"]
}


# ==============================================================================
# GITLAB
# ==============================================================================
data "tls_certificate" "gitlab" {
  url = var.gitlab_url
}

resource "aws_iam_openid_connect_provider" "gitlab" {
  count = var.allow_gitlab ? 1 : 0

  url = var.gitlab_url

  client_id_list  = [var.gitlab_url]
  thumbprint_list = ["${data.tls_certificate.gitlab.certificates.0.sha1_fingerprint}"]
}
