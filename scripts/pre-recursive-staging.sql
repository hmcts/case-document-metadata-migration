BEGIN;

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
