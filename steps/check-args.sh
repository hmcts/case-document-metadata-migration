#!/bin/bash

##
# Check the arguments that are passed to the script
##

while getopts 'o:j:s:' FLAG; do
    case "${FLAG}" in
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
            echo "[*] Usage: $0 "
            echo
            echo "    Mandatory flags"
            echo "    -o [operation]"
            echo "    -j [jurisdiction]"
            echo
            echo "    Optional flags"
            echo "    -s [staging_table]"
            echo
            exit 1
            ;;
    esac
done
