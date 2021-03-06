#!/bin/bash

##
# STEP 4: If one or more database snapshots are not provided as input arguments, create new snapshots
# in the current state of the CCD Definition Store and/or CCD Data Store databases
##
#ssh -L 5433:ccd-definition-store-data-migration.postgres.database.azure.com:5432 bastion
if [[ -z "$DEFINITION_STORE_SNAPSHOT" || -z "$DATA_STORE_SNAPSHOT" ]]; then
    read -p "[*] Database snapshots have not been provided, so they will be created in their current state. Continue? (y/n): " CONFIRM
    if [[ $CONFIRM != [yY] && $CONFIRM != [yY][eE][sS] ]]; then
        echo "[*] Exiting"
        echo
        exit 1
    fi

    # if no db shapshots provided, create new snapshots
    if [ -z "$DEFINITION_STORE_SNAPSHOT" ]; then
        export PGPASSWORD="$DEFINITION_STORE_PASS"
        DEFINITION_STORE_SNAPSHOT="snapshot-definition-store-$(date "+%Y%m%d-%H%M%S")"
        echo -n "[*] Creating definition store database snapshot... "
        pg_dump -w -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -U "$DEFINITION_STORE_USER" "$DEFINITION_STORE_NAME" > "$DEFINITION_STORE_SNAPSHOT"
        echo "[done]"
        echo "[*] Wrote compressed definition store database snapshot to $DEFINITION_STORE_SNAPSHOT"
    fi

    if [ -z "$DATA_STORE_SNAPSHOT" ]; then
        export PGPASSWORD="$DATA_STORE_PASS"
        DATA_STORE_SNAPSHOT="snapshot-data-store-$(date "+%Y%m%d-%H%M%S")"
        echo -n "[*] Creating data store database snapshot... "
        pg_dump -w -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -U "$DATA_STORE_USER" "$DATA_STORE_NAME" > "$DATA_STORE_SNAPSHOT"
        echo "[done]"
        echo "[*] Wrote compressed data store database snapshot to $DATA_STORE_SNAPSHOT"
    fi
    echo "Usage for loading snapshots in snapshotdb : ./migration-runner.sh -e $ENV -o loadsnapshots -i snapshotdb -f $DEFINITION_STORE_SNAPSHOT -t $DATA_STORE_SNAPSHOT"
    unset PGPASSWORD
fi
