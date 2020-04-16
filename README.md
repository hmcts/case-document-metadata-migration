 
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


