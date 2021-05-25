#!/bin/bash

echo
set -e
set -u
set -o pipefail

ENV=
OPERATION=
DBTYPE=
JURISDICTION=
FROM_DATE=
DEFINITION_STORE_SNAPSHOT=
DATA_STORE_SNAPSHOT=
STAGING_TABLE=
DATA_STORE_HOST=
DATA_STORE_PORT=
DATA_STORE_NAME=
DATA_STORE_USER=
DATA_STORE_PASS=
DATA_STORE_TEMP_HOST=
DATA_STORE_TEMP_PORT=
DATA_STORE_TEMP_NAME=
DATA_STORE_TEMP_USER=
DATA_STORE_TEMP_PASS=
HTTP_PROXY=

echo "[*] Starting"

source steps/check-required-software.sh
source steps/check-args.sh

if [ -z "$ENV" ]; then
    echo "[*] Usage: $0 -e [env]"
    echo "[*] Usage: $1 -o [operation]"
    echo "[*] Usage: $2 -db [dbtype]"
    echo "    Mandatory flags"
    echo "    -e [env]"
    echo "    -o [operation]"
    echo "    -db [dbtype]"
    echo
    echo "    Optional flags"
    echo "    -j [jurisdiction]"
    echo "    -d [from_date]"
    echo "    -t [data_store_snapshot]"
    echo "    -s [staging_table]"
    echo
    exit 1
fi

case "$ENV$OPERATION$DBTYPE" in
    localtakesnapshotsrealtime)
        source steps/get-database-credentials.sh
        source steps/take-database-snapshots.sh
        ;;
    localloadsnapshotssnapshotdb)
        source steps/get-database-credentials.sh
        source steps/start-local-postgres-server.sh
        source steps/load-database-snapshots.sh
        ;;
    localexportrecursivedocumentidssnapshotdb)
        source steps/get-database-credentials.sh
        source steps/start-local-postgres-server.sh
        source steps/recursive-staging-table.sh
        ;;
    localexportrecursiveexceptionsnapshotdb)
        source steps/get-database-credentials.sh
        source steps/start-local-postgres-server.sh
        source steps/recursive-exception-reports.sh
        ;;
    localexportrecursivedocumentidsrealtime)
        source steps/get-database-credentials.sh
        source steps/recursive-staging-table.sh
        ;;
    aatexportrecursivedocumentidsrealtime)
        source steps/get-database-credentials.sh
        source steps/recursive-staging-table.sh
        ;;
    aatexportrecursiveexceptionrealtime)
        source steps/get-database-credentials.sh
        source steps/recursive-exception-reports.sh
        ;;
    *)
        echo "[*] Unrecognised environment: $ENV"
        echo "[*] Exiting"
        echo
        exit 1
        ;;
esac

echo "[*] Finishing"
echo
exit 0
