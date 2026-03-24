#!/usr/bin/env sh
set -e

ADDR="https://openbao.openbao.svc.cluster.local:8200"
CACERT="/etc/vault-client/ca.crt"

echo "Health check en progreso ..."

curl --cacert "$CACERT" \
  "$ADDR/v1/sys/health" | jq