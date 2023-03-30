# ==============================================================================
# Security group (container)
# ==============================================================================
resource "aws_security_group" "ecs_service" {
  vpc_id      = var.vpc_id
  name_prefix = var.sg_name_prefix == "" ? "${var.name_prefix}-ecs-service-sg-" : "${var.sg_name_prefix}-"
  description = "Fargate service security group"
  tags = merge(
    var.tags,
    {
      Name = var.sg_name_prefix == "" ? "${var.name_prefix}-ecs-service-sg" : var.sg_name_prefix
    },
  )

  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }
}

# ==============================================================================
# Security group rules
# ==============================================================================
#
# Egress
#
resource "aws_security_group_rule" "egress_service" {
  security_group_id = aws_security_group.ecs_service.id
  description       = "Fargate service security group - allow egress"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

#
# ALB: Need to allow traffic from ALB to container port
#
resource "aws_security_group_rule" "alb_to_exposed_port" {
  count             = var.load_balanced ? 1 : 0
  security_group_id = aws_security_group.ecs_service.id

  description = "${var.name_prefix} - Allow traffic from ALB to container port ${var.container_exposed_port}"

  type     = "ingress"
  protocol = "tcp"

  from_port = var.container_exposed_port
  to_port   = var.container_exposed_port

  source_security_group_id = module.aws_lb[0].security_group_id
}

#
# Allow direct traffic if no Load Balancer and publicly exposed
#
resource "aws_security_group_rule" "task_ingress" {
  # Create only if:
  #   - load balancing is disabled
  #   - assign public IP is enabled
  #   - container_exposed_port != 0 && container_exposed_to_internet = true
  count = (var.load_balanced != true) && (var.task_container_assign_public_ip == true) && (var.container_exposed_port != 0 && var.container_exposed_to_internet == true) ? 1 : 0

  description = "${var.name_prefix} - Allow ingress traffic to container port ${var.container_exposed_port}"

  security_group_id = aws_security_group.ecs_service.id
  type              = "ingress"
  protocol          = "tcp"

  from_port = var.container_exposed_port
  to_port   = var.container_exposed_port

  # TODO: Variable?
  cidr_blocks = ["0.0.0.0/0"]
}
