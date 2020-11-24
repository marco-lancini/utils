#! /bin/bash

CREDS="$(VAULT_ADDR=https://vault.local vault read aws/cartography/creds/cartography)"

AWS_ACCESS_KEY_ID=$(echo "$CREDS" | grep 'access_key' | awk '{print $2}')
AWS_SECRET_ACCESS_KEY=$(echo "$CREDS" | grep 'secret_key' | awk '{print $2}')
AWS_SESSION_TOKEN=$(echo "$CREDS" | grep 'security_token' | awk '{print $2}')

cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id=$(echo $AWS_ACCESS_KEY_ID)
aws_secret_access_key=$(echo $AWS_SECRET_ACCESS_KEY)
aws_session_token=$(echo $AWS_SESSION_TOKEN)
EOF
