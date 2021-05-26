 
 # Usage on Local Environment
 
 ## Pre-Requisites
 ###    Create Snapshot Database
 ###    Create Snapshot Users 
 ###    Update Scripts with Snapshot Database Credentials
 
 ## Take Snapshots of CCD Data Store data : 
 ### ./migration-runner.sh -e local -o takesnapshots -i realtime
 
 ## Load Snapshots of CCD Data: 
 ### ./migration-runner.sh -e local -o loadsnapshots -i snapshotdb -t snapshot-data-store-20200325-171226
 
 ## Generate Document Id’s from Case Data Using Recursive Method 
 ### ./migration-runner.sh -e local -o exportrecursivedocumentids -i snapshotdb
 
 ## Generate Exception Report from Case Data Using Recursive Method 
 ### ./migration-runner.sh -e local -o exportrecursiveexception -i snapshotdb
 

# Usage on AAT Environment

## Generate Document Id’s from Case Data Using Recursive Method
### ./migration-runner.sh -e aat -o exportrecursivedocumentids -i realtime

## Generate Exception Report from Case Data Using Recursive Method
### ./migration-runner.sh -e aat -o exportrecursiveexception -i realtime


