BEGIN;

create index all_events_idx on all_events (case_id, document_id, event_timestamp);


\COPY all_events TO 'tmp/allevents.csv' DELIMITER ',' CSV HEADER;

COMMIT;