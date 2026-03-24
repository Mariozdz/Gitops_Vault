#!/usr/bin/env sh
set -e
. ./00-env.sh

echo "Habilitando KV..."
vault secrets enable -path=kv kv-v2 || true

vault secrets list