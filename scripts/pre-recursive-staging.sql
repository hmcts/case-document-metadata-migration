BEGIN;

drop table if exists all_events cascade;
create table all_events(
      id SERIAL PRIMARY KEY,
      jurisdiction VARCHAR,
      case_type_id VARCHAR,
      case_id BIGINT,
      document_id VARCHAR,
      document_url VARCHAR,
      event_timestamp TIMESTAMP,
      doc_present BOOLEAN
);

drop table if exists problem_cases cascade;
create table problem_cases (
      id SERIAL PRIMARY KEY,
      jurisdiction VARCHAR,
      case_type_id VARCHAR,
      case_id BIGINT,
      document_id VARCHAR,
      document_url VARCHAR,
      event_timestamp_1 TIMESTAMP,
      event_timestamp_2 TIMESTAMP,
      event_timestamp_3 TIMESTAMP
);
COMMIT;
