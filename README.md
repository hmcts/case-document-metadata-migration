# Pre-Requisites

These scripts use the `psql` and GNU `parallel`command line tools. Please install if not available. 
 
GNU `parallel` installation.
    - Mac -> $ brew install parallel
    - Debian -> $ sudo apt-get install parallel

The scripts will only run after a successful check that it is installed on the system.

Please make sure azure cli >= `2.0.67`

Upgrade Azure CLI to the latest version

```
brew update
brew upgrade azure-cli
```

Install `storage-preview` azure cli extension

`az extension add --name storage-preview`      

## Configure the database properties to be used
Update `databaseConfiguration.txt` with the following database properties

  - hostname
  - port
  - database name
  - database user
  - database password
   
Run the following command to set the relevant environment variables with the configuration values
 
 `source set-environment-variables.sh`

# Running scripts 
> **_NOTE:_** - DO NOT RUN THESE SCRIPTS AGAINST LIVE DATABASES
>
> THESE SCRIPTS SHOULD BE RUN AGAINST CLONES/COPIES OF DATABASES
>
> These scripts
> - create and populate temporary tables
> - run recursive sql statements that may be detrimental to the performance of the targeted database
 
## Generate Document Id’s from Case Data Using Recursive Method, for SSCS jurisdiction 
 `nohup ./migration-runner.sh -o exportrecursivedocumentids -j SSCS >> sscs_out.txt &`
  
## Generate Exception Report from Case Data Using Recursive Method, for SSCS jurisdiction 
 `nohup ./migration-runner.sh -o exportrecursiveexception -j SSCS >> sscs_ex.txt &`
  
## Generate csv files for a jurisdiction 
 `nohup ./migration-runner.sh -o generatecsvs -j SSCS >> sscs_csv_out.txt &`



# Uploading CVS result files to Azure Storage

A script is provided that allowds upload of files or directory contents to Azure storage

## Script Usage

To upload files or directories to Azure storage use the following script 

`uploadToAzureStorage.sh account_name src dest sas-token`

with following parameters

- `account_name`
    - account name of azure storage container

- `src`
    - the source file(s), or directory containing the files to be uploaded

- `dest`
    - the destination path on azure storage where file(s)/directory will be uploaded

- `sas-token`
    - A Shared Access Signature (SAS). Must be used in conjunction with storage account name. Environment variable: AZURE_STORAGE_SAS_TOKEN. 
    
### Usage examples

Store the sas-token string in an environment variable rather than having to supply on command line each time

```
export AZURE_STORAGE_SAS_TOKEN=`?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacuptfx&se=2021-08-12T00:33:29Z&st=2021-08-11T16:33:29Z&spr=https&sig=CzuOvQ81jDMsU2dj8PrQiFwzSXCEkKYoPZznX70QXVM%3D`
```

- Upload all csv files in local `SCSS` directory generated on 23rd June 2021 to azure storage root directory on AAT

    `./uploadToAzureStorage.sh dmstoredocaat './SSCS/*-20210623-*.csv' '.' "$AZURE_STORAGE_SAS_TOKEN"`

- Upload a local single file to azure storage root directory
    
    `./uploadToAzureStorage.sh dmstoredocaat './CIVIL-20210621-120339.csv' './CIVIL-20210621-120339.csv' "$AZURE_STORAGE_SAS_TOKEN"`

- Upload a local directory and all of its contents to storage root directory

    `./uploadToAzureStorage.sh dmstoredocaat './SSCS/*' '.' "$AZURE_STORAGE_SAS_TOKEN"`
    
`NOTE`: Add ip address of your system in the firewall settings of azure storage account in case access is restricted with SAS_TOKEN.   
    
## Troubleshooting

If the script output the `Final Job Status` reports anything other than `Completed`, the location of the log file for 
the file copy operation is displayed and can be used for diagnosing failures

e.g
```
Job b6ead437-7edd-da43-71b0-7032b978bf1a has started
Log file is located at: /Users/hmcts/.azcopy/b6ead437-7edd-da43-71b0-7032b978bf1a.log
```


