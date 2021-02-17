## Custom Docker Images

This folder contains the relevant sources (e.g., `Dockerfiles`, etc.) needed to
build a few custom Docker images.

All these images are pushed to [Github Container Registry](https://github.com/marco-lancini?tab=packages).


## Images

| Image                                       | Description                                            | Pull                                          | Status                                                                                                                               |
| ------------------------------------------- | ------------------------------------------------------ | --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| [ansible-worker](ansible-worker/Dockerfile) | Alpine with Ansible, OpenSSH, and sshpass preinstalled | `ghcr.io/marco-lancini/ansible-worker:latest` | ![[DOCKER IMAGE] Ansible Worker](https://github.com/marco-lancini/utils/workflows/%5BDOCKER%20IMAGE%5D%20Ansible%20Worker/badge.svg) |
| [latex](latex/Dockerfile)                   | Alpine with texlive preinstalled                       | `ghcr.io/marco-lancini/latex:latest`          | ![[DOCKER IMAGE] Latex](https://github.com/marco-lancini/utils/workflows/%5BDOCKER%20IMAGE%5D%20Latex/badge.svg)                     |
| [markserv](marksev/Dockerfile)                   | Image for [Markserv](https://github.com/markserv/markserv)                              | `ghcr.io/marco-lancini/markserv:latest`          | ![[DOCKER IMAGE] Markserv](https://github.com/marco-lancini/utils/workflows/%5BDOCKER%20IMAGE%5D%20Markserv/badge.svg)                     |
| [nomad](nomad/Dockerfile)                   | Image for HashiCorp Nomad                              | `ghcr.io/marco-lancini/nomad:latest`          | ![[DOCKER IMAGE] Nomad](https://github.com/marco-lancini/utils/workflows/%5BDOCKER%20IMAGE%5D%20Nomad/badge.svg)                     |
