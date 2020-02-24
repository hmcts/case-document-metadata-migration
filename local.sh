#!/bin/bash

if [[ -z "$DEFINITION_STORE_SNAPSHOT" || -z "$DATA_STORE_SNAPSHOT" ]]; then
    read -p "[*] Database snapshots have not been provided, so they will be created in their current state. Continue? (y/n): " CONFIRM
    if [[ $CONFIRM != [yY] && $CONFIRM != [yY][eE][sS] ]]; then
        echo "[*] Exiting"
        echo
        exit 1
    fi

    # STEP 4: If no database snapshots were provided, create them, compress them using gzip and save them to the host file system
    export PGPASSWORD="ccd"

    if [ -z "$DEFINITION_STORE_SNAPSHOT" ]; then
        DEFINITION_STORE_SNAPSHOT="snapshot-definition-store-$(date "+%Y%m%d-%H%M%S")"
        echo -n "[*] Creating definition store database snapshot... "
        OUT=$(pg_dump -w -h "localhost" -p "5050" -U "ccd" "ccd_definition" > "$DEFINITION_STORE_SNAPSHOT")
        echo "[done]"
        echo "[*] Wrote compressed definition store database snapshot to $DEFINITION_STORE_SNAPSHOT"
    fi

    if [ -z "$DATA_STORE_SNAPSHOT" ]; then
        DATA_STORE_SNAPSHOT="snapshot-data-store-$(date "+%Y%m%d-%H%M%S")"
        echo -n "[*] Creating data store database snapshot... "
        OUT=$(pg_dump -w -h "localhost" -p "5050" -U "ccd" "ccd_data" > "$DATA_STORE_SNAPSHOT")
        echo "[done]"
        echo "[*] Wrote compressed data store database snapshot to $DATA_STORE_SNAPSHOT"
    fi

    unset PGPASSWORD
fi

# ensure local postgres server is running
POSTMASTER=/usr/local/var/postgres/postmaster.pid
if [ ! -f "$POSTMASTER" ]; then
    echo -n "[*] Starting local postgres server... "
    OUT=$(pg_ctl -D /usr/local/var/postgres start)
    echo "[done]"
fi

# STEP 5: Create temporary databases to load snapshots
echo -n "[*] Creating snapshot databases... "
OUT=$(dropdb --if-exists definition_store_snapshot)
OUT=$(dropdb --if-exists data_store_snapshot)
OUT=$(createdb definition_store_snapshot)
OUT=$(createdb data_store_snapshot)
OUT=$(psql definition_store_snapshot -c "DROP ROLE IF EXISTS ccd; CREATE ROLE ccd WITH SUPERUSER")
OUT=$(psql data_store_snapshot -c "DROP ROLE IF EXISTS ccd; CREATE ROLE ccd WITH SUPERUSER")
echo "[done]"
# STEP 6: Load snapshots into temporary databases
echo -n "[*] Loading snapshots into databases... "
OUT=$(psql definition_store_snapshot < "$DEFINITION_STORE_SNAPSHOT")
OUT=$(psql data_store_snapshot < "$DATA_STORE_SNAPSHOT")
echo "[done]"

# STEP 7: Run script for retrieving the document keys from the CCD Definition Store database snapshot
if [ -z "${JURISDICTION}" ]; then
    JURISDICTION="%"
fi

echo -n "[*] Getting document keys... "
OUT=$(psql -v JURISDICTION="'${JURISDICTION}'" -f scripts/get-document-keys.sql definition_store_snapshot)
echo "[done]"
# STEP 8:Export the document_keys table to the host file system
mkdir -p tmp
echo -n "[*] Exporting document keys... "
OUT=$(pg_dump -t document_keys definition_store_snapshot > tmp/document_keys.tbl)
echo "[done]"
# STEP 9:Import the document_keys table into the CCD Data Store database snapshot
echo -n "[*] Importing document keys to data store... "
OUT=$(psql data_store_snapshot < tmp/document_keys.tbl)
echo "[done]"
# STEP 10: Run migration script for creating and populating the staging table in the CCD Data Store database snapshot, which results in the staging table being exported as a CSV file
if [ -z "${FROM_DATE}" ]; then
    FROM_DATE="01-01-1970"
fi

if [ -z "${STAGING_TABLE}" ]; then
    echo "id,case_id,case_type_id,jurisdiction,document_id,document_url,case_created_date,case_last_modified_date,migrated" > tmp/staging.csv
else
    cp "$STAGING_TABLE" tmp/staging.csv
fi

echo -n "[*] Populating staging table and exporting CSV... "
OUT=$(psql -v FROM_DATE="'${FROM_DATE}'" -v JURISDICTION="'${JURISDICTION}'" -f scripts/migrate-staging.sql data_store_snapshot)
if [ ! -z "$STAGING_TABLE" ]; then
    cp tmp/staging.csv "$STAGING_TABLE"
else
    cp tmp/staging.csv staging-$(date "+%Y%m%d-%H%M%S").csv
fi
echo "[done]"
rm -rf ./tmp

# STEP 11: drop local snapshot databases
echo -n "[*] Dropping snapshot databases... "
OUT=$(dropdb definition_store_snapshot)
OUT=$(dropdb data_store_snapshot)
echo "[done]"
