# ==============================================================================
# Download cloudflared
# ==============================================================================
FROM debian:stretch-slim as build

# Install dependencies
RUN apt-get update                       && \
    apt-get install -y curl

# Download cloudflared
RUN curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared  && \
    chmod +x cloudflared                && \
    mv cloudflared /usr/local/bin/


# ==============================================================================
# Run from distroless
# ==============================================================================
FROM alpine:3.12

# Get dependencies
COPY --from=build /usr/local/bin/cloudflared /usr/local/bin/cloudflared

# Copy script
WORKDIR /etc/cloudflared
COPY ./entrypoint.sh /etc/cloudflared/entrypoint.sh
RUN chmod +x /etc/cloudflared/entrypoint.sh

# Run script
ENTRYPOINT ["/etc/cloudflared/entrypoint.sh"]
