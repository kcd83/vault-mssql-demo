# Vault demo with Sql Server backend

This demo explores using Vault, Hashicorp's service for managing secrets, to grant access to Microsoft Sql Server to an application.

The approach copies ideas from this MySQL example https://github.com/benschw/vault-demo and the offical documentation resides at https://www.vaultproject.io/.

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
