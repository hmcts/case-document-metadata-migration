#!/bin/bash

##
# Check the arguments that are passed to the script
##

while getopts 'o:' FLAG; do
    case "${FLAG}" in
        o)
            OPERATION="${OPTARG}"
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
