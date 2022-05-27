FROM alpine:3.16.0

# Install packages
#   OPTIONAL packages:
#       texmf-dist-formatsextra \
#       texmf-dist-pictures \
#       texmf-dist-science \
RUN apk update && \
    apk add --no-cache \
    texlive \
    texlive-xetex \
    texmf-dist \
    texmf-dist-latexextra \
    && rm -rf /var/cache/apk/*

RUN addgroup --gid 11111 -S app
RUN adduser -s /bin/false -u 11111 -G app -S app

WORKDIR /src
RUN chown -R app:app /src
USER app
