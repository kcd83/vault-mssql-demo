#!/bin/bash
# 03-configure.sh

ROOT_TOKEN=$(cat ./root_token)

echo configure vault on ${VAULT_HOST}

echo "enable 'approle' auth"
curl -X POST http://${VAULT_HOST}:8200/v1/sys/auth/approle -H "X-Vault-Token: $ROOT_TOKEN" \
	-d '{"type":"approle"}'

echo "create 'mssqlaccess' policy"
curl -X POST http://${VAULT_HOST}:8200/v1/sys/policy/mssqlaccess -H "X-Vault-Token: $ROOT_TOKEN" \
	-d '{"rules":"path \"mssql/creds/efgodmode\" {capabilities=[\"read\",\"list\"}"}'

echo "add 'musicstoreapp' app role"
curl -X POST http://${VAULT_HOST}:8200/v1/auth/approle/role/musicstoreapp -H "X-Vault-Token: $ROOT_TOKEN" \
	-d '{"policies": "mssqlaccess"}'

