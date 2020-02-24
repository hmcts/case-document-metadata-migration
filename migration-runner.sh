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

# STEP 1: Check that required software is installed on the host system - PostgreSQL & gzip
IS_REQUIRED_SOFTWARE_INSTALLED=true

if ! [ -x "$(command -v psql)" ]; then
    echo "[*] postgres is required but could not be found"
    IS_REQUIRED_SOFTWARE_INSTALLED=false
fi

if [ "$IS_REQUIRED_SOFTWARE_INSTALLED" = false ]; then
    echo "[*] Exiting"
    echo
    exit 1
fi
# STEP 2: Check that the mandatory arguments were passed, and that the optional arguments are as expected
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

case "$ENV" in
    local)
        source local.sh
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
