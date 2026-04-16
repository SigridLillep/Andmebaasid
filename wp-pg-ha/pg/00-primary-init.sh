#!/bin/bash
set -e

echo "Configuring PostgreSQL primary for replication..."

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${REPL_USER}') THEN
    CREATE ROLE ${REPL_USER} WITH REPLICATION LOGIN PASSWORD '${REPL_PASSWORD}';
  END IF;
END
\$\$;
EOSQL

echo "host replication ${REPL_USER} 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
echo "host ${POSTGRES_DB} ${POSTGRES_USER} 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
echo "host ${POSTGRES_DB} all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
