 
 # Usage on Local Environment
 
 ## Pre-Requisites
 ### Create Snapshot Database & Users
Ensure a local Postgres database with access granted to user `ccd` is available on local machine
      
 ### Configure the database properties to be used
 
Update `databaseConfiguration.txt` with the following database properties

  - hostname
  - port
  - database name
  - database user
  - database password
   
 Run the following command to set the relevant environment variables with the configuration values
 
 `source set-environment-variables.sh`
 
  
 ## Take Snapshots of CCD Data Store data : 
 `./migration-runner.sh -e local -o takesnapshots -i realtime`
 
 ## Load Snapshots of CCD Data: 
 `./migration-runner.sh -e local -o loadsnapshots -i snapshotdb -t snapshot-data-store-20200325-171226`
 
 ## Generate Document Id’s from Case Data Using Recursive Method 
 `./migration-runner.sh -e local -o exportrecursivedocumentids -i snapshotdb`
 
 ## Generate Exception Report from Case Data Using Recursive Method 
 `./migration-runner.sh -e local -o exportrecursiveexception -i snapshotdb`
 

# Usage on AAT Environment

## Generate Document Id’s from Case Data Using Recursive Method
`./migration-runner.sh -e aat -o exportrecursivedocumentids -i realtime`

## Generate Exception Report from Case Data Using Recursive Method
`./migration-runner.sh -e aat -o exportrecursiveexception -i realtime`


