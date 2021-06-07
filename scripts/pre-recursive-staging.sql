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
      document_url VARCHAR,
      event_timestamp TIMESTAMP,
      doc_present BOOLEAN
);

drop table if exists doc_store_export cascade;
create table doc_store_export(
      jurisdiction VARCHAR,
      case_type_id VARCHAR,
      case_reference BIGINT,
      document_id VARCHAR,
      document_url VARCHAR,
      event_timestamp TIMESTAMP
);

COMMIT;
