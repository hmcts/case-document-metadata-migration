BEGIN;

-- try extracting into multiple csv one for each caseType.
\COPY doc_store_export(case_reference, case_type_id, jurisdiction, document_id, case_id, event_timestamp) TO 'tmp/docstoreexport.csv' DELIMITER ',' CSV HEADER;

\COPY all_events TO 'tmp/allevents.csv' DELIMITER ',' CSV HEADER;

\COPY problem_cases TO 'tmp/problemcases.csv' DELIMITER ',' CSV HEADER;
\COPY problem_documentids TO 'tmp/problemdocumentids.csv' DELIMITER ',' CSV HEADER;

COMMIT;
