#!/bin/bash

##
# STEP 6: Load the snapshots into local temporary databases
##

echo -n "[*] Creating snapshot databases..."
dropdb --if-exists -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -U "$DEFINITION_STORE_ADMIN_USER" -w definition_store_snapshot > /dev/null 2>&1
echo -n "CHECK 1"
dropdb --if-exists -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -U "$DATA_STORE_ADMIN_USER" -w data_store_snapshot > /dev/null 2>&1
echo -n "CHECK 2"

createdb  -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -U "$DEFINITION_STORE_ADMIN_USER" -w definition_store_snapshot 2>&1 > /dev/null
echo -n "CHECK 3"
createdb  -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -U "$DATA_STORE_ADMIN_USER" -w data_store_snapshot 2>&1 > /dev/null
echo -n "CHECK 4"
#psql -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -d "$DEFINITION_STORE_NAME" -U "$DEFINITION_STORE_ADMIN_USER" -w definition_store_snapshot -c "DROP ROLE IF EXISTS ccd; CREATE ROLE ccd WITH SUPERUSER" 2>&1 > /dev/null
echo -n "CHECK 5"
#psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_ADMIN_USER" -w data_store_snapshot -c "DROP ROLE IF EXISTS ccd; CREATE ROLE ccd WITH SUPERUSER" 2>&1 > /dev/null
echo "[done]"
echo -n "[*] Loading snapshots into databases... "
psql -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -d "$DEFINITION_STORE_NAME" -U "$DEFINITION_STORE_ADMIN_USER" -w definition_store_snapshot < "$DEFINITION_STORE_SNAPSHOT" 2>&1 > /dev/null
psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_ADMIN_USER" -w data_store_snapshot < "$DATA_STORE_SNAPSHOT" 2>&1 > /dev/null
echo $definition_store_snapshot
echo $data_store_snapshot
echo "Creating snapshot databases [done]"

