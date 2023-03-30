# ==============================================================================
# SECURITY GROUPS
# ==============================================================================
#
# Main
#
resource "aws_security_group" "main" {
  count = var.load_balancer_type == "network" ? 0 : 1

  name_prefix = "${var.name_prefix}-sg-"
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name_prefix}-sg"
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

#
# Egress
#
resource "aws_security_group_rule" "egress" {
  count             = var.load_balancer_type == "network" ? 0 : 1
  security_group_id = aws_security_group.main[0].id

  description = "${var.name_prefix} - ALB - Allow Egress"

  type             = "egress"
  protocol         = "-1"
  from_port        = 0
  to_port          = 0
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

#
# Ingress 443
#
resource "aws_security_group_rule" "ingress_443" {
  count             = var.load_balancer_type == "application" && var.enable_https ? 1 : 0
  security_group_id = aws_security_group.main[0].id

  description = "${var.name_prefix} - ALB - Ingress 443"

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = var.cidr_blocks
}

#
# Ingress - 80
#
resource "aws_security_group_rule" "ingress_80" {
  count             = var.load_balancer_type == "application" && var.enable_http ? 1 : 0
  security_group_id = aws_security_group.main[0].id

  description = "${var.name_prefix} - ALB - Ingress 80"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = var.cidr_blocks
}

#
# Ingress - Redirect 80 to 443
#
resource "aws_security_group_rule" "allow_port_80_ingress_for_http_to_https_redirect" {
  count             = var.load_balancer_type == "application" && var.enable_http_to_https_redirect ? 1 : 0
  security_group_id = aws_security_group.main[0].id

  description = "${var.name_prefix} - ALB - Redirect Ingress 80 to 443"

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = var.cidr_blocks
}
