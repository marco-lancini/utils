FROM alpine:3.12

RUN apk update && \
    apk upgrade &&  \
    apk add --no-cache --update ansible libffi-dev py-netaddr openssh sshpass zip jq

WORKDIR /src
CMD ["/bin/sh"]
