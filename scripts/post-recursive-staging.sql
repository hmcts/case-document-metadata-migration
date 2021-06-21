BEGIN;

create index doc_events_idx on doc_events (case_id, document_id, event_timestamp);

drop table if exists doc_store_export cascade;
create table doc_store_export(
      jurisdiction VARCHAR,
      case_type_id VARCHAR,
      case_reference BIGINT,
      document_id VARCHAR,
      event_timestamp TIMESTAMP
);

insert into doc_store_export(jurisdiction,case_type_id,case_reference,document_id,event_timestamp)
        select ae1.jurisdiction,ae1.case_type_id,ae1.case_reference,ae1.document_id,ae1.event_timestamp
        from doc_events ae1
        inner join
        (
          SELECT document_id, max(event_timestamp) as mts
          FROM doc_events
          GROUP BY document_id
        ) ae2 on ae2.document_id = ae1.document_id and ae1.event_timestamp = ae2.mts
        ORDER BY case_id,document_id, event_timestamp;

COMMIT;