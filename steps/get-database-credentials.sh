#!/bin/bash

##
# STEP 3: Get the relevant database credentials for CCD Definition Store and CCD Data Store based on the
# environment that the migration is being run in

case "$ENV$OPERATION$DBTYPE" in
     localtakesnapshotsrealtime)
        DEFINITION_STORE_HOST="localhost"
        DEFINITION_STORE_PORT="5050"
        DEFINITION_STORE_NAME="ccd_definition"
        DEFINITION_STORE_USER="ccd"
        DEFINITION_STORE_PASS="ccd"
        DATA_STORE_HOST="localhost"
        DATA_STORE_PORT="5050"
        DATA_STORE_NAME="ccd_data"
        DATA_STORE_USER="ccd"
        DATA_STORE_PASS="ccd"
        ;;
    localloadsnapshotssnapshotdb)
        DEFINITION_STORE_TEMP_HOST="localhost"
        DEFINITION_STORE_TEMP_PORT="5050"
        DEFINITION_STORE_TEMP_NAME="ccd_definition_temp"
        DEFINITION_STORE_TEMP_USER="ccdtemp"
        DEFINITION_STORE_TEMP_PASS="ccdtemp"
        DATA_STORE_TEMP_HOST="localhost"
        DATA_STORE_TEMP_PORT="5050"
        DATA_STORE_TEMP_NAME="ccd_data_temp"
        DATA_STORE_TEMP_USER="ccdtemp"
        DATA_STORE_TEMP_PASS="ccdtemp"
        ;;
    localexportdocumentidssnapshotdb)
        DEFINITION_STORE_TEMP_HOST="localhost"
        DEFINITION_STORE_TEMP_PORT="5050"
        DEFINITION_STORE_TEMP_NAME="ccd_definition_temp"
        DEFINITION_STORE_TEMP_USER="ccdtemp"
        DEFINITION_STORE_TEMP_PASS="ccdtemp"
        DATA_STORE_TEMP_HOST="localhost"
        DATA_STORE_TEMP_PORT="5050"
        DATA_STORE_TEMP_NAME="ccd_data_temp"
        DATA_STORE_TEMP_USER="ccdtemp"
        DATA_STORE_TEMP_PASS="ccdtemp"
        ;;
    localexportrecursivedocumentidssnapshotdb)
        DEFINITION_STORE_TEMP_HOST="localhost"
        DEFINITION_STORE_TEMP_PORT="5050"
        DEFINITION_STORE_TEMP_NAME="ccd_definition_temp"
        DEFINITION_STORE_TEMP_USER="ccdtemp"
        DEFINITION_STORE_TEMP_PASS="ccdtemp"
        DATA_STORE_TEMP_HOST="localhost"
        DATA_STORE_TEMP_PORT="5050"
        DATA_STORE_TEMP_NAME="ccd_data_temp"
        DATA_STORE_TEMP_USER="ccdtemp"
        DATA_STORE_TEMP_PASS="ccdtemp"
        ;;
    aatexportdocumentidsrealtime)
        DEFINITION_STORE_HOST="ccd-definition-store-data-migration.postgres.database.azure.com"
        DEFINITION_STORE_PORT="5432"
        DEFINITION_STORE_NAME="ccd_definition_store"
        DEFINITION_STORE_USER="ccd@ccd-definition-store-data-migration"
        DEFINITION_STORE_PASS='\6T8(D${;5T/Dxy)(\'
        DATA_STORE_HOST="ccd-data-store-data-migration.postgres.database.azure.com"
        DATA_STORE_PORT="5432"
        DATA_STORE_NAME="ccd_data_store"
        DATA_STORE_USER="ccd@ccd-data-store-data-migration"
        DATA_STORE_PASS='\=MyZ{4u$(zm%5.:!\'
        ;;
    aatexportrecursivedocumentidsrealtime)
        DEFINITION_STORE_HOST="ccd-definition-store-data-migration.postgres.database.azure.com"
        DEFINITION_STORE_PORT="5432"
        DEFINITION_STORE_NAME="ccd_definition_store"
        DEFINITION_STORE_USER="ccd@ccd-definition-store-data-migration"
        DEFINITION_STORE_PASS='\6T8(D${;5T/Dxy)(\'
        DATA_STORE_HOST="ccd-data-store-data-migration.postgres.database.azure.com"
        DATA_STORE_PORT="5432"
        DATA_STORE_NAME="ccd_data_store"
        DATA_STORE_USER="ccd@ccd-data-store-data-migration"
        DATA_STORE_PASS='\=MyZ{4u$(zm%5.:!\'
        ;;
    aat)
        DEFINITION_STORE_HOST=$(az keyvault secret show)
        DEFINITION_STORE_PORT=$(az keyvault secret show)
        DEFINITION_STORE_NAME=$(az keyvault secret show)
        DEFINITION_STORE_USER=$(az keyvault secret show)
        DEFINITION_STORE_PASS=$(az keyvault secret show)
        DATA_STORE_HOST=$(az keyvault secret show)
        DATA_STORE_PORT=$(az keyvault secret show)
        DATA_STORE_NAME=$(az keyvault secret show)
        DATA_STORE_USER=$(az keyvault secret show)
        DATA_STORE_PASS=$(az keyvault secret show)
        ;;
    *)
        ;;
esac
