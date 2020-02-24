#!/bin/bash

##
# STEP 8: Export the document field names to the local file system
##

mkdir -p tmp
echo -n "[*] Exporting document keys... "
pg_dump -t document_keys definition_store_snapshot > tmp/document_keys.tbl
echo "[done]"
