# Python Github Backup

Docker image for a customised version of the [python-github-backup](https://github.com/josegonzalez/python-github-backup) repo, as described in [Automated Github Backups with ECS and S3](https://www.marcolancini.it/2021/blog-github-backups-with-ecs/).

In particular, the following has been added:
* Fetch the Github PAT and target user from environment variables
* The data fetched from Github is zipped and uploaded to an S3 bucket
