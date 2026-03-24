#!/usr/bin/env sh
set -e
. ./00-env.sh

CERT_FILE="/openbao/ssl/ca.crt"

if [ ! -f "$CERT_FILE" ]; then
  echo "No existe el cert: $CERT_FILE"
  exit 1
fi

echo "Registrando certificado ca..."

vault write auth/cert/certs/curl-bao \
  display_name="curl-bao" \
  policies="curl-bao-policy" \
  certificate=@"$CERT_FILE"

vault list auth/cert/certs