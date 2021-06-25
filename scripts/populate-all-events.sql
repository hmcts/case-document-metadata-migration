BEGIN;

create index doc_events_jurisdiction_idx on doc_events (jurisdiction);
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
                from doc_events where jurisdiction = 'SSCS') cd
                where ce.case_data_id = cd.case_id;

create index all_events_idx_1 on all_events (case_id, document_id, event_timestamp);
create index all_events_idx_2 on all_events (document_id, event_timestamp,case_id);

COMMIT;