# AWS Github Backups

This module automates the setup of an ECS Task needed to backup a Github account,
as described in [Automated Github Backups with ECS and S3](https://blog.marcolancini.it/2021/blog-github-backups-with-ecs/).

In short, this module can be used to create:
* A dedicated VPC/subnet with an Internet Gateway attached
* An ECS (Fargate SPOT) cluster
* An ECR repository where to store the Docker image of a customised `python-github-backup` script (see [Python Github Backup](https://github.com/marco-lancini/utils/tree/main/docker/python-github-backup))
* A destination S3 bucket with transition to Glacier after 1 day
* An ECS Task Definition, with execution triggered periodically (`cron`) by a CloudWatch Event Rule, and secrets pulled by Parameter Store
* Notifications:
    * A dedicated SNS Topic
    * A CloudWatch Event Rule to alert on every `RUNNING` and `STOPPED` task
    * An S3 bucket notification to alert on every new object

![](https://blog.marcolancini.it/images/posts/blog_github_backups_architecture.png)
