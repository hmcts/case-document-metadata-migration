#!/bin/bash

##
# Run the migration script for creating and populating the staging table in the CCD Data Store
# snapshot, and then export the staging table to a CSV file
##

mkdir -p tmp

echo -n "[*] Populating staging table and exporting CSV... "

echo "EXPORTING Recursive DOCUMENT IDs : Exporting Document Ids from Temp DB $DATA_STORE_HOST $DATA_STORE_PORT $DATA_STORE_NAME $DATA_STORE_USER"
export PGPASSWORD="$DATA_STORE_PASS"
minCaseId=$(psql -X -A -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -t -U "$DATA_STORE_USER" -c "select min(id) from case_data;")
echo "mincaseId : $minCaseId"
maxCaseId=$(psql -X -A -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -t -U "$DATA_STORE_USER" -c "select max(id) from case_data;")
echo "maxcaseId : $maxCaseId"
psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -f scripts/pre-recursive-staging.sql
declare -i startRecord="0";
startRecord=$minCaseId;
declare -i countOfRecords=5000;
declare -i endRecord=$startRecord+$countOfRecords;
declare -i maxCounter=$maxCaseId;
while [ $startRecord -lt $maxCaseId ]
do
  echo "$(date) : Executing case batch from startRecord= $startRecord to endRecord=$endRecord"
  psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -v START_RECORD="'${startRecord}'" -v END_RECORD="'${endRecord}'" -f scripts/recursive-staging.sql 2>&1 > /dev/null
  startRecord=$endRecord;
  endRecord=$endRecord+$countOfRecords;
  if [ $endRecord  -gt $maxCaseId ]
    then
      endRecord=$maxCaseId;
      echo "Inside Break Execute SQL startRecord= $startRecord and endRecord=$endRecord"
      psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -v START_RECORD="'${startRecord}'" -v END_RECORD="'${endRecord}'" -f scripts/recursive-staging.sql 2>&1 > /dev/null
  break
  fi
done
echo "$(date) : Executing post recursive script"
psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -f scripts/post-recursive-staging.sql
unset PGPASSWORD

TMP_DIR="$(pwd)/tmp/"

psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -v FILENAME="'$TMP_DIR'" -f scripts/create-jurisdiction-csv-files.sql 2>&1 > /dev/null

pushd $TMP_DIR

for FILE in *; do cp $FILE "../$(basename ${FILE} .csv)-$(date "+%Y%m%d-%H%M%S").csv"; done

popd

echo "[done]"
