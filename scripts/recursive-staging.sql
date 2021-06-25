BEGIN;

-- Recursive view extracts metadata and key/value pairs throughout the JSON tree,
-- then filters for just the document_binary_url keys, stripping
-- the URLs to leave just the document ID (not very clever regexes here).
insert into doc_events
with recursive foo as
(
              select jurisdiction, case_type_id, case_reference, case_id, event_timestamp, (entry).key as k, (entry).value as v
              from
              (
                           select cd.jurisdiction as jurisdiction, cd.case_type_id as case_type_id , cd.reference as case_reference, ce.case_data_id as case_id,ce.created_date as event_timestamp, jsonb_each(ce.data) as entry
						   from case_data as cd, case_event AS ce WHERE cd.id = ce.case_data_id and cd.id between :START_RECORD and :END_RECORD and cd.jurisdiction = :JURISDICTION
              ) e
              union
              select jurisdiction, case_type_id, case_reference, case_id, event_timestamp, (entry)."key" as k, (entry)."value" as v
              from
              (
                           select jurisdiction, case_type_id, case_reference, case_id, event_timestamp, normalize_jsonb(v) as entry
                           from foo where v::text like '%document_binary_url%'
              ) e
)
select jurisdiction, case_type_id, case_reference, case_id, event_timestamp, k, replace(regexp_replace(replace(v::text,'/binary',''),'.*/',''),'"','') as document_id, v::text as document_url
from foo
where k = 'document_binary_url';

COMMIT;
