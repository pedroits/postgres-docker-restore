#!/bin/sh
echo "******PostgreSQL Restore******"

psql -U postgres -v ON_ERROR_STOP=1 <<-EOSQL
    CREATE DATABASE "${DB_NAME}";
    ALTER USER postgres WITH ENCRYPTED PASSWORD 'postgres';
EOSQL

pg_restore --format=c -O -x --no-data-for-failed-tables --no-password --username=postgres --dbname=${DB_NAME} /etc/postgresql/backup.db;
