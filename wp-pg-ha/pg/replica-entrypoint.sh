#!/bin/bash
set -e

echo "Replica starting..."

mkdir -p "$PGDATA"
chown -R postgres:postgres "$PGDATA"
chmod 700 "$PGDATA"

until pg_isready -h "${PRIMARY_HOST}" -U "${REPL_USER}" >/dev/null 2>&1; do
  echo "Waiting for primary (${PRIMARY_HOST})..."
  sleep 2
done

if [ -z "$(ls -A "$PGDATA" 2>/dev/null)" ]; then
  echo "Cloning primary with pg_basebackup..."
  export PGPASSWORD="${REPL_PASSWORD}"
  su -s /bin/bash postgres -c "pg_basebackup -h '${PRIMARY_HOST}' -U '${REPL_USER}' -D '$PGDATA' -Fp -Xs -P -R"
  echo "Clone done."
  chown -R postgres:postgres "$PGDATA"
  chmod 700 "$PGDATA"
else
  echo "PGDATA not empty, skipping basebackup."
  chown -R postgres:postgres "$PGDATA"
  chmod 700 "$PGDATA"
fi

echo "Starting postgres as replica..."
exec su -s /bin/bash postgres -c "postgres"
