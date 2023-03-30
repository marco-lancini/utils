# ==============================================================================
# Load Balancer
# ==============================================================================
#
# ALB
#
module "aws_lb" {
  count = var.load_balanced ? 1 : 0

  source = "../aws-alb"

  name_prefix        = var.name_prefix
  load_balancer_type = "application"
  internal           = false
  vpc_id             = var.vpc_id
  subnets            = var.private_subnet_ids

  enable_http  = var.alb_enable_http
  enable_https = var.alb_enable_https
}

#
# ALB Listener
#
resource "aws_lb_listener" "listener_target_groups" {
  for_each = var.load_balanced ? { for tg in var.target_groups : tg.target_group_name => tg } : {}

  load_balancer_arn = module.aws_lb[0].arn
  protocol          = "HTTP"

  # TODO: Variable?
  port = "80"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.task[each.key].arn
  }
}


# ==============================================================================
# Load Balancer Target group
# ==============================================================================
resource "aws_lb_target_group" "task" {
  for_each = var.load_balanced ? { for tg in var.target_groups : tg.target_group_name => tg } : {}

  name                 = lookup(each.value, "target_group_name")
  vpc_id               = var.vpc_id
  protocol             = var.task_container_protocol
  port                 = lookup(each.value, "container_port", var.container_exposed_port)
  deregistration_delay = lookup(each.value, "deregistration_delay", null)
  target_type          = "ip"


  dynamic "health_check" {
    for_each = [var.health_check]
    content {
      enabled             = lookup(health_check.value, "enabled", false)
      interval            = lookup(health_check.value, "interval", 30)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", "traffic-port")
      protocol            = lookup(health_check.value, "protocol", null)
      timeout             = lookup(health_check.value, "timeout", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", 3)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      matcher             = lookup(health_check.value, "matcher", null)
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name = lookup(each.value, "target_group_name")
    },
  )
}
