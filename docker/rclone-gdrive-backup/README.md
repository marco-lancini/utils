# rclone GDrive Backup

Docker image for backing up GDrive via rclone, as described in [Automated GDrive Backups with ECS and S3](https://www.marcolancini.it/2021/blog-gdrive-backups-with-ecs/).


## rclone-run

The script can be used to backup a GDrive folder:

```bash
export GDRIVE_RCLONE_CONFIG=<...>
export OUTPUT_S3=<...>

rclone-run.sh
```
