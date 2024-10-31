# ==============================================================================
# Download cloudflared
# ==============================================================================
FROM debian:bookworm-slim as build

# Install dependencies
RUN apt-get update                       && \
    apt-get install -y curl

# Download cloudflared
RUN curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared  && \
    chmod +x cloudflared                && \
    mv cloudflared /usr/local/bin/

# ==============================================================================
# Run from alpine
# ==============================================================================
FROM alpine:3.12

# Install dependencies
RUN apk update && apk add --no-cache aws-cli

# Get cloudflared from build
COPY --from=build /usr/local/bin/cloudflared /usr/local/bin/cloudflared

# Copy script
WORKDIR /etc/cloudflared
COPY ./entrypoint.sh /etc/cloudflared/entrypoint.sh
RUN chmod +x /etc/cloudflared/entrypoint.sh

# Run script
ENTRYPOINT ["/etc/cloudflared/entrypoint.sh"]
