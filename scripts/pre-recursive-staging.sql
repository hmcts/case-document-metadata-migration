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

drop table if exists all_events cascade;
create table all_events(
      jurisdiction VARCHAR,
      case_type_id VARCHAR,
      case_reference BIGINT,
      case_id BIGINT,
      case_event_id BIGINT,
      document_id VARCHAR,
      event_timestamp TIMESTAMP,
      doc_present BOOLEAN
);

drop table if exists doc_events cascade;
create table doc_events(
      jurisdiction VARCHAR,
      case_type_id VARCHAR,
      case_reference BIGINT,
      case_id BIGINT,
      event_timestamp TIMESTAMP,
      document_id VARCHAR
);

-- Using V12 new feature "jsonb_path_query" to extract all occurrences of document_binary_url in the json document,
-- the URLs to leave just the document ID (not very clever regexes here).

create or replace function generate_doc_events(startCase bigint , endCase bigint, jurisidction text) returns void as $$
    begin
        create temporary table batch_doc_events as(
        select jurisdiction, case_type_id, case_reference, case_id, event_timestamp, replace(regexp_replace(replace(document_url::text,'/binary',''),'.*/',''),'"','') as document_id
        from
        (
          select cd.jurisdiction as jurisdiction, cd.case_type_id as case_type_id , cd.reference as case_reference,
          ce.case_data_id as case_id,ce.created_date as event_timestamp, jsonb_path_query(ce.data, '$.**.document_binary_url') as document_url
        from case_data as cd, case_event AS ce WHERE cd.id = ce.case_data_id and cd.id between $1 and $2 and cd.jurisdiction = $3
        ) raw_urls);

        -- Every possible combination of document and event for the same case, with an
        -- indicator of whether the document exists on the case JSON for the event.
        -- If a case has 5 unique documents and 10 events, we should get 50 rows.
        -- Each row will have a doc_present column indicating whether the given document
        -- was in the JSON for the given event.
        insert into all_events(jurisdiction,case_type_id,case_reference,case_id,case_event_id,document_id,event_timestamp,doc_present)
                      select
                      cd.jurisdiction as jurisdiction,
                      cd.case_type_id as case_type_id,
                      cd.case_reference as case_reference,
                      cd.case_id as case_id,
                      ce.id as case_event_id,
                      cd.document_id as document_id,
                      ce.created_date as event_timestamp,
                      (exists (select 1 from batch_doc_events de
                      where de.case_id = cd.case_id
                      and de.document_id = cd.document_id
                      and de.event_timestamp = ce.created_date)) as doc_present
        from case_event ce,
                      (select distinct jurisdiction,case_type_id,case_reference,case_id,document_id
                        from batch_doc_events) cd
                        where ce.case_data_id = cd.case_id;

        -- insert each batch of doc events into main doc_events table.
        insert into doc_events (jurisdiction, case_type_id, case_reference, case_id, event_timestamp, document_id)
            select jurisdiction, case_type_id, case_reference, case_id, event_timestamp, document_id
            from batch_doc_events;

    end;
$$ language plpgsql;

COMMIT;
