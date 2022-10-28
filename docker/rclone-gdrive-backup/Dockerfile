FROM ubuntu:20.04

LABEL org.opencontainers.image.source = "https://github.com/marco-lancini/utils"

RUN apt-get update && apt-get install -y curl unzip zip
# I know, I know...
RUN curl https://rclone.org/install.sh | bash

WORKDIR /src
COPY docker/rclone-gdrive-backup/rclone-run.sh /src
