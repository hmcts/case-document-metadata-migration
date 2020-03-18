#!/bin/bash

##
# STEP 3: Get the relevant database credentials for CCD Definition Store and CCD Data Store based on the
# environment that the migration is being run in
##

case "$ENV" in
    local)
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
    aattest)
        HTTP_PROXY="proxyout.reform.hmcts.net:8080"
        DEFINITION_STORE_HOST="localhost"
        DEFINITION_STORE_PORT="5433"
        DEFINITION_STORE_NAME="ccd_definition_store"
        DEFINITION_STORE_USER="ccd@ccd-definition-store-data-migration"
        DEFINITION_STORE_PASS='\6T8(D${;5T/Dxy)(\'
        DATA_STORE_HOST="localhost"
        DATA_STORE_PORT="5433"
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
