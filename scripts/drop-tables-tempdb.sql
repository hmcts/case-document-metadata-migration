DO $$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = current_schema()) LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
DROP TYPE IF EXISTS case_users_audit_action CASCADE;
DROP TYPE IF EXISTS securityclassification CASCADE;
DROP TYPE IF EXISTS significant_item_type CASCADE;
DROP TYPE IF EXISTS datafieldtype CASCADE;
DROP TYPE IF EXISTS definitionstatus CASCADE;
DROP TYPE IF EXISTS displaycontext CASCADE;
DROP TYPE IF EXISTS security_classification CASCADE;
DROP TYPE IF EXISTS webhook_type CASCADE;
END $$;