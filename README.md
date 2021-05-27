# Pre-Requisites

These scripts use the `psql` command line tool.

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
 
 
## Usage on Local Environment 
### Generate Document Id’s from Case Data Using Recursive Method 
 `./migration-runner.sh -e local -o exportrecursivedocumentids`
 
### Generate Exception Report from Case Data Using Recursive Method 
 `./migration-runner.sh -e local -o exportrecursiveexception`
 
## Usage on AAT Environment
### Generate Document Id’s from Case Data Using Recursive Method
`./migration-runner.sh -e aat -o √`

### Generate Exception Report from Case Data Using Recursive Method
`./migration-runner.sh -e aat -o exportrecursiveexception`


