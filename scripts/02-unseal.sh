#!/bin/bash
# 02-unseal.sh

VAULT_KEY=$(cat ./vault_key)

echo unseal vault on ${VAULT_HOST}
curl -X PUT http://${VAULT_HOST}:8200/v1/sys/unseal -d '{"secret_shares": 1, "key": "'$VAULT_KEY'"}'
