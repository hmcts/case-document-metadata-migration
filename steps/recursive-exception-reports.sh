#!/bin/bash

##
# Run the migration script for creating and populating the staging table in the CCD Data Store
# snapshot, and then export the staging table to a CSV file
##

mkdir -p tmp

echo -n "[*] Populating staging table and exporting CSV... "

echo "EXPORTING Recursive DOCUMENT IDs : Exporting Document Ids from Temp DB $DATA_STORE_HOST  $DATA_STORE_PORT $DATA_STORE_NAME $DATA_STORE_USER"
export PGPASSWORD="$DATA_STORE_PASS"
psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -f scripts/recursive-exception-report.sql
unset PGPASSWORD

cp tmp/problemdocumentids.csv problemdocumentids-$(date "+%Y%m%d-%H%M%S").csv
cp tmp/problemcases.csv problemcases-$(date "+%Y%m%d-%H%M%S").csv

echo "[done]"