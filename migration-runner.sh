#!/bin/bash

echo
set -e
set -u
set -o pipefail

print_usage () {
    echo "[*] Usage: $0 -e [env]"
    echo
    echo "    Mandatory flags"
    echo "    -e [env]"
    echo
    echo "    Optional flags"
    echo "    -j [jurisdiction]"
    echo "    -d [from_date]"
    echo "    -f [definition_store_snapshot]"
    echo "    -t [data_store_snapshot]"
    echo "    -s [staging_table]"
    echo
    exit 1
}

echo "[*] Starting"

IS_REQUIRED_SOFTWARE_INSTALLED=true

if ! [ -x "$(command -v psql)" ]; then
    echo "[*] postgres is required but could not be found"
    IS_REQUIRED_SOFTWARE_INSTALLED=false
fi

if ! [ -x "$(command -v gzip)" ]; then
    echo "[*] gzip is required but could not be found"
    IS_REQUIRED_SOFTWARE_INSTALLED=false
fi

if [ "$IS_REQUIRED_SOFTWARE_INSTALLED" = false ]; then
    echo "[*] Exiting"
    echo
    exit 1
fi

ENV=
JURISDICTION=
FROM_DATE=
DEFINITION_STORE_SNAPSHOT=
DATA_STORE_SNAPSHOT=
STAGING_TABLE=

while getopts 'e:j:d:f:t:s:' FLAG; do
    case "${FLAG}" in
        e) ENV="${OPTARG}" ;;
        j) JURISDICTION="${OPTARG}" ;;
        d) FROM_DATE="${OPTARG}" ;;
        f) DEFINITION_STORE_SNAPSHOT="${OPTARG}" ;;
        t) DATA_STORE_SNAPSHOT="${OPTARG}" ;;
        s) STAGING_TABLE="${OPTARG}" ;;
        *) print_usage ;;
    esac
done

if [ -z "$ENV" ]; then
   print_usage
fi

if [[ "$ENV" == "local" && ( -z "$DEFINITION_STORE_SNAPSHOT" || -z "$DATA_STORE_SNAPSHOT" ) ]]; then
    read -p "[*] Database snapshots have not been provided, so they will be created in their current state. Continue? (y/n): " CONFIRM
    if [[ $CONFIRM != [yY] && $CONFIRM != [yY][eE][sS] ]]; then
        echo "[*] Exiting"
        echo
        exit 1
    fi

    # if no db shapshots provided, create new snapshots
    export PGPASSWORD="ccd"

    if [ -z "$DEFINITION_STORE_SNAPSHOT" ]; then
        DEFINITION_STORE_SNAPSHOT="snapshot-definition-store-$(date "+%Y%m%d-%H%M%S").gz"
        echo -n "[*] Creating definition store database snapshot... "
        OUT=$(pg_dump -w -h "localhost" -p "5050" -U "ccd" "ccd_definition" | gzip > "$DEFINITION_STORE_SNAPSHOT")
        echo "[done]"
        echo "[*] Wrote compressed definition store database snapshot to $DEFINITION_STORE_SNAPSHOT"
    fi

    if [ -z "$DATA_STORE_SNAPSHOT" ]; then
        DATA_STORE_SNAPSHOT="snapshot-data-store-$(date "+%Y%m%d-%H%M%S").gz"
        echo -n "[*] Creating data store database snapshot... "
        OUT=$(pg_dump -w -h "localhost" -p "5050" -U "ccd" "ccd_data" | gzip > "$DATA_STORE_SNAPSHOT")
        echo "[done]"
        echo "[*] Wrote compressed data store database snapshot to $DATA_STORE_SNAPSHOT"
    fi

    unset PGPASSWORD
fi

echo "[*] Finishing"
echo
exit 0
