BEGIN;

CREATE TABLE document_keys (
    jurisdiction VARCHAR,
    case_type VARCHAR,
    document_key VARCHAR
);

INSERT INTO document_keys
    SELECT DISTINCT j.reference AS jurisdiction,
        ct.reference AS case_type,
        cf.reference AS document_key
    FROM case_field AS cf
    LEFT JOIN case_type AS ct ON cf.case_type_id = ct.id
    LEFT JOIN jurisdiction AS j ON ct.jurisdiction_id = j.id
    LEFT JOIN field_type AS ft ON cf.field_type_id = ft.id
    WHERE ft.reference = 'Document'
    AND j.reference LIKE :JURISDICTION;

COMMIT;
