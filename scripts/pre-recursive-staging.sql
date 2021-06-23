BEGIN;

drop table if exists doc_events cascade;
create table doc_events(
      jurisdiction VARCHAR,
      case_type_id VARCHAR,
      case_reference BIGINT,
      case_id BIGINT,
      event_timestamp TIMESTAMP,
      document_id VARCHAR
);

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

COMMIT;
