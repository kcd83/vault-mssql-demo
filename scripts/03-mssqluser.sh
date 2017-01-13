#!/bin/bash
# 03-mssqluser.sh

echo "create 'vault' user"
sqlcmd -S mssql -U SA -P 'Passw0rd' -i CreateVaultUser.sql
