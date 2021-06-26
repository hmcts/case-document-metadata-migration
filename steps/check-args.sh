#!/bin/bash

##
# Check the arguments that are passed to the script
##

while getopts 'o:j:' FLAG; do
    case "${FLAG}" in
        o)
            OPERATION="${OPTARG}"
            ;;
        j)
            JURISDICTION="${OPTARG}"
            ;;
        *)
            echo "[*] Usage: $0 "
            echo
            echo "    Mandatory flags"
            echo "    -o [operation]"
            echo "    -j [jurisdiction]"
            echo
            exit 1
            ;;
    esac
done
