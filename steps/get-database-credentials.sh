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
        DATA_STORE_PASS="ccd"
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
        DATA_STORE_PASS="ccdtemp"
        ;;
    aatexportdocumentidsrealtime)
        DATA_STORE_HOST="ccd-data-store-data-migration.postgres.database.azure.com"
        DATA_STORE_PORT="5432"
        DATA_STORE_NAME="ccd_data_store"
        DATA_STORE_USER="ccd@ccd-data-store-data-migration"
        DATA_STORE_PASS='\=MyZ{4u$(zm%5.:!\'
        ;;
    aatexportrecursivedocumentidsrealtime)
        DATA_STORE_HOST="ccd-data-store-data-migration.postgres.database.azure.com"
        DATA_STORE_PORT="5432"
        DATA_STORE_NAME="ccd_data_store"
        DATA_STORE_USER="ccd@ccd-data-store-data-migration"
        DATA_STORE_PASS='\=MyZ{4u$(zm%5.:!\'
        ;;
    aatexportrecursiveexceptionrealtime)
        DATA_STORE_HOST="ccd-data-store-data-migration.postgres.database.azure.com"
        DATA_STORE_PORT="5432"
        DATA_STORE_NAME="ccd_data_store"
        DATA_STORE_USER="ccd@ccd-data-store-data-migration"
        DATA_STORE_PASS='\=MyZ{4u$(zm%5.:!\'
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
