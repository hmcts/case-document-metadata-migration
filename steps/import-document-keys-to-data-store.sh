#!/bin/bash

##
# STEP 9: Import the document field names to the CCD Data Store snapshot
##

echo -n "[*] Importing document keys to data store... "
psql data_store_snapshot < tmp/document_keys.tbl 2>&1 > /dev/null
echo "[done]"
