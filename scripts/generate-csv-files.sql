BEGIN;

\COPY doc_store_export(case_reference, case_type_id, jurisdiction, document_id) TO PROGRAM 'split -l 100000' DELIMITER ',' CSV;

--\COPY doc_store_export(case_reference, case_type_id, jurisdiction, document_id) TO 'tmp/docstoreexport.csv' DELIMITER ',' CSV HEADER;
--\COPY all_events TO 'tmp/allevents.csv' DELIMITER ',' CSV HEADER;
--\COPY problem_documentids TO 'tmp/problemdocumentids.csv' DELIMITER ',' CSV HEADER;

COMMIT;
