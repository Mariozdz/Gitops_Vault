#!/usr/bin/env bash
set -euo pipefail
. ./00-env.sh

kubectl exec -n "$VAULT_NAMESPACE" "$VAULT_POD_NAME" -- vault status