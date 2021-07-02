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
module "backup_gdrive" {
  source = "umotif-public/ecs-fargate/aws"

  # Main settings
  name_prefix      = var.ecs_task_gdrive
  cluster_id       = aws_ecs_cluster.backups_cluster.id
  platform_version = "LATEST"

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
  create_service                  = false
  load_balanced                   = false

  # Image
  ecr_repository         = aws_ecr_repository.rclone-gdrive-backup.arn
  task_container_image   = "${aws_ecr_repository.rclone-gdrive-backup.repository_url}:${local.ecr_image_version_gdrive}"
  task_definition_cpu    = 512
  task_definition_memory = 2048

  # Image Parameters
  task_container_command = [
    "/src/rclone-run.sh",
  ]

  # Environment Variables
  task_container_environment = {
    "OUTPUT_S3" : "${aws_s3_bucket.backups_gdrive.id}"
  }

  # Secrets
  task_container_secrets = [
    {
      "name" : "GDRIVE_RCLONE_CONFIG",
      "valueFrom" : "${data.aws_ssm_parameter.gdrive_rclone_config.arn}"
    },
  ]

  # EFS
  task_mount_points = [
    {
      "sourceVolume"  = var.efs_backups_gdrive,
      "containerPath" = "/tmp/efs",
      "readOnly"      = false
    }
  ]

  volume = [
    {
      name = var.efs_backups_gdrive,
      efs_volume_configuration = [
        {
          "file_system_id" : aws_efs_file_system.backup_gdrive.id,
        }
      ]
    }
  ]

}

module "ecs-fargate-scheduled-task-gdrive" {
  source = "umotif-public/ecs-fargate-scheduled-task/aws"

  name_prefix = "${local.ecs_task_gdrive}-scheduled-task"

  ecs_cluster_arn    = aws_ecs_cluster.backups_cluster.arn
  task_role_arn      = module.backup_gdrive.task_role_arn
  execution_role_arn = module.backup_gdrive.execution_role_arn

  event_target_task_definition_arn = module.backup_gdrive.task_definition_arn
  event_rule_schedule_expression   = "cron(0 9 1 * ? *)" # Every 1st day of the month at 09:00am

  event_target_subnets          = [aws_subnet.backups_subnet.id]
  event_target_assign_public_ip = true
  event_target_security_groups = [
    aws_default_security_group.backups_vpc_default.id,
    module.backup_gdrive.service_sg_id,
  ]

}
