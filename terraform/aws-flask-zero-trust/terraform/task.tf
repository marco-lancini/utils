# ==============================================================================
# Container Definitions
# ==============================================================================
#
# Cloudflared
#
module "container_cloudflared" {
  source = "modules/aws-ecs-container"

  container_name  = local.container_cloudflared_name
  container_image = "${aws_ecr_repository.cloudflared.repository_url}:latest"

  essential        = true
  container_cpu    = 256 # 0.25 vCPU
  container_memory = 512 # 512 MB

  secrets = [
    {
      name      = "TUNNEL_CREDENTIALS"
      valueFrom = aws_ssm_parameter.tunnel_credentials.arn
    },
  ]

  environment = [
    {
      name  = "ORIGIN_URL"
      value = local.tunnel_origin
    },
    {
      name  = "TUNNEL_UUID"
      value = cloudflare_tunnel.flask.id
    },
  ]

  container_depends_on = [
    {
      containerName = local.container_flask_name
      condition     = "START"
    }
  ]
}

#
# Flask Server
#
module "container_flask" {
  source = "modules/aws-ecs-container"

  container_name  = local.container_flask_name
  container_image = "${aws_ecr_repository.flask.repository_url}:latest"

  essential = true
  port_mappings = [
    {
      containerPort = 5000
      hostPort      = 5000
      protocol      = "tcp"
    }
  ]

}


# ==============================================================================
# ECS Task
# ==============================================================================
module "task" {
  source = "modules/aws-ecs-task"

  # Main settings
  name_prefix      = local.name
  platform_version = "LATEST"

  # CloudWatch
  log_retention_in_days = 1

  # Networking
  cluster_id = module.flask_cluster.cluster_id
  vpc_id     = module.flask_cluster.vpc_id
  vpc_sg_id  = module.flask_cluster.sg_id
  private_subnet_ids = [
    module.flask_cluster.subnet_id,
    module.flask_cluster.secondary_subnet_id
  ]

  # Performance
  task_definition_cpu    = 512  # 0.5 vCPU
  task_definition_memory = 1024 # 1 GB

  # Service
  create_service                  = true
  desired_count                   = 1
  task_container_assign_public_ip = true
  force_new_deployment            = false
  enable_execute_command          = false
  capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE_SPOT",
      weight            = 100
    }
  ]

  # Only for load balanced
  load_balanced = false

  # Containers
  container_exposed_port        = local.tunnel_port
  container_exposed_to_internet = false
  task_container_protocol       = "HTTP"

  container_definitions = [
    module.container_cloudflared.json_map_object,
    module.container_flask.json_map_object,
  ]
}


# ==============================================================================
# TASK PERMISSIONS
# ==============================================================================
#
# Grant access to the SSM parameters
#
resource "aws_iam_role_policy" "access_ssm" {
  name   = "flask-access-ssm"
  role   = module.task.execution_role_name
  policy = data.aws_iam_policy_document.access_ssm.json
}

data "aws_iam_policy_document" "access_ssm" {
  statement {
    sid    = "AllowECSRunTask"
    effect = "Allow"

    actions = [
      "ssm:GetParameters",
    ]

    resources = [
      aws_ssm_parameter.tunnel_credentials.arn,
    ]
  }
}
