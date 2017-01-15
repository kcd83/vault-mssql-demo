#!/bin/bash
# 06-getmssqlaccess.sh

SECRET_TOKEN=$(cat ./app_secret_token)

echo "accessing vault on ${VAULT_HOST} as musicstoreapp"

echo "login"
curl -X POST http://${VAULT_HOST}:8200/v1/auth/approle/login \
	-d "{\"role_id\":\"musicstoreapp\",\"secret_id\":$SECRET_TOKEN}" \
	| jq . | tee /dev/tty | jq -r .auth.client_token > app_client_token

AUTH_TOKEN=$(cat ./app_client_token)

echo "create 'mssql' credentials"
response=$(curl http://${VAULT_HOST}:8200/v1/mssql/creds/efgodmode -H "X-Vault-Token: $AUTH_TOKEN")
echo $response | jq .
echo $response | jq -r .data.username
echo $response | jq -r .data.password
