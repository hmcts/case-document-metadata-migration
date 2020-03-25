#!/bin/bash

##
# STEP 9: Import the document field names to the CCD Data Store snapshot
##

if [ $OPERATION$DBTYPE = "exportdocumentidsrealtime" ]; then
    echo "Importing document keys to data store... Realtime DB $DATA_STORE_HOST  $DATA_STORE_PORT $DATA_STORE_NAME $DATA_STORE_USER"
 #   export PGPASSWORD="$DATA_STORE_PASS"
    psql sslmode=true -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -W  -c "DROP TABLE IF EXISTS document_keys;" 2>&1 > /dev/null
    psql sslmode=true -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -W  < tmp/document_keys.tbl 2>&1 > /dev/null
    unset PGPASSWORD
fi

if [ $OPERATION$DBTYPE = "exportdocumentidssnapshotdb" ]; then
    echo "Importing document keys to data store... Snapshot DB $DATA_STORE_TEMP_HOST  $DATA_STORE_TEMP_PORT $DATA_STORE_TEMP_NAME $DATA_STORE_TEMP_USER"
 #   export PGPASSWORD="$DATA_STORE_TEMP_PASS"
    psql sslmode=true -h "$DATA_STORE_TEMP_HOST" -p "$DATA_STORE_TEMP_PORT" -d "$DATA_STORE_TEMP_NAME" -U "$DATA_STORE_TEMP_USER" -W  -c "DROP TABLE IF EXISTS document_keys;" 2>&1 > /dev/null
    psql sslmode=true -h "$DATA_STORE_TEMP_HOST" -p "$DATA_STORE_TEMP_PORT" -d "$DATA_STORE_TEMP_NAME" -U "$DATA_STORE_TEMP_USER" -W < tmp/document_keys.tbl 2>&1 > /dev/null
    unset PGPASSWORD
fi

#echo -n "[*] Importing document keys to data store... "
#psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -w data_store_snapshot < tmp/document_keys.tbl 2>&1 > /dev/null
#echo "[done]"
