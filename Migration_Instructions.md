# Migration Instructions

Follow below steps to run metadata migrations from Bastion (or local) against COPY of data-store database. 
Please refer [pre-requisites](README.md) if required.

##Part 1:
 This part executes relevant scripts to find out all case documents for a given jurisdiction and populate them into staging tables. (all_events and doc_store_export). Depending on number of cases in a jurisdiction it might take 2 - 5 hours to complete. 

- Log onto bastion non-prod

    ```bash
      ssh bastion-dev-nonprod
    ```

- Checkout `sscs_draft_cases` migration scripts branch. 
    ```
      git clone https://github.com/hmcts/case-document-metadata-migration.git
            
      cd case-document-metadata-migration
  
      git checkout sscs_draft_cases     
    ``` 
- Configure the database properties to be used

  ```
    vi databaseConfiguration.txt  

    source set-environment-variables.sh
  ```

- Generate Document Id’s from case data using recursive method.(Eg: for SSCS)

   ```
    nohup ./migration-runner.sh -o exportrecursivedocumentids -j SSCS >> sscs_draft_cases_out.txt &
   ```
Depending on number of cases in a jurisdiction it might take 2 - 5 hours to complete above step. Progress can be checked using below command.

   ```
    tail -100f sscs_draft_cases_out.txt
   ```

Once above step has finished, run below command to generate CVSs from staging table (doc_store_export). 

- Generate csv files for a jurisdiction. ((Eg: for SSCS)
   ```
    nohup ./migration-runner.sh -o generatecsvs -j SSCS >> sscs_draft_cases_csv_out.txt &
  ```

## Part 2:  
This part needs to execute in co-ordination with EM team to upload generated CVSs into azure storage container. 

    Note: EM team must set metadata “Override” flag as FALSE in prod.

- Get azure storage SAS token from the portal for the account `dmstoredocprod`. Choose all check boxes when selecting `Allowed resource types` option while generating SAS. 

- You might need to add IP address of bastion(or local) into firewall settings of azure storage account.

- Go to project root directory in bastion (i.e case-document-metadata-migration). Run below commands. 

    ```
      export AZURE_STORAGE_SAS_TOKEN="<copy SAS value from azure portal>"
        
      ./uploadToAzureStorage.sh dmstoredocprod './csvs/*'  '.' "$AZURE_STORAGE_SAS_TOKEN"
        
      # backup uploaded csvs into another directory. 
      mv csvs sscs_draft_cases_csvs

   ```

- Check all files have uploaded or not using azure portal on the container `hmctsmetadata`.

- From this step onward EM jobs will process CSVs in their end. They would confirm progress of the migration. 


