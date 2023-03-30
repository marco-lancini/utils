locals {
  #
  # LOGGING
  #
  log_config = {
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "${aws_cloudwatch_log_group.main.name}"
        awslogs-region        = "${data.aws_region.current.name}"
        awslogs-stream-prefix = "container"
      }
    }
  }

  #
  # Containers
  #
  # Merge with log definition
  containers = [
    for c in var.container_definitions : merge(c, local.log_config)
  ]
  # JSON-Encode
  complete_containers = jsonencode(local.containers)

}
