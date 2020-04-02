BEGIN;

drop table if exists recursive_staging cascade;
CREATE TABLE recursive_staging (
    id SERIAL PRIMARY KEY,
    case_id BIGINT,
    case_type_id VARCHAR,
    jurisdiction VARCHAR,
    document_id VARCHAR,
    event_timestamp TIMESTAMP
);

COMMIT;