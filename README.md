# Pre-Requisites

These scripts use the `psql` and GNU `parallel`command line tools. Please install if not available. 
 
GNU `parallel` installation.
    - Mac -> $ brew install parallel
    - Debian -> $ sudo apt-get install parallel

The scripts will only run after a successful check that it is installed on the system.
      
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
 
## Generate staging table for all cases
 `./migration-runner.sh -o exporttostagingtable`

## Generate Exception Report from Case Data Using Recursive Method
 `./migration-runner.sh -o exportexceptionreport `
  
## Generate csv files from staging table for each jurisdiction 
 `./migration-runner.sh -o generatecsvs`



