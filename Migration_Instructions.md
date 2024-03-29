# Migration Instructions

Follow below steps to run metadata migrations from Bastion (or local) against COPY of data-store database. 
Please refer [pre-requisites](README.md) if required.

 ##Part 1:
 This part executes relevant scripts to find out all case documents for a given jurisdiction and populate them into staging tables. (all_events and doc_store_export). Depending on number of cases in a jurisdiction it might take 2 - 5 hours to complete. 

- Log onto bastion non-prod

    ```bash
      ssh bastion-dev-nonprod
    ```

- Checkout migration scripts. 
    ```
      git clone https://github.com/hmcts/case-document-metadata-migration.git
            
      cd case-document-metadata-migration
    ``` 
- Configure the database properties to be used

  ```
    vi databaseConfiguration.txt  

    source set-environment-variables.sh
  ```

- Generate Document Id’s from case data using recursive method.(Eg: for SSCS)

   ```
    nohup ./migration-runner.sh -o exportrecursivedocumentids -j SSCS >> sscs_out.txt &
   ```
Depending on number of cases in a jurisdiction it might take 2 - 5 hours to complete above step. Progress can be checked using below command.

   ```
    tail -100f sscs_out.txt
   ```

Once above step has finished, run below command to generate CVSs from staging table (doc_store_export). 

- Generate csv files for a jurisdiction. ((Eg: for SSCS)
   ```
    nohup ./migration-runner.sh -o generatecsvs -j SSCS >> sscs_csv_out.txt &
  ```

## Part 2:  
This part needs to execute in co-ordination with EM team to upload generated CVSs into azure storage container. 

    Note: EM team must set metadata “Override” flag as FALSE in prod.

- Get azure storage SAS token from the portal for the account `dmstoredocprod`. Choose all check boxes when selecting `Allowed resource types` option while generating SAS. 

- You might need to add IP address of bastion(or local) into firewall settings of azure storage account.

- Go to project root directory in bastion (i.e case-document-metadata-migration). Run below commands. 

    ```
      export AZURE_STORAGE_SAS_TOKEN="<copy SAS value from azure portal>"
      
      Specify correct source directory name if it's different from "./csvs"

      ./uploadToAzureStorage.sh dmstoredocprod './csvs/*'  '.' "$AZURE_STORAGE_SAS_TOKEN"
   ```

- Check all files have uploaded or not using azure portal on the container `hmctsmetadata`.

- From this step onward EM jobs will process CSVs in their end. They would confirm progress of the migration. 

## Samples for verification:
Please use below script to generate few sample records for post migration verification. These samples along with dm_store's
SQL query has to be provide in the jira ticket (Eg: DTSPO-5684).
    
        ./getSampleRecordsForVerification.sh <csvs directory>
        
        Eg: ./getSampleRecordsForVerification.sh sscs_main_csvs
    
This would fetch 3 records from each csv and include them in the SQL.

Run generated SQL query against "evidence" database before EM job started. Ideally it should return empty records.
In case if it returns a record for a documentId which have metadata already then please replace that id in the SQL with some other docId from SAME csv file.

*Note:* Make sure that we should include at least one csv record which doesn't have any metadata from each csv file for the post migration verification.

