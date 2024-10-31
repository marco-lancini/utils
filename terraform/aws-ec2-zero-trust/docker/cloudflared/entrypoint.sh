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
VAR_TUNNEL_CREDENTIALS_SSM_NAME=${TUNNEL_CREDENTIALS_SSM_NAME}

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
VAR_TUNNEL_CREDENTIALS=$(aws ssm get-parameter --region eu-west-1 --name "${VAR_TUNNEL_CREDENTIALS_SSM_NAME}" --with-decryption --query "Parameter.Value" --output text)
echo "$VAR_TUNNEL_CREDENTIALS" > $PATH_CREDENTIALS

#
# Extract tunnel UUID
#
VAR_TUNNEL_UUID=$(grep 'TunnelID' $PATH_CREDENTIALS | sed 's/.*TunnelID": "\(.*\)".*/\1/')

#
# Create config file
#
echo -e "tunnel: ${VAR_TUNNEL_UUID}
credentials-file: ${PATH_CREDENTIALS}
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
  wget ${VAR_ORIGIN_URL} 1>/dev/null 2>&1

  if [ $? -ne 0 ]; then
    echo "Attempt to connect to origin failed: ${VAR_ORIGIN_URL}"
    sleep 1
  else
    echo "Successfully connected to origin: ${VAR_ORIGIN_URL}"
    break
  fi
done


# ==============================================================================
# RUN TUNNEL
# ==============================================================================
set -ex

# Run tunnel
echo "[*] Starting tunnel..."
cloudflared tunnel --config ${PATH_CONFIG} run ${VAR_TUNNEL_UUID}
