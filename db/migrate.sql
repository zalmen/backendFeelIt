\set ON_ERROR_STOP on
BEGIN;
SELECT pg_advisory_xact_lock(72418001);
CREATE TABLE IF NOT EXISTS public.schema_migrations (
    version integer PRIMARY KEY,
    applied_at timestamptz NOT NULL DEFAULT now()
);
SELECT NOT EXISTS (SELECT FROM public.schema_migrations WHERE version = 1) AS apply_001 \gset
\if :apply_001
\ir migrations/001_initial.sql
INSERT INTO public.schema_migrations (version) VALUES (1);
\endif
COMMIT;
