#!/bin/bash

##
# STEP 2: Check the arguments that are passed to the script
##

while getopts 'e:o:i:j:d:t:s:p:' FLAG; do
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
        p)
            DATA_STORE_PASS="${OPTARG}"
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
            echo "    -p [dbPassword]"
            echo
            exit 1
            ;;
    esac
done
