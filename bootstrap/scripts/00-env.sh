#!/usr/bin/env sh
set -e

export VAULT_ADDR="https://openbao.openbao.svc.cluster.local:8200"
export VAULT_CACERT="/openbao/ssl/ca.crt"

# SOLO PARA ADMIN
export VAULT_TOKEN="${VAULT_TOKEN:-}"