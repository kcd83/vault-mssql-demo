#!/bin/bash
# 01-init.sh

echo initialize vault
INIT_RESP=$(curl -s -X PUT http://${VAULT_HOST}:8200/v1/sys/init -d '{"secret_shares": 1, "secret_threshold": 1}')
ROOT_TOKEN=$(echo $INIT_RESP | jq .root_token | sed -e 's/^"//'  -e 's/"$//')
VAULT_KEY=$(echo $INIT_RESP | jq .keys[0] | sed -e 's/^"//'  -e 's/"$//')

echo write files 'vault_key' and 'root_token'
echo -e $ROOT_TOKEN > ./root_token
echo -e $VAULT_KEY > ./vault_key

