#!/bin/bash

##
# Check the arguments that are passed to the script
##

while getopts 'e:o:j:s:' FLAG; do
    case "${FLAG}" in
        e)
            ENV="${OPTARG}"
            ;;
        o)
            OPERATION="${OPTARG}"
            ;;
        j)
            JURISDICTION="${OPTARG}"
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
            echo "    -s [staging_table]"
            echo
            exit 1
            ;;
    esac
done
