create or replace function create_csvs(fileLocation text) returns void as $$
declare
    currJurisdiction text;
    fileName text;
    qry text;
begin
    FOR currJurisdiction IN select distinct jurisdiction from doc_store_export
        LOOP
            filename := CONCAT(fileLocation, currJurisdiction, '.csv');

            qry := FORMAT('COPY (Select case_reference, case_type_id, jurisdiction, document_id from doc_store_export where jurisdiction = %L) to %L DELIMITER '','' CSV HEADER', currJurisdiction, fileName);
            EXECUTE qry;
        END LOOP;
end;
$$ language plpgsql;

select create_csvs(:FILENAME)