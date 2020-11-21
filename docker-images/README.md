## Custom Docker Images

This folder contains the relevant sources (e.g., `Dockerfiles`, etc.) needed to
build a few custom Docker images.

All these images are pushed to [Github Container Registry](https://github.com/marco-lancini?tab=packages).


## Images

| Image                                       | Description                                            | Pull                                          |
| ------------------------------------------- | ------------------------------------------------------ | --------------------------------------------- |
| [ansible-worker](ansible-worker/Dockerfile) | Alpine with Ansible, OpenSSH, and sshpass preinstalled | `ghcr.io/marco-lancini/ansible-worker:latest` |
| [nomad](nomad/Dockerfile)                   | Image for HashiCorp Nomad                              | `ghcr.io/marco-lancini/nomad:latest`          |
