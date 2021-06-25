BEGIN;

-- The problem cases are wherever we have a document which is present in one
-- event for a case, absent in a later event for the same case, then present
-- again in a yet later event for the same case.
drop table if exists problem_cases cascade;
create table problem_cases (
      jurisdiction VARCHAR,
      case_type_id VARCHAR,
      case_reference BIGINT,
      document_id VARCHAR,
      event_timestamp_1 TIMESTAMP,
      event_timestamp_2 TIMESTAMP,
      event_timestamp_3 TIMESTAMP
);
insert into problem_cases (jurisdiction,case_type_id,case_reference,document_id,event_timestamp_1,event_timestamp_2,event_timestamp_3)
select
              cd.jurisdiction as jurisdiction,
              cd.case_type_id as case_type_id,
              e1.case_reference as case_reference,
              e1.document_id as document_id,
              e1.event_timestamp as event_timestamp_1,
              e2.event_timestamp as event_timestamp_2,
              e3.event_timestamp as event_timestamp_3
from all_events e1,
                all_events e2,
              all_events e3,
              case_data cd
where e1.case_id = e2.case_id
and   e1.document_id = e2.document_id
and   e1.event_timestamp < e2.event_timestamp
and   e1.doc_present
and   not e2.doc_present
and   e2.case_id = e3.case_id
and   e2.document_id = e3.document_id
and   e2.event_timestamp < e3.event_timestamp
and   e3.doc_present
and   cd.id = e1.case_id;

--\COPY problem_cases TO 'tmp/problemcases.csv' DELIMITER ',' CSV HEADER;

COMMIT;