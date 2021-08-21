#!/bin/bash

##
# Check that the required software is installed on the host machine
##

IS_REQUIRED_SOFTWARE_INSTALLED=true

if ! [ -x "$(command -v psql)" ]; then
    echo "[*] postgres is required but could not be found"
    IS_REQUIRED_SOFTWARE_INSTALLED=false
fi

if ! [ -x "$(command -v parallel)" ]; then
    echo "[*] GNU parallel is required but could not be found"
    IS_REQUIRED_SOFTWARE_INSTALLED=false
fi

if [ "$IS_REQUIRED_SOFTWARE_INSTALLED" = false ]; then
    echo "[*] Exiting"
    echo
    exit 1
fi
