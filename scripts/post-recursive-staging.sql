BEGIN;

create index all_events_idx_1 on all_events (case_id, document_id, event_timestamp);
create index all_events_idx_2 on all_events (document_id, event_timestamp,case_id);
\COPY all_events TO 'tmp/allevents.csv' DELIMITER ',' CSV HEADER;

\COPY doc_store_export TO 'tmp/docstoreexport.csv' DELIMITER ',' CSV HEADER;

COMMIT;