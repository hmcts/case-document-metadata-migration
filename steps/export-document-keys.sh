#!/bin/bash

mkdir -p tmp
echo -n "[*] Exporting document keys... "
pg_dump -t document_keys definition_store_snapshot > tmp/document_keys.tbl
echo "[done]"
