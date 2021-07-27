#!/bin/bash

function csv_post_process() {
    header='case_reference,case_type_id,jurisdiction,document_id'
    for file in x*
     do
     printf "%s\n%s" "$header" "`cat $file`" > $file
     mv "$file" "csvs/${JURISDICTION}-$file.csv";
    done;
}

mkdir -p tmp
mkdir -p csvs

echo -n "$(date) :[*] Generating csv files... "

export PGPASSWORD="$DATA_STORE_PASS"

psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -f scripts/generate-csv-files.sql 2>&1 > /dev/null

unset PGPASSWORD

csv_post_process

#cp tmp/allevents.csv allevents-${JURISDICTION}-$(date "+%Y%m%d-%H%M%S").csv
#cp tmp/problemdocumentids.csv problemdocumentids-${JURISDICTION}-$(date "+%Y%m%d-%H%M%S").csv
#cp tmp/problemcases.csv problemcases-${JURISDICTION}-$(date "+%Y%m%d-%H%M%S").csv

echo "$(date) :[done]"

