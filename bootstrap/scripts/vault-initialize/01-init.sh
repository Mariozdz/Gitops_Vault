#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="vault"
POD_NAME="vault-0"

echo "Verificando pod de Vault..."
kubectl get pod -n "$NAMESPACE" "$POD_NAME"

echo "Esperando a que Vault esté listo..."
kubectl wait --for=condition=Ready pod/"$POD_NAME" -n "$NAMESPACE" --timeout=300s

echo "Consultando estado actual..."
STATUS_JSON=$(kubectl exec -n "$NAMESPACE" "$POD_NAME" -- vault status -format=json)

INITIALIZED=$(echo "$STATUS_JSON" | grep '"initialized"' | sed 's/.*: \(true\|false\).*/\1/')
SEALED=$(echo "$STATUS_JSON" | grep '"sealed"' | sed 's/.*: \(true\|false\).*/\1/')

echo "Inicializado: $INITIALIZED"
echo "Sellado: $SEALED"

if [ "$INITIALIZED" = "true" ]; then
  echo
  echo "Vault ya está inicializado. No se hará nada."
  exit 0
fi

echo
echo "Inicializando Vault..."
INIT_OUTPUT=$(kubectl exec -n "$NAMESPACE" "$POD_NAME" -- \
  vault operator init -key-shares=5 -key-threshold=3 -format=json)

echo
echo "======================================"
echo "RESULTADO DE INICIALIZACION"
echo "======================================"
echo "$INIT_OUTPUT"
echo "======================================"
echo

echo "IMPORTANTE:"
echo "- Guarda las 5 unseal keys y el root token."
echo "- Necesitas 3 unseal keys para desbloquear manualmente."
echo "- Este script NO hace unseal."

echo
echo "Comandos manuales de unseal:"
echo "kubectl exec -n $NAMESPACE $POD_NAME -- vault operator unseal <UNSEAL_KEY_1>"
echo "kubectl exec -n $NAMESPACE $POD_NAME -- vault operator unseal <UNSEAL_KEY_2>"
echo "kubectl exec -n $NAMESPACE $POD_NAME -- vault operator unseal <UNSEAL_KEY_3>"
echo

echo "Estado actual:"
kubectl exec -n "$NAMESPACE" "$POD_NAME" -- vault status