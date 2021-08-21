#!/bin/bash

##
# Delete the temporary files and unset database configuration environment variables
##

echo -n "[*] Deleting temp files... "
rm -rf ./tmp
echo "[done]"

echo -n "[*] Removing database configuration... "
unset DATA_STORE_HOST
unset DATA_STORE_PORT
unset DATA_STORE_NAME
unset DATA_STORE_USER
unset DATA_STORE_PASS
echo "[done]"