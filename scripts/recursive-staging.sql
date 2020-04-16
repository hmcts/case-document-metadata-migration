BEGIN;
drop type if exists normalized_jsonb cascade;
-- Type to allow us to treat objects and arrays in the same way.
-- Arrays are treated as objects with all keys set to '_'.
create type normalized_jsonb as ("key" text, "value" jsonb);

-- Returns key/value mappings for objects and arrays, using
-- '_' for all keys for array items.
create or replace function normalize_jsonb(item jsonb)
returns setof normalized_jsonb as
$$
begin
              if jsonb_typeof(item) = 'object' then
                           return query select j.* from jsonb_each(item) j;
              elsif jsonb_typeof(item) = 'array' then
                           return query select '_'::text as "key", "value" from jsonb_array_elements(item);
              end if;
end;
$$ language plpgsql;

-- Recursive view extracts metadata and key/value pairs throughout the JSON tree,
-- then filters for just the document_binary_url keys, stripping
-- the URLs to leave just the document ID (not very clever regexes here).
drop table if exists doc_events cascade;
create table doc_events as
with recursive foo as
(
              select jurisdiction, case_type_id, case_id, event_timestamp, (entry).key as k, (entry).value as v
              from
              (
                           select cd.jurisdiction as jurisdiction, ce.case_type_id as case_type_id , ce.case_data_id as case_id, ce.created_date as event_timestamp, jsonb_each(ce.data) as entry
						   from case_data as cd LEFT JOIN case_event AS ce ON cd.id = ce.case_data_id and cd.id between :START_RECORD and :END_RECORD
              ) e
              union
              select jurisdiction, case_type_id, case_id, event_timestamp, (entry)."key" as k, (entry)."value" as v
              from
              (
                           select jurisdiction, case_type_id, case_id, event_timestamp, normalize_jsonb(v) as entry
                           from foo
              ) e
)
select jurisdiction, case_type_id, case_id, event_timestamp, k, replace(regexp_replace(replace(v::text,'/binary',''),'.*/',''),'"','') as document_id, v::text as document_url
from foo
where k = 'document_binary_url';

create index doc_events_idx on doc_events (case_id, document_id, event_timestamp);


-- Every possible combination of document and event for the same case, with an
-- indicator of whether the document exists on the case JSON for the event.
-- If a case has 5 unique documents and 10 events, we should get 50 rows.
-- Each row will have a doc_present column indicating whether the given document
-- was in the JSON for the given event.
insert into all_events(jurisdiction,case_type_id,case_id,document_id,document_url,event_timestamp,doc_present)
              select
			  cd.jurisdiction as jurisdiction,
			  cd.case_type_id as case_type_id,
              cd.case_id as case_id,
              cd.document_id as document_id,
              cd.document_url as document_url,
              ce.created_date as event_timestamp,
              (exists (select 1 from doc_events de
              where de.case_id = cd.case_id
              and de.document_id = cd.document_id
              and de.event_timestamp = ce.created_date)) as doc_present
from case_event ce,
              (select distinct jurisdiction,case_type_id,case_id, document_id,document_url
                from doc_events) cd
                where ce.case_data_id = cd.case_id;

--select * from problem_cases;
--select * from all_events;

COMMIT;
