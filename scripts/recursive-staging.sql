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
-- then filters for just the document_url and document_binary_url keys, stripping
-- the URLs to leave just the document ID (not very clever regexes here).
drop view if exists all_documents cascade;
create view all_documents as
with recursive foo as
(
	select jurisdiction, case_type, case_id, event_timestamp, (entry).key as k, (entry).value as v
	from
	(
		select cd.jurisdiction as jurisdiction, ce.case_type_id as case_type , ce.case_data_id as case_id, ce.created_date as event_timestamp, jsonb_each(ce.data) as entry
		from case_data as cd LEFT JOIN case_event AS ce ON cd.id = ce.case_data_id and cd.id between :START_RECORD and :END_RECORD
	) e
	union
	select jurisdiction, case_type, case_id, event_timestamp, (entry)."key" as k, (entry)."value" as v
	from
	(
		select jurisdiction, case_type, case_id, event_timestamp, normalize_jsonb(v) as entry
		from foo
	) e
)
select
	jurisdiction, case_type, case_id, event_timestamp, k,
	replace(regexp_replace(replace(v::text,'/binary',''),'.*/',''),'"','') as document_id
from foo
where k = 'document_url'
or    k = 'document_binary_url';

--
-- We should see documents 1-6 for JURISDICTIONA, and A-E + 2 for JURISDICTIONB.
-- Multiple entries in each case, since we have binary and normal URLs.
--
--\COPY recursive_staging FROM 'tmp/recursive-staging.csv' DELIMITER ',' CSV HEADER;
INSERT INTO recursive_staging (case_id, case_type_id, jurisdiction, document_id, event_timestamp)
    SELECT case_id , case_type as case_type_id , jurisdiction, document_id,event_timestamp
    from all_documents
    where all_documents.k='document_url'
ON CONFLICT DO NOTHING;

--\COPY recursive_staging TO 'tmp/recursive-staging.csv' DELIMITER ',' CSV HEADER;

COMMIT;

--select * from all_documents;
--select * from recursive_staging;

--
-- We should see doc2 listed under JURISDICTIONB, since that's the most recent
-- entry for that document.
--
--select * from latest_document_metadata;