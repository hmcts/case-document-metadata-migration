#!/bin/bash

echo -n "[*] Importing document keys to data store... "
psql data_store_snapshot < tmp/document_keys.tbl 2>&1 > /dev/null
echo "[done]"
