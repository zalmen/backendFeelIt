\set ON_ERROR_STOP on
BEGIN;
SET LOCAL search_path = feelit, public;
CREATE FUNCTION pg_temp.expect_error(statement text, expected_state text) RETURNS void
LANGUAGE plpgsql AS $$
BEGIN
    BEGIN
        EXECUTE statement;
    EXCEPTION WHEN OTHERS THEN
        IF SQLSTATE <> expected_state THEN RAISE; END IF;
        RETURN;
    END;
    RAISE EXCEPTION 'Expected SQLSTATE % for %', expected_state, statement;
END $$;
CREATE FUNCTION pg_temp.assert_true(value boolean) RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    IF value IS DISTINCT FROM true THEN RAISE EXCEPTION 'Assertion failed'; END IF;
END $$;

INSERT INTO accounts (auth_subject, role) VALUES ('test-child-a', 'child') RETURNING id AS child_a \gset
INSERT INTO accounts (auth_subject, role) VALUES ('test-child-b', 'child') RETURNING id AS child_b \gset
INSERT INTO accounts (auth_subject, role) VALUES ('test-staff', 'moderator') RETURNING id AS staff \gset
INSERT INTO child_profiles (child_id) VALUES (:'child_a'), (:'child_b');
SELECT pg_temp.expect_error(format('INSERT INTO child_profiles (child_id) VALUES (%L)', :'staff'), '23503');
INSERT INTO daily_check_ins (child_id, local_date, timezone, questionnaire_version, inner_sun, school_weather, belonging, body_calm, hope)
VALUES (:'child_a', '2026-10-01', 'Asia/Jerusalem', 1, 3, 3, 3, 3, 3);
SELECT pg_temp.expect_error(format('INSERT INTO daily_check_ins (child_id, local_date, timezone, questionnaire_version, inner_sun, school_weather, belonging, body_calm, hope) VALUES (%L, ''2026-10-01'', ''Asia/Jerusalem'', 1, 3, 3, 3, 3, 3)', :'child_a'), '23505');
SELECT pg_temp.expect_error('UPDATE daily_check_ins SET hope = 6', '23514');

INSERT INTO communities (name) VALUES ('Test community') RETURNING id AS community \gset
INSERT INTO content_items (author_id, kind, community_id) VALUES (:'child_a', 'poll', :'community') RETURNING id AS poll \gset
INSERT INTO content_items (author_id, kind, community_id) VALUES (:'child_b', 'story', :'community') RETURNING id AS story \gset
SELECT pg_temp.expect_error(format('INSERT INTO content_items (author_id, kind, community_id, parent_story_id) VALUES (%L, ''ending'', %L, %L)', :'child_b', :'community', :'poll'), '23503');
INSERT INTO content_items (author_id, kind, community_id, parent_story_id) VALUES (:'child_a', 'ending', :'community', :'story');
INSERT INTO content_revisions (content_id, kind, revision_number, body) VALUES (:'poll', 'poll', 1, 'Which activity?') RETURNING id AS revision \gset
SELECT pg_temp.expect_error(format('INSERT INTO publications (content_id, revision_id) VALUES (%L, %L)', :'story', :'revision'), 'P0001');
INSERT INTO media_assets (uploaded_by, storage_key, mime_type, review_status) VALUES (:'staff', 'test/artwork', 'image/png', 'approved') RETURNING id AS media \gset
INSERT INTO poll_options (revision_id, position, label, media_id)
SELECT :'revision', n, 'Option ' || n, :'media' FROM generate_series(1, 3) n;
SELECT id AS option_a FROM poll_options WHERE revision_id = :'revision' AND position = 1 \gset
SELECT pg_temp.expect_error(format('INSERT INTO publications (content_id, revision_id) VALUES (%L, %L)', :'poll', :'revision'), '23503');
UPDATE content_revisions SET review_status = 'approved' WHERE id = :'revision';
INSERT INTO publications (content_id, revision_id) VALUES (:'poll', :'revision');
SELECT pg_temp.expect_error(format('INSERT INTO publications (content_id, revision_id) VALUES (%L, %L)', :'story', :'revision'), '23503');
SELECT pg_temp.expect_error(format('UPDATE media_assets SET review_status = ''rejected'' WHERE id = %L', :'media'), 'P0001');
SELECT pg_temp.expect_error(format('UPDATE content_revisions SET body = ''Changed'' WHERE id = %L', :'revision'), 'P0001');
SELECT pg_temp.expect_error(format('DELETE FROM poll_options WHERE id = %L', :'option_a'), 'P0001');
SELECT pg_temp.expect_error(format('UPDATE poll_options SET label = ''Changed'' WHERE id = %L', :'option_a'), 'P0001');
SELECT pg_temp.expect_error(format('UPDATE content_revisions SET review_status = ''rejected'' WHERE id = %L', :'revision'), '23503');
INSERT INTO poll_votes (poll_id, revision_id, voter_id, option_id) VALUES (:'poll', :'revision', :'child_b', :'option_a');
SELECT pg_temp.expect_error(format('INSERT INTO poll_votes (poll_id, revision_id, voter_id, option_id) VALUES (%L, %L, %L, %L)', :'poll', :'revision', :'child_b', :'option_a'), '23505');
SELECT pg_temp.expect_error(format('INSERT INTO poll_votes (poll_id, revision_id, voter_id, option_id) VALUES (%L, %L, %L, gen_random_uuid())', :'poll', :'revision', :'child_a'), '23503');
INSERT INTO content_items (author_id, kind, community_id) VALUES (:'child_a', 'poll', :'community') RETURNING id AS other_poll \gset
INSERT INTO content_revisions (content_id, kind, revision_number, body) VALUES (:'other_poll', 'poll', 1, 'Other poll') RETURNING id AS other_revision \gset
INSERT INTO poll_options (revision_id, position, label, media_id) VALUES (:'other_revision', 1, 'Other option', :'media') RETURNING id AS other_option \gset
SELECT pg_temp.expect_error(format('INSERT INTO poll_votes (poll_id, revision_id, voter_id, option_id) VALUES (%L, %L, %L, %L)', :'poll', :'revision', :'child_a', :'other_option'), '23503');
INSERT INTO content_reports (reporter_id, revision_id, reason) VALUES (:'child_b', :'revision', 'hurtful');
DELETE FROM publications WHERE content_id = :'poll';
UPDATE media_assets SET review_status = 'rejected' WHERE id = :'media';
SELECT pg_temp.expect_error(format('INSERT INTO publications (content_id, revision_id) VALUES (%L, %L)', :'poll', :'revision'), 'P0001');
UPDATE content_revisions SET review_status = 'rejected' WHERE id = :'revision';
SELECT pg_temp.expect_error(format('DELETE FROM content_revisions WHERE id = %L', :'revision'), 'P0001');

