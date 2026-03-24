#!/usr/bin/env sh
set -e
. ./00-env.sh

echo "Habilitando cert auth..."

vault auth enable cert || true

vault auth list