# Remote Collaboration: Draw.io + Pad + Whiteboard

## Usage

* Start services: `docker-compose up`
* [Optional] Add aliases to quickly spin this up/down:
```
alias collab_up="docker-compose -f /Users/x/draw-pad-whiteboard/docker-compose.yml up"
alias collab_down="docker-compose -f /Users/x/draw-pad-whiteboard/docker-compose.yml down"
```

## How to access the services

* `127.0.0.1:3000`: Draw.io
* `127.0.0.1:3001`: Pad
* `127.0.0.1:3002`: Whiteboard
