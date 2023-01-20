## Terraform Modules

This folder contains the relevant sources needed by a few custom Terraform modules.


## Modules

| Module                                                          | Description                                                                                                                                                                                      |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [aws-gdrive-backups](aws-gdrive-backups/)                       | Automates the setup of an ECS Task needed to backup a GDrive folder, as described in [Automated GDrive Backups with ECS and S3](https://www.marcolancini.it/2021/blog-gdrive-backups-with-ecs/)  |
| [aws-github-backups](aws-github-backups/)                       | Automates the setup of an ECS Task needed to backup a Github account, as described in [Automated Github Backups with ECS and S3](https://www.marcolancini.it/2021/blog-github-backups-with-ecs/) |
| [aws-oidc-ci](aws-oidc-ci/)                                     | Automates the setup of OIDC federation between AWS and Github Actions/Gitlab CI                                                                                                                  |
| [aws-security-reviewer](aws-security-reviewer/)                 | Setup roles and users needed to perform a security audit of AWS accounts, as described in [Cross Account Auditing in AWS and GCP](https://www.marcolancini.it/2019/blog-cross-account-auditing/) |
| [cloudflare-gateway-adblocking](cloudflare-gateway-adblocking/) | Mimic the Pi-hole's behaviour using only serverless technologies (Cloudflare Gateway, to be precise),                                                                                            |
as described in [Serverless Ad Blocking with Cloudflare Gateway](https://blog.marcolancini.it/2022/blog-serverless-ad-blocking-with-cloudflare-gateway/)
| [digitalocean-algovpn](digitalocean-algovpn/)   | DigitalOcean droplet hosting an Algo VPN server                                                                                                                                                  |
