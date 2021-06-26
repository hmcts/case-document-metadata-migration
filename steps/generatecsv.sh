#!/bin/bash

mkdir -p tmp

echo -n "[*] Generating csv files... "

export PGPASSWORD="$DATA_STORE_PASS"

psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -v FILENAME="'$TMP_DIR'" -f scripts/generate-csv-files.sql 2>&1 > /dev/null

unset PGPASSWORD

cp tmp/allevents.csv allevents-${JURISDICTION}-$(date "+%Y%m%d-%H%M%S").csv
cp tmp/docstoreexport.csv docstoreexport-${JURISDICTION}-$(date "+%Y%m%d-%H%M%S").csv

cp tmp/problemdocumentids.csv problemdocumentids-${JURISDICTION}-$(date "+%Y%m%d-%H%M%S").csv
cp tmp/problemcases.csv problemcases-${JURISDICTION}-$(date "+%Y%m%d-%H%M%S").csv

echo "[done]"

