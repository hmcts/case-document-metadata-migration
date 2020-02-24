BEGIN;

CREATE TABLE staging (
    id SERIAL PRIMARY KEY,
    case_id BIGINT,
    case_type_id VARCHAR,
    jurisdiction VARCHAR,
    document_id VARCHAR,
    document_url VARCHAR,
    case_created_date TIMESTAMP,
    case_last_modified_date TIMESTAMP,
    migrated BOOLEAN DEFAULT FALSE
);

\COPY staging FROM 'tmp/staging.csv' DELIMITER ',' CSV HEADER;

INSERT INTO staging (case_id, case_type_id, jurisdiction, document_id, document_url, case_created_date, case_last_modified_date)
    SELECT DISTINCT ce.case_data_id AS case_id,
        ce.case_type_id AS case_type_id,
        cd.jurisdiction AS jurisdiction,
        RIGHT(ce.data->dk.document_key->>'document_url', 36) AS document_id,
        ce.data->dk.document_key->>'document_url' AS document_url,
        cd.created_date AS case_created_date,
        cd.last_modified AS case_last_modified_date
    FROM case_data AS cd
    LEFT JOIN case_event AS ce ON cd.id = ce.case_data_id
    LEFT JOIN document_keys AS dk ON cd.jurisdiction = dk.jurisdiction
        AND cd.case_type_id = dk.case_type
    WHERE ce.created_date >= :FROM_DATE
    AND cd.jurisdiction LIKE :JURISDICTION
    AND ce.data->dk.document_key->>'document_url' IS NOT NULL
ON CONFLICT DO NOTHING;

\COPY staging TO 'tmp/staging.csv' DELIMITER ',' CSV HEADER;

COMMIT;
