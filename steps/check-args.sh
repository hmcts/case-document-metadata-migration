#!/bin/bash

while getopts 'e:j:d:f:t:s:' FLAG; do
    case "${FLAG}" in
        e)
            ENV="${OPTARG}"
            ;;
        j)
            JURISDICTION="${OPTARG}"
            ;;
        d)
            FROM_DATE="${OPTARG}"
            ;;
        f)
            DEFINITION_STORE_SNAPSHOT="${OPTARG}"
            ;;
        t)
            DATA_STORE_SNAPSHOT="${OPTARG}"
            ;;
        s)
            STAGING_TABLE="${OPTARG}"
            ;;
        *)
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
            ;;
    esac
done