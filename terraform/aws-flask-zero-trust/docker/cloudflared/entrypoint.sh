#! /bin/sh

set -ueo pipefail

# ==============================================================================
# CONFIG
# ==============================================================================
#
# STATIC
#
PATH_CLOUDFLARED="/etc/cloudflared"
PATH_PEM="${PATH_CLOUDFLARED}/cert.pem"
PATH_CREDENTIALS="${PATH_CLOUDFLARED}/credentials.json"
PATH_CONFIG="${PATH_CLOUDFLARED}/config.yml"

#
# ENV VARS
#
VAR_ORIGIN_URL=${ORIGIN_URL}
VAR_TUNNEL_NAME=${TUNNEL_NAME}

#
# SECRETS
#
VAR_TUNNEL_FLASK_CERT=${TUNNEL_FLASK_CERT}
VAR_TUNNEL_FLASK_CREDENTIALS=${TUNNEL_FLASK_CREDENTIALS}


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
echo "[*] Fetching Cloudflared Tunnel: cert.pem..."
echo "$VAR_TUNNEL_FLASK_CERT" > $PATH_PEM

echo "[*] Fetching Cloudflared Tunnel: credentials JSON..."
echo "$VAR_TUNNEL_FLASK_CREDENTIALS" > $PATH_CREDENTIALS

#
# Create config file
#
echo -e "credentials-file: ${PATH_CREDENTIALS}
url: ${VAR_ORIGIN_URL}
no-autoupdate: true" > $PATH_CONFIG


# ==============================================================================
# CHECK CONNECTION
# ==============================================================================
set +ex

# Check connection with origin
echo "[*] Checking connection with origin..."
for i in {1..60}
do
  wget ${ORIGIN_DNS} 1>/dev/null 2>&1

  if [ $? -ne 0 ]; then
    echo "Attempt to connect to ${ORIGIN_DNS} failed."
    sleep 1
  else
    echo "Connected to origin ${ORIGIN_DNS} successfully."
    break
  fi
done


# ==============================================================================
# RUN TUNNEL
# ==============================================================================
set -ex

# Run tunnel
echo "[*] Starting tunnel..."
cloudflared tunnel --config ${PATH_CONFIG} run ${VAR_TUNNEL_NAME}
