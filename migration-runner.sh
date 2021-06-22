#!/bin/bash

echo
set -e
set -u
#set -o pipefail

OPERATION=

echo "[*] Starting"

source steps/check-required-software.sh
source steps/check-args.sh

if [ -z $OPERATION ] ; then
    echo "[*] Usage: $0 -o [operation] "
    echo "    Mandatory flags"
    echo "    -o [operation]"
    echo
    exit 1
fi

case "$OPERATION" in
    exportrecursivedocumentids)
        source steps/recursive-staging-table.sh
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
