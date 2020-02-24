#!/bin/bash

if [ -z "$JURISDICTION" ]; then
    JURISDICTION="%"
fi

echo -n "[*] Getting document keys... "
psql -v JURISDICTION="'${JURISDICTION}'" -f scripts/get-document-keys.sql definition_store_snapshot 2>&1 > /dev/null
echo "[done]"
