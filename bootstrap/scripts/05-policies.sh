#!/usr/bin/env sh
set -e
. ./00-env.sh

echo "Creando policies..."

vault policy write curl-bao-policy vault-policies/curl-bao-policy.hcl

vault policy list