#!/usr/bin/env sh
set -e

ADDR="https://openbao.openbao.svc.cluster.local:8200"
CACERT="/etc/vault-client/ca.crt"

if [ -z "$VAULT_TOKEN" ]; then
  echo "VAULT_TOKEN no definido"
  exit 1
fi

echo "Escribiendo secreto..."

curl --cacert "$CACERT" \
  --header "X-Vault-Token: $VAULT_TOKEN" \
  --request POST \
  --data '{"data":{"test":"ok"}}' \
  "$ADDR/v1/kv/data/application/curl-bao/demo"

echo "Leyendo secreto..."

curl --cacert "$CACERT" \
  --header "X-Vault-Token: $VAULT_TOKEN" \
  "$ADDR/v1/kv/data/application/curl-bao/demo" | jq