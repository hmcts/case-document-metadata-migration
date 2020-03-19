#!/bin/bash

##
# STEP 6: Load the snapshots into local temporary databases
##
unset PGPASSWORD
echo -n "[*] Creating snapshot databases..."

# Create Database User Once & Password - ccdtemp
# Give Access Rights as Super User
# Drop all the tables if it exists
# Load all the tables from Snapshot
echo "STEP 1: DEFINITION  STORE Drop all the tables if it exists"
psql  -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -d "$DEFINITION_STORE_NAME" -U "$DEFINITION_STORE_TEMP_USER" -w -f scripts/drop-tables-tempdb.sql 2>&1 > /dev/null
echo "STEP 1 DONE"
unset PGPASSWORD
echo "STEP 2: DATA  STORE Drop all the tables if it exists"
psql  -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_TEMP_USER" -w -f scripts/drop-tables-tempdb.sql 2>&1 > /dev/null
echo "STEP 2 DONE"
unset PGPASSWORD
echo "STEP 3: LOAD ALL TABLES FROM SNAPSHOT IN TO TEMPDB"
psql -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -d "$DEFINITION_STORE_NAME" -U "$DEFINITION_STORE_TEMP_USER" -w -f "$DEFINITION_STORE_SNAPSHOT"
echo "STEP 3 DONE"
unset PGPASSWORD
echo "STEP 4:  LOAD ALL TABLES FROM SNAPSHOT IN TO TEMPDB"
psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_TEMP_USER" -w -f "$DATA_STORE_SNAPSHOT"
echo "STEP 4 DONE"
unset PGPASSWORD
echo $definition_store_snapshot
echo $data_store_snapshot




#dropdb --if-exists -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -U "$DEFINITION_STORE_DEST_USER" -w definition_store_snapshot > /dev/null 2>&1
#dropdb --if-exists -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -U "$DATA_STORE_DEST__USER" -w data_store_snapshot > /dev/null 2>&1
#unset PGPASSWORD
#unset PGPASSWORD
#createdb  -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -U "$DEFINITION_STORE_DEST_USER" -w definition_store_snapshot 2>&1 > /dev/null
#createdb  -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -U "$DATA_STORE_DEST_USER" -w data_store_snapshot 2>&1 > /dev/null
#psql -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -d "$DEFINITION_STORE_NAME" -U "$DEFINITION_STORE_ADMIN_USER" -w definition_store_snapshot -c "DROP ROLE IF EXISTS ccddest; CREATE ROLE ccddest WITH SUPERUSER" 2>&1 > /dev/null
#unset PGPASSWORD
#psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_ADMIN_USER" -w data_store_snapshot -c "DROP ROLE IF EXISTS ccddest; CREATE ROLE ccddest WITH SUPERUSER" 2>&1 > /dev/null
#echo -n "[*] Loading snapshots into databases... "
#psql -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -d "$DEFINITION_STORE_NAME" -U "$DEFINITION_STORE_DEST_USER" -w definition_store_snapshot < "$DEFINITION_STORE_SNAPSHOT" 2>&1 > /dev/null
#psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_DEST_USER" -w data_store_snapshot < "$DATA_STORE_SNAPSHOT" 2>&1 > /dev/null
#echo $definition_store_snapshot
#echo $data_store_snapshot
echo "Creating snapshot databases [done]"



