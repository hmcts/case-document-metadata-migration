#!/bin/bash

function checkPreRequisites {
  az extension list-available | grep storage-preview -q
  if [[ "$?" -ne 0 ]]; then
    echo "  az 'store-preview' extension not installed."
    echo "  Install using: "
    echo "    az extension add --name storage-preview"
    exit 1
  fi
}

function printUsage {
  echo "  Usage: ./uploadToAzureStorage account_name src dest sas-token"
  echo "    - account_name : account_name of the storage container"
  echo "    - src : source path from which to upload"
  echo "    - dest: azure storage destination path to upload dirs/files specified by src"
  echo "    - sas-token: used to authenticate requests to Azure storage account"
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

ACCOUNT_NAME="$1"
SRC="$2"
DEST="$3"
SAS_TOKEN="$4"

checkPreRequisites

if [ -z "$ACCOUNT_NAME" ]; then
    echo "  Account name has not been specified"
    printUsage
    exit 1
fi
if [ -z "$SRC" ]; then
    echo "  Source has not been specified"
    printUsage
    exit 1
fi

if [ -z "$DEST" ]; then
    echo "  Target directory has not been specified"
    printUsage
    exit 1
fi

if [ -z "$SAS_TOKEN" ]; then
    echo "  Azure SAS_TOKEN String has not been specified"
    printUsage
    exit 1
fi

az storage blob directory upload --account-name "$ACCOUNT_NAME" -c hmctsmetadata --sas-token "$SAS_TOKEN" -s "$SRC" -d "$DEST" --recursive --only-show-errors
