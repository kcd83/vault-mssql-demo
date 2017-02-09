#!/usr/bin/env bash

set -e

if ! command -v jq > /dev/null 2>&1
then
  echo installing jq
  apt-get update
  apt-get install -y jq
fi

VAULT_HOST=vault

SECRET_TOKEN=$(cat ${BASH_SOURCE%/*}/app_secret_token)

echo "accessing vault on ${VAULT_HOST} as musicstoreapp"

echo "login"
response=$(curl -X POST http://${VAULT_HOST}:8200/v1/auth/approle/login \
	-d "{\"role_id\":\"musicstoreapp\",\"secret_id\":$SECRET_TOKEN}")
echo $response | jq .
auth_token=$(echo $response | jq -r .auth.client_token)

echo "create 'mssql' credentials"
response=$(curl http://${VAULT_HOST}:8200/v1/mssql/creds/contosouniversity -H "X-Vault-Token: $auth_token")
echo $response | jq .
user=$(echo $response | jq -r .data.username)
pass=$(echo $response | jq -r .data.password)


export ConnectionStrings__DefaultConnection="Server=mssql;Database=ContosoUniversity;Trusted_Connection=False;MultipleActiveResultSets=true;User ID=${user};Password=${pass}"

echo "connection string created"
echo $ConnectionStrings__DefaultConnection

# standard restore and run
dotnet restore

dotnet run
