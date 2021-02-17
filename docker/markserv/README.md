# Markserv

Serve markdown as html (GitHub style), index directories, live-reload as you edit.


## Usage
```bash
$ docker run --rm -it --init -p 9090:9090 -v $(pwd):/src   \
             ghcr.io/marco-lancini/markserv:latest
```
