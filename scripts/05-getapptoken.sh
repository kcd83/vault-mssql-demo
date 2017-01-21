#!/bin/bash
# 05-getapptoken

ROOT_TOKEN=$(cat ./root_token)

echo "accessing vault on ${VAULT_HOST}"

#:: vault write -wrap-ttl=60s -f auth/approle/role/musicstore/secret-id
echo "create 'musicstore' app auth token"
curl -X POST http://${VAULT_HOST}:8200/v1/auth/approle/role/musicstoreapp/secret-id -H "X-Vault-Token: $ROOT_TOKEN" \
	| jq . | tee /dev/tty | jq .data.secret_id > app/app_secret_token
