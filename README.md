 
 # Usage on Local Environment
 
 ## Pre-Requisites
 ###    Create Snapshot Database
 ###    Create Snapshot Users 
 ###    Update Scripts with Snapshot Database Credentials
 
 ## Take Snapshots of CCD Definition & CCD Data : 
 ### ./migration-runner.sh -e local -o takesnapshots -i realtime
 
 ## Load Snapshots of CCD Definition & CCD Data: 
 ### ./migration-runner.sh -e local -o loadsnapshots -i snapshotdb -f snapshot-definition-store-20200325-171225 -t snapshot-data-store-20200325-171226
 
 ## Generate Document Keys & Document Id’s (Option 1)
 ### ./migration-runner.sh -e local -o exportdocumentids -i snapshotdb
 
 ## Generate Document Id’s from Case Data Using Recursive Method (Option 2)
 ### ./migration-runner.sh -e local -o exportrecursivedocumentids -i snapshotdb
 
 ## Generate Exception Report from Case Data Using Recursive Method (Option 2)
 ### ./migration-runner.sh -e local -o exportrecursiveexception -i snapshotdb
 

# Usage on AAT Environment

## Generate Document Keys & Document Id’s (Option 1)
### ./migration-runner.sh -e aat -o exportdocumentids -i realtime

## Generate Document Id’s from Case Data Using Recursive Method (Option2)
### ./migration-runner.sh -e aat -o exportrecursivedocumentids -i realtime

## Generate Exception Report from Case Data Using Recursive Method (Option 2)
### ./migration-runner.sh -e aat -o exportrecursiveexception -i realtime


# Uploading CVS result files to Azure Storage

A script is provided that allowds upload of files or directory contents to Azure storage

## Pre-requisites

Please make sure azure cli >= `2.0.67`

This script has been tested with azure cli version `2.25.0`

### Upgrade to latest version of Azure CLI
Upgrade Azure CLI to the latest version

```
brew update
brew upgrade azure-cli
```

### Install `storage-preview` azure cli extension

`az extension add --name storage-preview`

## Script Usage

To upload files or directories to Azure storage use the following script 

`uploadToAzureStorage.sh src dest connectionString`

with following parameters

- `src`
    - the source file(s), or directory containing the files to be uploaded

- `dest`
    - the destination path on azure storage where file(s)/directory will be uploaded

- connectionString
    - used to authenticate with azure storage, should be in the following format, where ACCOUNT_NAME and ACCOUNT_KEY
    are obviously relevant values for your azure storage container
        
        `DefaultEndpointsProtocol=https;AccountName=<ACCOUNT_NAME>;AccountKey=<ACCOUNT_KEY>;EndpointSuffix=core.windows.net`
    
### Usage examples

Store the connection string in an environment variable rather than having to supply on command line each time

```
export UPLOAD_SCRIPT_CONN_STRING=`DefaultEndpointsProtocol=https;AccountName=<ACCOUNT_NAME>;AccountKey=<ACCOUNT_KEY>;EndpointSuffix=core.windows.net`
```

- Upload all csv files in local `SCSS` directory generated on 23rd June 2021 to azure storage root directory

    `./uploadToAzureStorage.sh './SSCS/*-20210623-*.csv' '.' "$UPLOAD_SCRIPT_CONN_STRING"`

- Upload a local single file to azure storage root directory
    
    `./uploadToAzureStorage.sh './CIVIL-20210621-120339.csv' './CIVIL-20210621-120339.csv' "$UPLOAD_SCRIPT_CONN_STRING"`

- Upload a local directory and all of its contents to storage root directory

    `./uploadToAzureStorage.sh './SSCS/*' '.' "$UPLOAD_SCRIPT_CONN_STRING"`
    
## Troubleshooting

If the script output the `Final Job Status` reports anything other than `Completed`, the location of the log file for 
the file copy operation is displayed and can be used for diagnosing failures

e.g
```
Job b6ead437-7edd-da43-71b0-7032b978bf1a has started
Log file is located at: /Users/hmcts/.azcopy/b6ead437-7edd-da43-71b0-7032b978bf1a.log
```


