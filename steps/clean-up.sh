#!/bin/bash

##
# STEP 11: Delete the temporary files and drop the snapshot databases on the local postgres server
##

echo -n "[*] Deleting temp files... "
rm -rf ./tmp
echo "[done]"
echo -n "[*] Dropping snapshot databases... "
dropdb data_store_snapshot 2>&1 > /dev/null
echo "[done]"
