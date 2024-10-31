# ==============================================================================
# AMI
# ==============================================================================
data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# ==============================================================================
# EC2 Instance
# ==============================================================================
locals {
  instance_user_data = file("${path.module}/cloud-config.yaml")
}

module "ec2_instance" {
  source = "../aws-private-ec2"

  prefix = var.prefix

  instance_type = var.instance_type
  ami_id        = data.aws_ami.amazon_linux_2023.id

  instance_user_data = local.instance_user_data
  instance_state     = var.instance_state
  instance_key_name  = aws_key_pair.ec2_instance.key_name
  enable_ssh_access  = var.instance_enable_ssh_access

  tags = var.tags
}


# ==============================================================================
# Key Pair
# ==============================================================================
resource "aws_key_pair" "ec2_instance" {
  key_name   = "${var.prefix}-key-pair"
  public_key = var.instance_public_key

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-key-pair"
    }
  )
}

# ==============================================================================
# Permissions
# ==============================================================================
resource "aws_iam_role_policy_attachment" "instance_permissions" {
  role       = module.ec2_instance.ec2_instance_role_name
  policy_arn = aws_iam_policy.instance_permissions.arn
}

resource "aws_iam_policy" "instance_permissions" {
  name        = "${var.prefix}_instance_permissions"
  description = "${var.prefix}_instance_permissions policy"
  policy      = data.aws_iam_policy_document.instance_permissions.json
}

data "aws_iam_policy_document" "instance_permissions" {
  statement {
    sid    = "AllowSSM"
    effect = "Allow"

    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/TUNNEL/*",
    ]
  }
  statement {
    sid    = "AllowECR"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:GetAuthorization",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:ListImages"
    ]
    resources = [
      "*"
    ]
  }
}
