#!/bin/bash

##
# STEP 2: Check the arguments that are passed to the script
##

while getopts 'e:o:i:j:d:f:t:s:' FLAG; do
    case "${FLAG}" in
        e)
            ENV="${OPTARG}"
            ;;
        o)
            OPERATION="${OPTARG}"
            ;;
        i)
            DBTYPE="${OPTARG}"
            ;;
        j)
            JURISDICTION="${OPTARG}"
            ;;
        d)
            FROM_DATE="${OPTARG}"
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
            echo "    -o [operation]"
            echo
            echo "    Optional flags"
            echo "    -j [jurisdiction]"
            echo "    -d [from_date]"
            echo "    -t [data_store_snapshot]"
            echo "    -s [staging_table]"
            echo
            exit 1
            ;;
    esac
done
