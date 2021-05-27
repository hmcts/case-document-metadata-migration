#!/bin/bash

echo
set -e
set -u
set -o pipefail

ENV=
OPERATION=
JURISDICTION=
STAGING_TABLE=

echo "[*] Starting"

source steps/check-required-software.sh
source steps/check-args.sh

if [ -z "$ENV" ]; then
    echo "[*] Usage: $0 -e [env]"
    echo "[*] Usage: $1 -o [operation]"
    echo "    Mandatory flags"
    echo "    -e [env]"
    echo "    -o [operation]"
    echo
    echo "    Optional flags"
    echo "    -j [jurisdiction]"
    echo "    -s [staging_table]"
    echo
    exit 1
fi

case "$ENV$OPERATION" in
    localexportrecursivedocumentids)
        source steps/recursive-staging-table.sh
        source steps/clean-up.sh
        ;;
    localexportrecursiveexception)
        source steps/recursive-exception-reports.sh
        source steps/clean-up.sh
        ;;
    aatexportrecursivedocumentids)
        source steps/recursive-staging-table.sh
        source steps/clean-up.sh
        ;;
    aatexportrecursiveexception)
        source steps/recursive-exception-reports.sh
        source steps/clean-up.sh
        ;;
    demoexportrecursivedocumentids)
        source steps/recursive-staging-table.sh
        source steps/clean-up.sh
        ;;
    demoexportrecursiveexception)
        source steps/recursive-exception-reports.sh
        source steps/clean-up.sh
        ;;
    ithcexportrecursivedocumentids)
        source steps/recursive-staging-table.sh
        source steps/clean-up.sh
        ;;
    ithcexportrecursiveexception)
        source steps/recursive-exception-reports.sh
        source steps/clean-up.sh
        ;;
    perftestexportrecursivedocumentids)
        source steps/recursive-staging-table.sh
        source steps/clean-up.sh
        ;;
    perftestexportrecursiveexception)
        source steps/recursive-exception-reports.sh
        source steps/clean-up.sh
        ;;
    prodtestexportrecursivedocumentids)
        source steps/recursive-staging-table.sh
        source steps/clean-up.sh
        ;;
    prodtestexportrecursiveexception)
        source steps/recursive-exception-reports.sh
        source steps/clean-up.sh
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
