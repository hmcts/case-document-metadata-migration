#!/bin/bash

##
# Run the migration script for creating and populating the staging table in the CCD Data Store
# snapshot, and then export the staging table to a CSV file
##

function execute_case_batch() {
  fromCaseId=$1   #startRecord
  toCaseId=`expr $1 + $2`   #startRecord+countOfRecords
  echo "$(date): Executing case batch from startRecord=$fromCaseId to endRecord=$toCaseId"
  psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -v START_RECORD="'${fromCaseId}'" -v END_RECORD="'${toCaseId}'" -f scripts/recursive-staging.sql 2>&1 > /dev/null
}

mkdir -p tmp
echo -n "[*] Populating staging table and exporting CSV... "

echo "EXPORTING Recursive DOCUMENT IDs : Exporting Document Ids from Temp DB $DATA_STORE_HOST $DATA_STORE_PORT $DATA_STORE_NAME $DATA_STORE_USER"
export PGPASSWORD="$DATA_STORE_PASS"
minCaseId=$(psql -X -A -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -t -U "$DATA_STORE_USER" -c "select min(id) from case_data;")
echo "mincaseId : $minCaseId"
maxCaseId=$(psql -X -A -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -t -U "$DATA_STORE_USER" -c "select max(id) from case_data;")
echo "maxcaseId : $maxCaseId"
psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -f scripts/pre-recursive-staging.sql

declare -i countOfRecords=2000;
declare -i startRecord=$minCaseId;
declare -i endRecord=$maxCaseId;
declare -i numberOfCores=8;

export -f execute_case_batch
parallel --link --jobs $numberOfCores execute_case_batch ::: `seq -f "%.0f" $startRecord $countOfRecords $endRecord` ::: $countOfRecords

echo "$(date) : Executing post recursive script"
psql -h "$DATA_STORE_HOST" -p "$DATA_STORE_PORT" -d "$DATA_STORE_NAME" -U "$DATA_STORE_USER" -f scripts/post-recursive-staging.sql

unset PGPASSWORD
echo "[done]"
