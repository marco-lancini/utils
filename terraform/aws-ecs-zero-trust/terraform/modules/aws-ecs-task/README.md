# ECS Fargate Task

Terraform module to create [AWS ECS FARGATE](https://aws.amazon.com/fargate/) services.

Originally started from [terraform-aws-ecs-fargate](https://github.com/umotif-public/terraform-aws-ecs-fargate),
but forked off from `v.6.4.2` since upstream didn't support sidecar containers.


## How to enable Load Balancing

```hcl
# Only for load balanced
load_balanced = true

alb_enable_http  = false
alb_enable_https = false

target_groups = [
    {
        target_group_name = "efs-example"
        container_port    = 5000
    }
]
health_check = {
    port = "traffic-port"
    path = "/hello"
}
```
