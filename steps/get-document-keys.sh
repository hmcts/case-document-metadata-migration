#!/bin/bash

##
# STEP 7: Get the document field names from the CCD Definition Store snapshot
##

if [ -z "$JURISDICTION" ]; then
    JURISDICTION="%"
fi

if [ $OPERATION$DBTYPE = "exportdocumentidsrealtime" ]; then
    echo "GET DOCUMENT KEYS: Exporting Document Keys from Realtime DB $DEFINITION_STORE_HOST  $DEFINITION_STORE_PORT $DEFINITION_STORE_NAME $DEFINITION_STORE_USER"
 #   export PGPASSWORD="$DEFINITION_STORE_PASS"
    psql  sslmode=true -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -d "$DEFINITION_STORE_NAME" -U "$DEFINITION_STORE_USER" -W -v JURISDICTION="'${JURISDICTION}'" -f scripts/get-document-keys.sql
    unset PGPASSWORD
fi

if [ $OPERATION$DBTYPE = "exportdocumentidssnapshotdb" ]; then
    echo "GET DOCUMENT KEYS: Exporting Document Keys from Temp DB $DEFINITION_STORE_TEMP_HOST  $DEFINITION_STORE_TEMP_PORT $DEFINITION_STORE_TEMP_NAME $DEFINITION_STORE_TEMP_USER"
#    export PGPASSWORD="$DEFINITION_STORE_TEMP_PASS"
    psql  sslmode=true -h "$DEFINITION_STORE_TEMP_HOST" -p "$DEFINITION_STORE_TEMP_PORT" -d "$DEFINITION_STORE_TEMP_NAME" -U "$DEFINITION_STORE_TEMP_USER" -W -v JURISDICTION="'${JURISDICTION}'" -f scripts/get-document-keys.sql
    unset PGPASSWORD
fi

#echo -n "[*] Getting document keys... "
#echo $DEFINITION_STORE_PASS
#psql  -h "$DEFINITION_STORE_HOST" -p "$DEFINITION_STORE_PORT" -d "$DEFINITION_STORE_NAME" -U "$DEFINITION_STORE_USER" -w -v JURISDICTION="'${JURISDICTION}'" -f scripts/get-document-keys.sql
#echo "[Getting document keys... done]"
