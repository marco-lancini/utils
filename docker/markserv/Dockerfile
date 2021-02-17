FROM node:12-alpine

RUN npm i -g markserv

RUN addgroup --gid 11111 -S app
RUN adduser -s /bin/false -u 11111 -G app -S app

WORKDIR /src
RUN chown -R app:app /src
USER app

ENTRYPOINT [ "markserv", "-a", "0.0.0.0", "-p", "9090", "/src" ]
