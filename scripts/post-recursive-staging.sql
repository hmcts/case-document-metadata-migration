BEGIN;

create index all_events_idx_1 on all_events (case_id, document_id, event_timestamp);
create index all_events_idx_2 on all_events (document_id, event_timestamp,case_id);
\COPY all_events TO 'tmp/allevents.csv' DELIMITER ',' CSV HEADER;

--insert into doc_store_export(jurisdiction,case_type_id,case_id,case_event_id,document_id,document_url,event_timestamp,doc_present)
--        select ae1.jurisdiction,ae1.case_type_id,ae1.case_id,ae1.case_event_id,ae1.document_id,ae1.document_url,ae1.event_timestamp,ae1.doc_present
--        from all_events ae1
--        inner join
--        (
 --         SELECT document_id, max(event_timestamp) as mts
 --         FROM all_events where doc_present
 ---         GROUP BY document_id
--        ) ae2 on ae2.document_id = ae1.document_id and ae1.event_timestamp = ae2.mts
 --       ORDER BY case_id,case_event_id,document_id, event_timestamp;

\COPY doc_store_export TO 'tmp/docstoreexport.csv' DELIMITER ',' CSV HEADER;

COMMIT;