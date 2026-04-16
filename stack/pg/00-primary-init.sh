#!/bin/bash
set -e

echo "Setting up replication user and pg_hba rules..."

# Create replication user (runs as POSTGRES_USER superuser during init)
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${REPL_USER}') THEN
    CREATE ROLE ${REPL_USER} WITH REPLICATION LOGIN PASSWORD '${REPL_PASSWORD}';
  END IF;
END
\$\$;
EOSQL

# Allow replica to connect for replication + normal DB access (docker network range)
echo "host replication ${REPL_USER} 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
echo "host ${POSTGRES_DB} ${POSTGRES_USER} 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
echo "host ${POSTGRES_DB} all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
