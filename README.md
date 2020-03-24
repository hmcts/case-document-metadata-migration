# Case document metadata migration

### Usage
$ ./migration-runner -e local

Execute the below mentioned commands to create a Temporary DB User(Check  with Allu)

create database ccd_definition_temp;
create database ccd_data_temp;
CREATE ROLE ccdtemp WITH
  LOGIN
  SUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE
  REPLICATION;
 
 ALTER USER ccdtemp WITH PASSWORD 'ccdtemp';
  
 commit;