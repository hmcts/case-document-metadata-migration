#!/bin/bash

##
# STEP 10: Run the migration script for creating and populating the staging table in the CCD Data Store
# snapshot, and then export the staging table to a CSV file
##

mkdir -p tmp
if [ -z "$FROM_DATE" ]; then
    FROM_DATE="01-01-1970"
fi

if [ -z "$STAGING_TABLE" ]; then
    echo "id,case_id,case_type_id,jurisdiction,document_id,event_timestamp" > tmp/recursive-staging.csv
else
    cp "$STAGING_TABLE" tmp/recursive-staging.csv
fi

echo -n "[*] Populating staging table and exporting CSV... "
#psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -w -v FROM_DATE="'${FROM_DATE}'" -v JURISDICTION="'${JURISDICTION}'" -f scripts/migrate-staging.sql data_store_snapshot 2>&1 > /dev/null

if [ $OPERATION$DBTYPE = "exportrecursiveexceptionrealtime" ]; then
    echo "EXPORTING Recursive DOCUMENT IDs : Exporting Document Ids from Temp DB $DATA_STORE_HOST  $DATA_STORE_PORT $DATA_STORE_NAME $DATA_STORE_USER"
    export PGPASSWORD="$DATA_STORE_PASS"
    psql sslmode=true -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -W  -f scripts/recursive-exception-report.sql
    unset PGPASSWORD
fi

if [ $OPERATION$DBTYPE = "exportrecursiveexceptionsnapshotdb" ]; then
    echo "EXPORTING Recursive DOCUMENT IDs : Exporting Document Ids from Temp DB $DATA_STORE_TEMP_HOST  $DATA_STORE_TEMP_PORT $DATA_STORE_TEMP_NAME $DATA_STORE_TEMP_USER"
    export PGPASSWORD="$DATA_STORE_TEMP_PASS"
    psql sslmode=true -h "$DATA_STORE_TEMP_HOST" -p "$DATA_STORE_TEMP_PORT" -d "$DATA_STORE_TEMP_NAME" -U "$DATA_STORE_TEMP_USER" -W  -f scripts/recursive-exception-report.sql
    unset PGPASSWORD
fi

cp tmp/problemdocumentids.csv problemdocumentids-${JURISDICTION}-$(date "+%Y%m%d-%H%M%S").csv
cp tmp/problemcases.csv problemcases-${JURISDICTION}-$(date "+%Y%m%d-%H%M%S").csv

#if [ ! -z "$STAGING_TABLE" ]; then
#    cp tmp/recursive-staging.csv "$STAGING_TABLE"
#else
#    cp tmp/recursive-staging.csv recursive-staging-$(date "+%Y%m%d-%H%M%S").csv
#fi
echo "[done]"