#!/bin/bash

##
# STEP 8: Export the document field names to the local file system
##

mkdir -p tmp
echo -n "[*] Exporting document keys... "
echo $DEFINITION_STORE_PASS
pg_dump -t document_keys "$DEFINITION_STORE_SNAPSHOT" > tmp/document_keys.tbl
#pg_dump -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -d "$DEFINITION_STORE_NAME" -U "$DEFINITION_STORE_USER" -t document_keys definition_store_snapshot > tmp/document_keys.tbl
echo "Exporting document keys... [done]"
