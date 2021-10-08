# ==============================================================================
# ECS
# ==============================================================================
resource "aws_ecs_cluster" "backups_cluster" {
  name = var.ecs_cluster_name

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
  }

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

# ==============================================================================
# ECS TASK
# ==============================================================================
module "backup_github" {
  source = "umotif-public/ecs-fargate/aws"

  # Main settings
  name_prefix      = var.ecs_task_github
  cluster_id       = aws_ecs_cluster.backups_cluster.id
  platform_version = "LATEST"

  # Performance
  task_definition_cpu    = 512
  task_definition_memory = 2048
  capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE_SPOT",
      weight            = 100
    }
  ]

  # Networking
  vpc_id                          = aws_vpc.backups_vpc.id
  private_subnet_ids              = [aws_subnet.backups_subnet.id]
  task_container_assign_public_ip = true

  create_service         = false
  load_balanced          = false
  desired_count          = 0
  task_container_port    = 0
  health_check           = {}
  enable_execute_command = false

  # Image
  ecr_repository       = aws_ecr_repository.python-github-backup.arn
  task_container_image = "${aws_ecr_repository.python-github-backup.repository_url}:${var.ecr_image_version_github}"

  # Image Parameters
  task_container_command = [
    "github-backup",
    "--repositories", "--private", "--fork", "--all",
    "--output-directory", "${var.python_github_output_directory}",
    "--output-zip", "${var.python_github_zip_directory}",
    "--output-s3", "${aws_s3_bucket.backups_github.id}"
  ]

  # Environment Variables
  task_container_environment = {
    "PY_ORG" : "${var.python_github_org}",
  }

  # Secrets
  task_container_secrets = [
    {
      "name" : "GITHUB_PAT_BACKUP",
      "valueFrom" : "${data.aws_ssm_parameter.backup_github_pat.arn}"
    }
  ]

}

#
# Schedule
#
module "ecs-fargate-scheduled-task" {
  source = "umotif-public/ecs-fargate-scheduled-task/aws"

  name_prefix = "${var.ecs_task_github}-scheduled-task"

  ecs_cluster_arn    = aws_ecs_cluster.backups_cluster.arn
  task_role_arn      = module.backup_github.task_role_arn
  execution_role_arn = module.backup_github.execution_role_arn


  event_target_task_definition_arn = module.backup_github.task_definition_arn
  event_rule_schedule_expression   = "cron(0 10 1 * ? *)" # Every 1st day of the month at 10:00am

  event_target_assign_public_ip = true

  event_target_subnets = [aws_subnet.backups_subnet.id]
  event_target_security_groups = [
    aws_default_security_group.backups_vpc_default.id,
    module.backup_github.service_sg_id,
  ]

}
