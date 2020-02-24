#!/bin/bash

echo -n "[*] Creating snapshot databases... "
dropdb --if-exists definition_store_snapshot > /dev/null 2>&1
dropdb --if-exists data_store_snapshot > /dev/null 2>&1
createdb definition_store_snapshot 2>&1 > /dev/null
createdb data_store_snapshot 2>&1 > /dev/null
psql definition_store_snapshot -c "DROP ROLE IF EXISTS ccd; CREATE ROLE ccd WITH SUPERUSER" 2>&1 > /dev/null
psql data_store_snapshot -c "DROP ROLE IF EXISTS ccd; CREATE ROLE ccd WITH SUPERUSER" 2>&1 > /dev/null
echo "[done]"
echo -n "[*] Loading snapshots into databases... "
psql definition_store_snapshot < "$DEFINITION_STORE_SNAPSHOT" 2>&1 > /dev/null
psql data_store_snapshot < "$DATA_STORE_SNAPSHOT" 2>&1 > /dev/null
echo "[done]"
