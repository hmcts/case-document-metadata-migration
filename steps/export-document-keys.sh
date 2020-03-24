#!/bin/bash

##
# STEP 8: Export the document field names to the local file system
##

#mkdir -p tmp
echo -n "[*] Exporting document keys... "

if [ $OPERATION$DBTYPE = "exportdocumentidsrealtime" ]; then
    echo "Exporting Document Keys from Realtime DB $DEFINITION_STORE_HOST  $DEFINITION_STORE_PORT $DEFINITION_STORE_NAME $DEFINITION_STORE_USER"
    export PGPASSWORD="$DEFINITION_STORE_PASS"
    pg_dump -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -d "$DEFINITION_STORE_NAME" -U "$DEFINITION_STORE_USER" -t document_keys > tmp/document_keys.tbl
    unset PGPASSWORD
fi

if [ $OPERATION$DBTYPE = "exportdocumentidssnapshotdb" ]; then
    echo "Exporting Document Keys from Snapshotdb DB $DEFINITION_STORE_TEMP_HOST  $DEFINITION_STORE_TEMP_PORT $DEFINITION_STORE_TEMP_NAME $DEFINITION_STORE_TEMP_USER"
    export PGPASSWORD="$DEFINITION_STORE_TEMP_PASS"
    pg_dump -h "$DEFINITION_STORE_TEMP_HOST" -p "$DEFINITION_STORE_TEMP_PORT" -d "$DEFINITION_STORE_TEMP_NAME" -U "$DEFINITION_STORE_TEMP_USER" -t document_keys > tmp/document_keys.tbl
    unset PGPASSWORD
fi

#echo $DEFINITION_STORE_PASS
#pg_dump -t document_keys "$DEFINITION_STORE_SNAPSHOT" > tmp/document_keys.tbl
#pg_dump -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -d "$DEFINITION_STORE_NAME" -U "$DEFINITION_STORE_USER" -t document_keys > tmp/document_keys.tbl
#echo "Exporting document keys... [done]"
