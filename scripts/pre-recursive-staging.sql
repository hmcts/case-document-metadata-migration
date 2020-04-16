BEGIN;

drop table if exists all_events cascade;
create table all_events(
      jurisdiction VARCHAR,
      case_type_id VARCHAR,
      case_id BIGINT,
      document_id VARCHAR,
      document_url VARCHAR,
      event_timestamp TIMESTAMP,
      doc_present BOOLEAN
);

COMMIT;
