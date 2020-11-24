#!/bin/bash

# ==============================================================================
# VARS
# ==============================================================================
REGISTRY="ghcr.io/marco-lancini/"
USAGE="
  Usage: $0 <version>
  Example: $0 1.0"

IMAGE_NAME=$1
IMAGE_VERSION=$2
TAGGED_IMAGE="${IMAGE_NAME}:${IMAGE_VERSION}"
REMOTE_IMAGE="${REGISTRY}${TAGGED_IMAGE}"


# ==============================================================================
# UTILS
# ==============================================================================
function check_authn() {
    if grep -q "ghcr.io" ~/.docker/config.json
    then
        echo "[*] Already authenticated to Github Registry. Continuing..."
    else
        echo -e "[*] Not yet authenticated to Github Registry.\nPlease authenticate: $ docker login ghcr.io -u <username>"
        exit 1
    fi
}

# ==============================================================================
# RUN
# ==============================================================================
# Validate Inputs
if [[ $# -lt 1 ]] ; then
    echo -e "$USAGE"
    exit 1
fi

echo "[*] Checking authentication..."
check_authn

echo "[*] Building $TAGGED_IMAGE"
docker build -t $TAGGED_IMAGE .

echo "[*] Tagging $TAGGED_IMAGE --> $REMOTE_IMAGE"
docker tag $TAGGED_IMAGE $REMOTE_IMAGE

echo "[*] Pushing $REMOTE_IMAGE"
docker push $REMOTE_IMAGE

echo "[*] Completed"
