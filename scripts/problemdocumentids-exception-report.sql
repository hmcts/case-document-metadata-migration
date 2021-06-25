BEGIN;

--The problem document id's present in more than one case
drop table if exists problem_documentids  cascade;
create table problem_documentids  (
      jurisdiction VARCHAR,
      document_id VARCHAR,
      case_type_id_1 VARCHAR,
      case_reference_1 BIGINT,
      event_timestamp_1 TIMESTAMP,
      case_type_id_2 VARCHAR,
      case_reference_2 BIGINT,
      event_timestamp_2 TIMESTAMP
);

insert into problem_documentids (jurisdiction,document_id,case_type_id_1,case_reference_1,event_timestamp_1,case_type_id_2,case_reference_2,event_timestamp_2)
select
              cd.jurisdiction as jurisdiction,
              e1.document_id as document_id,
              e1.case_type_id as case_type_id_1,
              e1.case_reference as case_reference_1,
              e1.event_timestamp as event_timestamp_1,
              e2.case_type_id as case_type_id_2,
              e2.case_reference as case_reference_2,
              e2.event_timestamp as event_timestamp_2
from all_events e1,
              all_events e2,
              case_data cd
where e1.case_id != e2.case_id
and   e1.document_id = e2.document_id
and   e1.doc_present
and   e2.doc_present
and   cd.id = e1.case_id;

--\COPY problem_documentids TO 'tmp/problemdocumentids.csv' DELIMITER ',' CSV HEADER;

COMMIT;