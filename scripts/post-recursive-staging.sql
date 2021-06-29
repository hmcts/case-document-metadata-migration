BEGIN;

drop table if exists doc_store_export cascade;
create table doc_store_export(
      jurisdiction VARCHAR,
      case_type_id VARCHAR,
      case_reference BIGINT,
      case_id BIGINT,
      document_id VARCHAR,
      event_timestamp TIMESTAMP
);

create index all_events_idx_1 on all_events (case_id, document_id, event_timestamp);
create index all_events_idx_2 on all_events (document_id, event_timestamp,case_id);

insert into doc_store_export(jurisdiction,case_type_id,case_reference,case_id,document_id,event_timestamp)
    SELECT ae1.jurisdiction,ae1.case_type_id,ae1.case_reference,ae1.case_id,ae1.document_id,ae1.event_timestamp
      FROM all_events ae1
      inner join
      (SELECT document_id, max(earlist_in_case) as latest_of_earlists
        FROM
           (
            SELECT document_id, case_id, min(event_timestamp) as earlist_in_case
            FROM all_events WHERE doc_present GROUP BY document_id,case_id
            )
        deic GROUP BY document_id)
      ae2 on ae2.document_id = ae1.document_id and ae1.event_timestamp = ae2.latest_of_earlists
    ORDER BY case_id,document_id, event_timestamp;

COMMIT;