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
    *)
        ;;
esac
