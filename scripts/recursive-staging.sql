BEGIN;

-- Using V12 new feature "jsonb_path_query" to extract all occurrences of document_binary_url in the json document,
-- the URLs to leave just the document ID (not very clever regexes here).
insert into doc_events
select jurisdiction, case_type_id, case_reference, case_id, event_timestamp, replace(regexp_replace(replace(document_url::text,'/binary',''),'.*/',''),'"','') as document_id, document_url
from
(
  select cd.jurisdiction as jurisdiction, cd.case_type_id as case_type_id , cd.reference as case_reference,
  ce.case_data_id as case_id,ce.created_date as event_timestamp, jsonb_path_query(ce.data, '$.**.document_binary_url') as document_url
from case_data as cd, case_event AS ce WHERE cd.id = ce.case_data_id and cd.id between :START_RECORD and :END_RECORD
) raw_urls;

COMMIT;
