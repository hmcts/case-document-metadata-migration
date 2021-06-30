BEGIN;

select populate_all_events(cast(:START_RECORD as bigint),cast(:END_RECORD as bigint),:JURISDICTION);

COMMIT;
