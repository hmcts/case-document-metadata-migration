BEGIN;

create index doc_events_distinct_idx on doc_events (jurisdiction,case_type_id,case_reference,case_id,document_id);

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

-- Every possible combination of document and event for the same case, with an
-- indicator of whether the document exists on the case JSON for the event.
-- If a case has 5 unique documents and 10 events, we should get 50 rows.
-- Each row will have a doc_present column indicating whether the given document
-- was in the JSON for the given event.
insert into all_events(jurisdiction,case_type_id,case_reference,case_id,case_event_id,document_id,event_timestamp,doc_present)
              select
			  cd.jurisdiction as jurisdiction,
			  cd.case_type_id as case_type_id,
              cd.case_reference as case_reference,
              cd.case_id as case_id,
              ce.id as case_event_id,
              cd.document_id as document_id,
              ce.created_date as event_timestamp,
              (exists (select 1 from doc_events de
              where de.case_id = cd.case_id
              and de.document_id = cd.document_id
              and de.event_timestamp = ce.created_date)) as doc_present
from case_event ce,
              (select distinct jurisdiction,case_type_id,case_reference,case_id,document_id
                from doc_events) cd
                where ce.case_data_id = cd.case_id;

create index all_events_idx_1 on all_events (case_id, document_id, event_timestamp);
create index all_events_idx_2 on all_events (document_id, event_timestamp,case_id);

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


\COPY problem_cases TO 'tmp/problemcases.csv' DELIMITER ',' CSV HEADER;
\COPY problem_documentids TO 'tmp/problemdocumentids.csv' DELIMITER ',' CSV HEADER;

COMMIT;