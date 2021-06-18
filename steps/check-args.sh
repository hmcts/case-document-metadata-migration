#!/bin/bash

##
# Check the arguments that are passed to the script
##

while getopts 'o:j:s:' FLAG; do
    case "${FLAG}" in
        o)
            OPERATION="${OPTARG}"
            ;;
        s)
            STAGING_TABLE="${OPTARG}"
            ;;
        *)
            echo "[*] Usage: $0 "
            echo
            echo "    Mandatory flags"
            echo "    -o [operation]"
            echo
            exit 1
            ;;
    esac
done
