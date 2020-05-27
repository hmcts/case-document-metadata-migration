#!/bin/bash

##
# STEP 10: Run the migration script for creating and populating the staging table in the CCD Data Store
# snapshot, and then export the staging table to a CSV file
##

mkdir -p tmp
if [ -z "$FROM_DATE" ]; then
    FROM_DATE="01-01-1970"
fi

if [ -z "$STAGING_TABLE" ]; then
    echo "id,case_id,case_type_id,jurisdiction,document_id,event_timestamp" > tmp/recursive-staging.csv
else
    cp "$STAGING_TABLE" tmp/recursive-staging.csv
fi

echo -n "[*] Populating staging table and exporting CSV... "
#psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -w -v FROM_DATE="'${FROM_DATE}'" -v JURISDICTION="'${JURISDICTION}'" -f scripts/migrate-staging.sql data_store_snapshot 2>&1 > /dev/null

if [ $OPERATION$DBTYPE = "exportrecursivedocumentidsrealtime" ]; then
    echo "EXPORTING Recursive DOCUMENT IDs : Exporting Document Ids from Temp DB $DATA_STORE_HOST  $DATA_STORE_PORT $DATA_STORE_NAME $DATA_STORE_USER"
    export PGPASSWORD="$DATA_STORE_PASS"
    minCaseId=$(psql -X -A sslmode=true -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -t -U "$DATA_STORE_USER" -W  -c "select min(cd.id) from case_data as cd LEFT JOIN case_event AS ce ON cd.id = ce.case_data_id and cd.jurisdiction LIKE '${JURISDICTION}';")
    echo "mincaseId : $minCaseId"
    maxCaseId=$(psql -X -A sslmode=true -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -t -U "$DATA_STORE_USER" -W  -c "select max(cd.id) from case_data as cd LEFT JOIN case_event AS ce ON cd.id = ce.case_data_id and cd.jurisdiction LIKE '${JURISDICTION}';")
    echo "maxcaseId : $maxCaseId"
    psql sslmode=true -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -W  -f scripts/pre-recursive-staging.sql
    declare -i startRecord="0";
    startRecord=$minCaseId;
    declare -i countOfRecords=50000;
    declare -i endRecord=$startRecord+$countOfRecords;
    declare -i maxCounter=$maxCaseId;
    while [ $startRecord -lt $maxCaseId ]
    do
      echo " After While Execute SQL startRecord= $startRecord and endRecord=$endRecord"
      psql sslmode=true -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -W -v START_RECORD="'${startRecord}'" -v END_RECORD="'${endRecord}'" -v JURISDICTION="'${JURISDICTION}'" -f scripts/recursive-staging.sql 2>&1 > /dev/null
      startRecord=$endRecord;
      endRecord=$endRecord+$countOfRecords;
      if [ $endRecord  -gt $maxCaseId ]
        then
          endRecord=$maxCaseId;
          echo "Inside Break Execute SQL startRecord= $startRecord and endRecord=$endRecord"
          psql sslmode=true -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -W -v START_RECORD="'${startRecord}'" -v END_RECORD="'${endRecord}'" -v JURISDICTION="'${JURISDICTION}'" -f scripts/recursive-staging.sql 2>&1 > /dev/null
      break
      fi
    done
    psql sslmode=true -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -W  -f scripts/post-recursive-staging.sql
    unset PGPASSWORD
fi

if [ $OPERATION$DBTYPE = "exportrecursivedocumentidssnapshotdb" ]; then
    echo "EXPORTING Recursive DOCUMENT IDs : Exporting Document Ids from Temp DB $DATA_STORE_TEMP_HOST  $DATA_STORE_TEMP_PORT $DATA_STORE_TEMP_NAME $DATA_STORE_TEMP_USER"
    export PGPASSWORD="$DATA_STORE_TEMP_PASS"
    minCaseId=$(psql -X -A sslmode=true -h "$DATA_STORE_TEMP_HOST" -p "$DATA_STORE_TEMP_PORT" -d "$DATA_STORE_TEMP_NAME" -t -U "$DATA_STORE_TEMP_USER" -W  -c "select min(cd.id) from case_data as cd LEFT JOIN case_event AS ce ON cd.id = ce.case_data_id and cd.jurisdiction LIKE '${JURISDICTION}';")
    echo "mincaseId : $minCaseId"
    maxCaseId=$(psql -X -A sslmode=true -h "$DATA_STORE_TEMP_HOST" -p "$DATA_STORE_TEMP_PORT" -d "$DATA_STORE_TEMP_NAME" -t -U "$DATA_STORE_TEMP_USER" -W  -c "select max(cd.id) from case_data as cd LEFT JOIN case_event AS ce ON cd.id = ce.case_data_id and cd.jurisdiction LIKE '${JURISDICTION}';")
    echo "maxcaseId : $maxCaseId"
    psql sslmode=true -h "$DATA_STORE_TEMP_HOST" -p "$DATA_STORE_TEMP_PORT" -d "$DATA_STORE_TEMP_NAME" -U "$DATA_STORE_TEMP_USER" -W  -f scripts/pre-recursive-staging.sql
    declare -i startRecord="0";
    startRecord=$minCaseId;
    declare -i countOfRecords=40;
    declare -i endRecord=$startRecord+$countOfRecords;
    declare -i maxCounter=$maxCaseId;
    while [ $startRecord -lt $maxCaseId ]
    do
      echo " After While Execute SQL startRecord= $startRecord and endRecord=$endRecord"
      psql sslmode=true -h "$DATA_STORE_TEMP_HOST" -p "$DATA_STORE_TEMP_PORT" -d "$DATA_STORE_TEMP_NAME" -U "$DATA_STORE_TEMP_USER" -W -v START_RECORD="'${startRecord}'" -v END_RECORD="'${endRecord}'" -v JURISDICTION="'${JURISDICTION}'" -f scripts/recursive-staging.sql 2>&1 > /dev/null
      startRecord=$endRecord;
      endRecord=$endRecord+$countOfRecords;
      if [ $endRecord  -gt $maxCaseId ]
        then
          endRecord=$maxCaseId;
          echo "Inside Break startRecord= $startRecord and endRecord=$endRecord"
          psql sslmode=true -h "$DATA_STORE_TEMP_HOST" -p "$DATA_STORE_TEMP_PORT" -d "$DATA_STORE_TEMP_NAME" -U "$DATA_STORE_TEMP_USER" -W -v START_RECORD="'${startRecord}'" -v END_RECORD="'${endRecord}'" -v JURISDICTION="'${JURISDICTION}'" -f scripts/recursive-staging.sql 2>&1 > /dev/null
      break
      fi
    done
    psql sslmode=true -h "$DATA_STORE_TEMP_HOST" -p "$DATA_STORE_TEMP_PORT" -d "$DATA_STORE_TEMP_NAME" -U "$DATA_STORE_TEMP_USER" -W  -f scripts/post-recursive-staging.sql
    unset PGPASSWORD
fi

cp tmp/allevents.csv allevents-${JURISDICTION}-$(date "+%Y%m%d-%H%M%S").csv
cp tmp/docstoreexport.csv docstoreexport-${JURISDICTION}-$(date "+%Y%m%d-%H%M%S").csv
#cp tmp/problemcases.csv problemcases-$(date "+%Y%m%d-%H%M%S").csv

#if [ ! -z "$STAGING_TABLE" ]; then
#    cp tmp/recursive-staging.csv "$STAGING_TABLE"
#else
#    cp tmp/recursive-staging.csv recursive-staging-$(date "+%Y%m%d-%H%M%S").csv
#fi
echo "[done]"
