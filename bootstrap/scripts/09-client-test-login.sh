#!/usr/bin/env sh
set -e

ADDR="https://openbao.openbao.svc.cluster.local:8200"
CACERT="/etc/vault-client/ca.crt"
CERT="/etc/vault-client/tls.crt"
KEY="/etc/vault-client/tls.key"

echo "Login cert auth..."

RESP=$(curl -s \
  --cacert "$CACERT" \
  --cert "$CERT" \
  --key "$KEY" \
  --request POST \
  --data '{"name":"curl-bao"}' \
  "$ADDR/v1/auth/cert/login")

echo "$RESP" | jq

TOKEN=$(echo "$RESP" | jq -r '.auth.client_token')

if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
  echo "No se obtuvo token"
  exit 1
fi

echo "VAULT TOKEN: $TOKEN"

export VAULT_TOKEN="$TOKEN"