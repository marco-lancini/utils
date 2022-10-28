FROM node:12-alpine

LABEL org.opencontainers.image.source = "https://github.com/marco-lancini/utils"

RUN addgroup --gid 11111 -S app
RUN adduser -s /bin/false -u 11111 -G app -S app

RUN npm i -g markserv

WORKDIR /src
RUN chown -R app:app /src
USER app

ENTRYPOINT [ "markserv", "-a", "0.0.0.0", "-p", "9090", "/src" ]
