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
echo "STEP 1: DATA STORE Drop all the tables if it exists"
export PGPASSWORD="$DATA_STORE_TEMP_PASS"
psql  -h "$DATA_STORE_TEMP_HOST" -p "$DATA_STORE_TEMP_PORT" -d "$DATA_STORE_TEMP_NAME" -U "$DATA_STORE_TEMP_USER" -w -f scripts/drop-tables-tempdb.sql 2>&1 > /dev/null
echo "STEP 1 DONE"
unset PGPASSWORD

echo "STEP 2: LOAD ALL TABLES FROM SNAPSHOT IN TO TEMPDB"
export PGPASSWORD="$DATA_STORE_TEMP_PASS"
psql -h "$DATA_STORE_TEMP_HOST" -p "$DATA_STORE_TEMP_PORT" -d "$DATA_STORE_TEMP_NAME" -U "$DATA_STORE_TEMP_USER" -w -f "$DATA_STORE_SNAPSHOT"
echo "STEP 2 DONE"
unset PGPASSWORD

echo "Usage for exporting recursive document keys in realtimedb : ./migration-runner.sh -e $ENV -o exportrecursivedocumentids -i $DBTYPE"
echo "Usage for exporting recursive document exceptions in realtimedb : ./migration-runner.sh -e $ENV -o exportrecursiveexception -i $DBTYPE"#

echo "Creating snapshot databases [done]"



