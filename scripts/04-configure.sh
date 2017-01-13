#!/bin/bash
# 04-configure.sh

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

echo "enable and configure mssql mount"
curl -X POST http://${VAULT_HOST}:8200/v1/sys/mounts/mssql -H "X-Vault-Token: $ROOT_TOKEN" \
	-d '{"type": "mssql"}'

curl -X POST http://${VAULT_HOST}:8200/v1/mssql/config/connection -H "X-Vault-Token: $ROOT_TOKEN" \
	-d '{"connection_string": "server=mssql;port=1433;user id=vault;password=Str0ng!Passw0rd;app name=vault;/"}'

echo "create efgodmode role for generating logins with dbcreator privileges required for entity framework"
curl -X POST http://${VAULT_HOST}:8200/v1/mssql/roles/efgodmode -H "X-Vault-Token: $ROOT_TOKEN" \
	-d '{"sql":"CREATE LOGIN [{{name}}] WITH PASSWORD = '"'"'{{password}}'"'"'; CREATE USER [{{name}}] FOR LOGIN [{{name}}]; ALTER SERVER ROLE [dbcreator] ADD MEMBER [{{name}}];"}'

