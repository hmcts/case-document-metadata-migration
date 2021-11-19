alter table all_events rename to all_events_divorce;
alter table doc_store_export to rename doc_store_export_divorce;
alter table problem_documentids rename to problem_documentids_divorce;

alter index all_events_idx_1 rename to all_events_idx_1_divorce;
alter index all_events_idx_2 rename to all_events_idx_2_divorce;

alter index problem_documentids_document_id_idx rename to problem_documentids_document_id_idx_divorce;
alter index problem_documentids_case_type_ids_idx rename to problem_documentids_case_type_ids_idx_divorce;

