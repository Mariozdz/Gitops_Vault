#!/usr/bin/env sh
set -e
. ./00-env.sh

if [ -z "$1" ]; then
  echo "Uso: $0 <root_token>"
  exit 1
fi

export VAULT_TOKEN="$1"

vault token lookup