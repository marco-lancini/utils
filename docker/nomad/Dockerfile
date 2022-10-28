FROM alpine:3.7

LABEL org.opencontainers.image.source = "https://github.com/marco-lancini/utils"

# Create a consul user and group first so the IDs get set the same way, even as
# the rest of this may change over time.
RUN addgroup nomad && \
    adduser -S -G nomad nomad

# Set up certificates, base tools, and Consul.
RUN set -eux && \
    apk add --no-cache ca-certificates curl openssl unzip  libc6-compat && \
    mkdir -p /tmp/build && \
    cd /tmp/build && \
    curl -sSL https://releases.hashicorp.com/nomad/0.8.6/nomad_0.8.6_linux_amd64.zip -o nomad.zip && \
    unzip nomad.zip && \
    install nomad /usr/bin/nomad && \
    cd /tmp && \
    nomad version

# Directories.
RUN mkdir -p /nomad/data && \
    mkdir -p /nomad/config && \
    chown -R nomad:nomad /nomad

# Expose the consul data directory as a volume since there's mutable state in there.
VOLUME /nomad/data

# Expose ports
EXPOSE 4646 4647 4648 4648/udp

CMD ["nomad"]
