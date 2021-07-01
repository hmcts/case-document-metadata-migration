#!/bin/bash

function printUsage {
  echo "  Usage: ./uploadToBlobstore src dest accountKey"
  echo "    - src : source path from which to upload"
  echo "    - dest: azure blob store destination path to upload dirs/files specified by src"
  echo "    - accessKey: key used to authenticate requests to Azure storage account"
}

function help {
    printUsage
    echo " "
    echo "  src supports wildcard statements"
    echo "    Example: './*-2021-0516-*' - all files with timestamp of 16th May 2021"
    echo " "
    echo "  dest is the path where files will be stored on azure storage - will be created if it doesn't exist"
    echo "    Example: './2021-05-16/CSV' - stored files in CSV sub directory within the 2021-05-16 parent directory"
}

while getopts ":h" option; do
   case $option in
      h) # display Help
         help
         exit;;
   esac
done

SRC="$1"
DEST="$2"
ACCESS_KEY="$3"

if [ -z "$SRC" ]; then
    echo "  Source has not been specified"
    printUsage
    exit 0
fi

if [ -z "$DEST" ]; then
    echo "  Target directory has not been specified"
    printUsage
    exit 0
fi

if [ -z "$ACCESS_KEY" ]; then
    echo "  Access Key has not been specified"
    printUsage
    exit 0
fi

CONN_STRING="DefaultEndpointsProtocol=https;AccountName=dmstorefiles;AccountKey=$ACCESS_KEY;EndpointSuffix=core.windows.net"

az storage fs directory upload -f data-migration-test -s "$SRC" -d "$DEST" --recursive --connection-string="$CONN_STRING" --only-show-errors