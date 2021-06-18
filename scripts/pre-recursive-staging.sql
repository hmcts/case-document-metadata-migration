BEGIN;

drop table if exists doc_events cascade;
create table doc_events(
      jurisdiction VARCHAR,
      case_type_id VARCHAR,
      case_reference BIGINT,
      case_id BIGINT,
      event_timestamp TIMESTAMP,
      document_id VARCHAR,
      document_url VARCHAR
);

COMMIT;
