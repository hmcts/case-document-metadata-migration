#!/bin/bash

##
# STEP 7: Get the document field names from the CCD Definition Store snapshot
##

if [ -z "$JURISDICTION" ]; then
    JURISDICTION="%"
fi

echo -n "[*] Getting document keys... "
echo $DEFINITION_STORE_PASS
psql  -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -d "$DEFINITION_STORE_NAME" -U "$DEFINITION_STORE_USER" -w -v JURISDICTION="'${JURISDICTION}'" -f scripts/get-document-keys.sql definition_store_snapshot 2>&1 > /dev/null
echo "[Getting document keys... done]"
