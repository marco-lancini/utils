# AppRunner

AppRunner is a long-lived EC2 instance used to run apps via docker-compose.

This module creates:

- An EC2 instance (`aws-private-ec2` module) based on an Amazon Linux 2023 AMI, and `instance_user_data` specified in `cloud-config.yaml`
- An ECR repository for hosting the `cloudflared` Docker image
- One Cloudflare Access Application for each app specified
