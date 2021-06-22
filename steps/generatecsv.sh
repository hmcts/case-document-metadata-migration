#!/bin/bash

mkdir -p tmp

export PGPASSWORD="$DATA_STORE_PASS"

TMP_DIR="$(pwd)/tmp/"

psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -v FILENAME="'$TMP_DIR'" -f scripts/create-jurisdiction-csv-files.sql 2>&1 > /dev/null
unset PGPASSWORD

pushd $TMP_DIR

for FILE in *; do cp $FILE "../$(basename ${FILE} .csv)-$(date "+%Y%m%d-%H%M%S").csv"; done

popd

echo "[done]"