INSERT INTO plants (child_id) VALUES (:'child_a');
INSERT INTO growth_events (child_id, source_key, reason, points, rule_version) VALUES (:'child_a', 'check-in:test', 'check_in', 1, 1);
SELECT pg_temp.expect_error(format('INSERT INTO growth_events (child_id, source_key, reason, points, rule_version) VALUES (%L, ''check-in:test'', ''check_in'', 1, 1)', :'child_a'), '23505');
INSERT INTO hug_actions (sender_id, idempotency_key) VALUES (:'child_a', gen_random_uuid()) RETURNING id AS hug \gset
INSERT INTO hug_deliveries VALUES (:'hug', :'child_b');
SELECT pg_temp.expect_error(format('INSERT INTO hug_deliveries VALUES (%L, %L)', :'hug', :'child_b'), '23505');
INSERT INTO gifts (artwork_key, grown_by, owner_id) VALUES ('test/unique-gift', :'child_a', :'child_a') RETURNING id AS gift \gset
SELECT gen_random_uuid() AS request_key \gset
SELECT transfer_gift(:'gift', :'child_a', :'child_b', :'request_key') AS transfer \gset
SELECT pg_temp.assert_true(transfer_gift(:'gift', :'child_a', :'child_b', :'request_key') = :'transfer');
SELECT pg_temp.expect_error(format('SELECT transfer_gift(%L, %L, %L, gen_random_uuid())', :'gift', :'child_a', :'child_b'), 'P0001');
SELECT pg_temp.expect_error(format('SELECT transfer_gift(%L, %L, %L, %L)', :'gift', :'child_a', :'child_a', :'request_key'), 'P0001');
SELECT pg_temp.expect_error(format('SELECT transfer_gift(%L, %L, %L, gen_random_uuid())', :'gift', :'child_b', :'child_b'), '23514');
SELECT pg_temp.assert_true((SELECT owner_id = :'child_b' FROM gifts WHERE id = :'gift'));
SELECT pg_temp.assert_true((SELECT count(*) = 1 FROM gift_transfers WHERE gift_id = :'gift'));
ROLLBACK;
\echo 'Data model checks passed; test data rolled back.'
