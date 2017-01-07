# Vault demo with Sql Server backend

This demo explores using Vault, Hashicorp's service for managing secrets, to grant access to Microsoft Sql Server to an application.

The approach copies ideas from this MySQL example https://github.com/benschw/vault-demo and the offical documentation resides at https://www.vaultproject.io/.

## Toolbox

To ensure we have all the tools to run the demo scripts we will use an Ubuntu container with `curl` and `jq` installed. 

If you don't need this remove the `toolbox` section from `docker-compose.yml` and set the environment varaible `VAULT_HOST` to `localhost` which will utilise the `8200` port mapping.

Create the docker image.

```
toolbox\build.ps1
```

## Start Vault

Start Vault with Consul for data storage.

```
docker-compose up -d
```

You can check the logs if this started correctly and consul bootstrapped itself as the leader.

```
docker-compose logs
Attaching to vaultmssql_vault_1, vaultmssql_consul_1
vault_1   | ==> Vault server configuration:
vault_1   |
vault_1   |                  Backend: consul (HA available)
vault_1   |               Listener 1: tcp (addr: "0.0.0.0:8200", tls: "disabled")
vault_1   |                Log Level: info
vault_1   |                    Mlock: supported: true, enabled: false
vault_1   |         Redirect Address: http://172.18.0.2:8200
vault_1   |                  Version: Vault v0.6.1
...
consul_1  | ==> Starting raft data migration...
consul_1  | ==> Starting Consul agent...
consul_1  | ==> Starting Consul agent RPC...
consul_1  | ==> Consul agent running!
consul_1  |          Node name: '28d0d0e15dfb'
consul_1  |         Datacenter: 'dc1'
consul_1  |             Server: true (bootstrap: true)
...
consul_1  |     2017/01/06 23:48:37 [INFO] consul: cluster leadership acquired
consul_1  |     2017/01/06 23:48:37 [INFO] consul: New leader elected: 28d0d0e15dfb
...
```


## Initialise Vault

Vault starts in a secure sealed mode. If you start a shell in the vault container you can use the cli to show the status.

```
docker-compose exec vault sh
# vault status
Error checking seal status: Error making API request.

URL: GET http://127.0.0.1:8200/v1/sys/seal-status
Code: 400. Errors:

* server is not yet initialized
```

Open a shell in the scripts directory. To use the toolbox, start an interactive bash shell.

```
docker-compose run toolbox bash
```

Now we initise Vault (thanks [Ben Schwartz](https://github.com/benschw))

```
./01-init.sh
```

Typically we would initialise with five keys and a key threshold of three. E.g. each administrator would know only one key so three people would be required to unseal Vault.
Here we use just one key, this and the root token are stored in the newly created `scripts/vault_key` and root token `scripts/root_token` to simplify the demo.

Using one of one keys we can unseal Vault.

```
./02-unseal.sh
```

Logged in with the root token we can configure vault. This creates the following:
- enables [AppRole](https://www.vaultproject.io/docs/auth/approle.html) auth backend
- mssqlaccess policy to read the mssql backend
- musicstoreapp app role with the mssqlaccess policy

```
./03-configure.sh
```