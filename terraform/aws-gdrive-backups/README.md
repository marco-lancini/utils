# AWS GDrive Backups

This module automates the setup of an ECS Task needed to backup a Gdrive folder,
as described in [Automated GDrive Backups with ECS and S3](https://blog.marcolancini.it/2021/blog-gdrive-backups-with-ecs/).

In short, this module can be used to create:
* A dedicated VPC/subnet with an Internet Gateway attached
* An ECS (Fargate SPOT) cluster
* An EFS file system, with a mount target in the subnet used by ECS
* An ECR repository where to store the Docker image for backing up GDrive via rclone (see [rclone GDrive Backup](https://github.com/marco-lancini/utils/tree/main/docker/rclone-gdrive-backup))
* A destination S3 bucket with transition to Glacier after 1 day
* An ECS Task Definition, with execution triggered periodically (`cron`) by a CloudWatch Event Rule, and secrets pulled by Parameter Store
* Notifications:
    * A dedicated SNS Topic
    * A CloudWatch Event Rule to alert on every `RUNNING` and `STOPPED` task
    * An S3 bucket notification to alert on every new object

![](https://blog.marcolancini.it/images/posts/blog_gdrive_backups_architecture.png)
