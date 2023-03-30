#! /bin/sh

set -ueo pipefail

# ==============================================================================
# CONFIG
# ==============================================================================
#
# STATIC
#
PATH_CLOUDFLARED="/etc/cloudflared"
PATH_CREDENTIALS="${PATH_CLOUDFLARED}/credentials.json"
PATH_CONFIG="${PATH_CLOUDFLARED}/config.yml"

#
# ENV VARS
#
VAR_ORIGIN_URL=${ORIGIN_URL}
VAR_TUNNEL_UUID=${TUNNEL_UUID}

#
# SECRETS
#
VAR_TUNNEL_CREDENTIALS=${TUNNEL_CREDENTIALS}


# ==============================================================================
# PREPARE CLOUDFLARED CONFIG
# ==============================================================================
#
# Create folder
#
mkdir -p ${PATH_CLOUDFLARED}

#
# Fetch secrets
#
echo "[*] Fetching Cloudflared Tunnel: credentials JSON..."
echo "$VAR_TUNNEL_CREDENTIALS" > $PATH_CREDENTIALS

#
# Create config file
#
echo -e "tunnel: ${VAR_TUNNEL_UUID}
credentials-file: ${PATH_CREDENTIALS}
url: ${VAR_ORIGIN_URL}
no-autoupdate: true" > $PATH_CONFIG


# ==============================================================================
# RUN TUNNEL
# ==============================================================================
set -ex

# Run tunnel
echo "[*] Starting tunnel..."
cloudflared tunnel --config ${PATH_CONFIG} run ${VAR_TUNNEL_UUID}
