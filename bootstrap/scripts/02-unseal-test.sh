#!/usr/bin/env sh
set -e
. ./00-env.sh

if [ "$#" -lt 3 ]; then
  echo "Uso: $0 <key1> <key2> <key3> [key4...]"
  exit 1
fi

echo "Estado inicial..."
vault status || true

for KEY in "$@"; do
  echo "== Aplicando unseal key =="
  vault operator unseal "$KEY"
done

echo "Estado final..."
vault status