#!/bin/bash

##
# STEP 3: Get the relevant database credentials for CCD Data Store based on the
# environment that the migration is being run in

case "$ENV$OPERATION$DBTYPE" in
     localtakesnapshotsrealtime)
        DATA_STORE_HOST="localhost"
        DATA_STORE_PORT="5050"
        DATA_STORE_NAME="ccd_data"
        DATA_STORE_USER="ccd"
        ;;
    localloadsnapshotssnapshotdb)
        DATA_STORE_TEMP_HOST="localhost"
        DATA_STORE_TEMP_PORT="5050"
        DATA_STORE_TEMP_NAME="ccd_data_temp"
        DATA_STORE_TEMP_USER="ccdtemp"
        DATA_STORE_TEMP_PASS="ccdtemp"
        ;;
    localexportrecursivedocumentidssnapshotdb)
        DATA_STORE_TEMP_HOST="localhost"
        DATA_STORE_TEMP_PORT="5050"
        DATA_STORE_TEMP_NAME="ccd_data_temp"
        DATA_STORE_TEMP_USER="ccdtemp"
        DATA_STORE_TEMP_PASS="ccdtemp"
        ;;
    localexportrecursiveexceptionsnapshotdb)
        DATA_STORE_TEMP_HOST="localhost"
        DATA_STORE_TEMP_PORT="5050"
        DATA_STORE_TEMP_NAME="ccd_data_temp"
        DATA_STORE_TEMP_USER="ccdtemp"
        DATA_STORE_TEMP_PASS="ccdtemp"
        ;;
    localexportrecursivedocumentidsrealtime)
        DATA_STORE_HOST="localhost"
        DATA_STORE_PORT="5050"
        DATA_STORE_NAME="ccd_data_temp"
        DATA_STORE_USER="ccdtemp"
        ;;
    aatexportrecursivedocumentidsrealtime)
        DATA_STORE_HOST="ccd-data-store-api-postgres-db-v11-aat.postgres.database.azure.com"
        DATA_STORE_PORT="5432"
        DATA_STORE_NAME="ccd_data_store"
        DATA_STORE_USER="ccd@ccd-data-store-api-postgres-db-v11-aat"
        ;;
    aatexportrecursiveexceptionrealtime)
        DATA_STORE_HOST="ccd-data-store-api-postgres-db-v11-aat.postgres.database.azure.com"
        DATA_STORE_PORT="5432"
        DATA_STORE_NAME="ccd_data_store"
        DATA_STORE_USER="ccd@ccd-data-store-api-postgres-db-v11-aat"
        ;;
    demoexportrecursivedocumentidsrealtime)
        DATA_STORE_HOST="ccd-data-store-api-postgres-db-v11-demo.postgres.database.azure.com"
        DATA_STORE_PORT="5432"
        DATA_STORE_NAME="ccd_data_store"
        DATA_STORE_USER="ccd@ccd-data-store-api-postgres-db-v11-demo"
        ;;
    demoexportrecursiveexceptionrealtime)
        DATA_STORE_HOST="ccd-data-store-api-postgres-db-v11-demo.postgres.database.azure.com"
        DATA_STORE_PORT="5432"
        DATA_STORE_NAME="ccd_data_store"
        DATA_STORE_USER="ccd@ccd-data-store-api-postgres-db-v11-demo"
        ;;
    ithcexportrecursivedocumentidsrealtime)
        DATA_STORE_HOST="ccd-data-store-api-postgres-db-v11-ithc.postgres.database.azure.com"
        DATA_STORE_PORT="5432"
        DATA_STORE_NAME="ccd_data_store"
        DATA_STORE_USER="ccd@ccd-data-store-api-postgres-db-v11-ithc"
        ;;
    ithcexportrecursiveexceptionrealtime)
        DATA_STORE_HOST="ccd-data-store-api-postgres-db-v11-ithc.postgres.database.azure.com"
        DATA_STORE_PORT="5432"
        DATA_STORE_NAME="ccd_data_store"
        DATA_STORE_USER="ccd@ccd-data-store-api-postgres-db-v11-ithc"
        ;;
    perftestexportrecursivedocumentidsrealtime)
        DATA_STORE_HOST="ccd-data-store-api-postgres-db-v11-perftest.postgres.database.azure.com"
        DATA_STORE_PORT="5432"
        DATA_STORE_NAME="ccd_data_store"
        DATA_STORE_USER="ccd@ccd-data-store-api-postgres-db-v11-perftest"
        ;;
    perftestexportrecursiveexceptionrealtime)
        DATA_STORE_HOST="ccd-data-store-api-postgres-db-v11-perftest.postgres.database.azure.com"
        DATA_STORE_PORT="5432"
        DATA_STORE_NAME="ccd_data_store"
        DATA_STORE_USER="ccd@ccd-data-store-api-postgres-db-v11-perftest"
        ;;
    aat)
        DATA_STORE_HOST=$(az keyvault secret show)
        DATA_STORE_PORT=$(az keyvault secret show)
        DATA_STORE_NAME=$(az keyvault secret show)
        DATA_STORE_USER=$(az keyvault secret show)
        DATA_STORE_PASS=$(az keyvault secret show)
        ;;
    *)
        ;;
esac
