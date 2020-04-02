BEGIN;
\COPY recursive_staging FROM 'tmp/recursive-staging.csv' DELIMITER ',' CSV HEADER;

\COPY recursive_staging TO 'tmp/recursive-staging.csv' DELIMITER ',' CSV HEADER;

COMMIT;