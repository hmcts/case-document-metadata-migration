#!/bin/bash

echo -n "[*] Deleting temp files... "
rm -rf ./tmp
echo "[done]"
echo -n "[*] Dropping snapshot databases... "
dropdb definition_store_snapshot 2>&1 > /dev/null
dropdb data_store_snapshot 2>&1 > /dev/null
echo "[done]"
