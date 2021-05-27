#!/bin/bash

echo
set -e
set -u
set -o pipefail

OPERATION=
JURISDICTION=
STAGING_TABLE=

echo "[*] Starting"

source steps/check-required-software.sh
source steps/check-args.sh

if [ -z $OPERATION ] || [ -z $JURISDICTION ]; then
    echo "[*] Usage: $0 -o [operation] -j [jurisdiction]"
    echo "    Mandatory flags"
    echo "    -o [operation]"
    echo "    -j [jurisdiction]"
    echo
    echo "    Optional flags"
    echo "    -s [staging_table]"
    echo
    exit 1
fi

case "$OPERATION" in
    exportrecursivedocumentids)
        source steps/recursive-staging-table.sh
        source steps/clean-up.sh
        ;;
    exportrecursiveexception)
        source steps/recursive-exception-reports.sh
        source steps/clean-up.sh
        ;;
    *)
        echo "[*] Unrecognised operation: $OPERATION"
        echo "[*] Exiting"
        echo
        exit 1
        ;;
esac

echo "[*] Finishing"
echo
exit 0
