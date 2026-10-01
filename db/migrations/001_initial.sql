CREATE SCHEMA feelit;
SET LOCAL search_path = feelit, public;

CREATE TABLE accounts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_subject text NOT NULL UNIQUE CHECK (length(auth_subject) > 0),
    role text NOT NULL CHECK (role IN ('child', 'moderator', 'admin')),
    status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'suspended', 'closed')),
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (id, role)
);
CREATE TABLE child_profiles (
    child_id uuid PRIMARY KEY,
    account_role text NOT NULL DEFAULT 'child' CHECK (account_role = 'child'),
    first_name text,
    age_band text,
    FOREIGN KEY (child_id, account_role) REFERENCES accounts (id, role)
);
CREATE TABLE organizations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    kind text NOT NULL CHECK (kind IN ('school', 'charity'))
);
CREATE TABLE enrollment_verifications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    child_id uuid NOT NULL REFERENCES child_profiles,
    organization_id uuid NOT NULL REFERENCES organizations,
    status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'verified', 'rejected', 'revoked')),
    method text NOT NULL,
    verified_at timestamptz,
    verified_by uuid REFERENCES accounts,
    CHECK (status <> 'verified' OR (verified_at IS NOT NULL AND verified_by IS NOT NULL)),
    UNIQUE (child_id, organization_id)
);
CREATE TABLE consent_records (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    child_id uuid NOT NULL REFERENCES child_profiles,
    kind text NOT NULL,
    policy_version text NOT NULL,
    status text NOT NULL CHECK (status IN ('granted', 'withdrawn')),
    evidence_reference text NOT NULL,
    recorded_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX consent_child ON consent_records (child_id, recorded_at DESC);
CREATE TABLE communities (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL
);
CREATE TABLE community_memberships (
    community_id uuid NOT NULL REFERENCES communities,
    child_id uuid NOT NULL REFERENCES child_profiles,
    joined_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (community_id, child_id)
);
CREATE INDEX memberships_child ON community_memberships (child_id);

CREATE TABLE daily_check_ins (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    child_id uuid NOT NULL REFERENCES child_profiles,
    local_date date NOT NULL,
    timezone text NOT NULL,
    questionnaire_version integer NOT NULL CHECK (questionnaire_version > 0),
    inner_sun smallint NOT NULL CHECK (inner_sun BETWEEN 1 AND 5),
    school_weather smallint NOT NULL CHECK (school_weather BETWEEN 1 AND 5),
    belonging smallint NOT NULL CHECK (belonging BETWEEN 1 AND 5),
    body_calm smallint NOT NULL CHECK (body_calm BETWEEN 1 AND 5),
    hope smallint NOT NULL CHECK (hope BETWEEN 1 AND 5),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (child_id, local_date)
);
CREATE INDEX check_ins_recent ON daily_check_ins (local_date DESC);
CREATE TABLE stickers (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    label text NOT NULL,
    category text NOT NULL CHECK (category IN ('city', 'hobby', 'character')),
    artwork_key text NOT NULL UNIQUE
);
CREATE TABLE profile_stickers (
    child_id uuid NOT NULL REFERENCES child_profiles,
    sticker_id uuid NOT NULL REFERENCES stickers,
    PRIMARY KEY (child_id, sticker_id)
);
CREATE TABLE plants (
    child_id uuid PRIMARY KEY REFERENCES child_profiles,
    appearance jsonb NOT NULL DEFAULT '{}' CHECK (jsonb_typeof(appearance) = 'object')
);
CREATE TABLE growth_events (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    child_id uuid NOT NULL REFERENCES plants,
    source_key text NOT NULL,
    reason text NOT NULL,
    points integer NOT NULL CHECK (points > 0),
    rule_version integer NOT NULL CHECK (rule_version > 0),
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (child_id, source_key)
);

CREATE TABLE media_assets (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    uploaded_by uuid NOT NULL REFERENCES accounts,
    storage_key text NOT NULL UNIQUE,
    mime_type text NOT NULL CHECK (mime_type IN ('image/png', 'image/jpeg', 'image/webp')),
    review_status text NOT NULL DEFAULT 'pending' CHECK (review_status IN ('pending', 'approved', 'rejected')),
    created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE content_items (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id uuid NOT NULL REFERENCES child_profiles,
    kind text NOT NULL CHECK (kind IN ('poll', 'story', 'ending')),
    community_id uuid NOT NULL REFERENCES communities,
    parent_story_id uuid,
    parent_kind text NOT NULL DEFAULT 'story' CHECK (parent_kind = 'story'),
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (id, kind),
    UNIQUE (id, kind, community_id),
    CHECK ((kind = 'ending') = (parent_story_id IS NOT NULL)),
    FOREIGN KEY (parent_story_id, parent_kind, community_id)
        REFERENCES content_items (id, kind, community_id)
);
CREATE INDEX content_author ON content_items (author_id, created_at DESC);
CREATE INDEX content_parent ON content_items (parent_story_id) WHERE parent_story_id IS NOT NULL;
CREATE TABLE content_revisions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    content_id uuid NOT NULL,
    kind text NOT NULL,
    revision_number integer NOT NULL CHECK (revision_number > 0),
    body text NOT NULL CHECK (length(trim(body)) BETWEEN 1 AND 5000),
    review_status text NOT NULL DEFAULT 'draft' CHECK (review_status IN ('draft', 'pending', 'approved', 'rejected')),
    created_at timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (content_id, kind) REFERENCES content_items (id, kind),
    UNIQUE (content_id, revision_number),
    UNIQUE (content_id, id, review_status),
    UNIQUE (content_id, id, kind),
    UNIQUE (id, kind)
);
CREATE TABLE poll_options (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    revision_id uuid NOT NULL,
    kind text NOT NULL DEFAULT 'poll' CHECK (kind = 'poll'),
    position smallint NOT NULL CHECK (position BETWEEN 1 AND 4),
    label text NOT NULL CHECK (length(trim(label)) > 0),
    media_id uuid NOT NULL REFERENCES media_assets,
    FOREIGN KEY (revision_id, kind) REFERENCES content_revisions (id, kind),
    UNIQUE (revision_id, position),
    UNIQUE (revision_id, id)
);
CREATE TABLE publications (
    content_id uuid PRIMARY KEY REFERENCES content_items,
    revision_id uuid NOT NULL,
    review_status text NOT NULL DEFAULT 'approved' CHECK (review_status = 'approved'),
    published_at timestamptz NOT NULL DEFAULT now(),
    FOREIGN KEY (content_id, revision_id, review_status)
        REFERENCES content_revisions (content_id, id, review_status)
);
CREATE INDEX publications_recent ON publications (published_at DESC);

CREATE FUNCTION protect_revision() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        IF OLD.review_status <> 'draft' THEN
            RAISE EXCEPTION 'Reviewed revisions must be retained for reports';
        END IF;
        RETURN OLD;
    END IF;
    IF NEW.id <> OLD.id OR NEW.content_id <> OLD.content_id OR NEW.kind <> OLD.kind
       OR NEW.revision_number <> OLD.revision_number THEN
        RAISE EXCEPTION 'Revision identity cannot change';
    END IF;
    IF OLD.review_status <> 'draft' AND (NEW.body <> OLD.body OR NEW.review_status = 'draft') THEN
        RAISE EXCEPTION 'Submitted content requires a new revision to edit';
    END IF;
    RETURN NEW;
END $$;
CREATE TRIGGER protect_revision BEFORE UPDATE OR DELETE ON content_revisions
    FOR EACH ROW EXECUTE FUNCTION protect_revision();

CREATE FUNCTION protect_poll_options() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE target uuid; state text;
BEGIN
    IF TG_OP = 'UPDATE' AND (NEW.revision_id <> OLD.revision_id OR NEW.id <> OLD.id) THEN
        RAISE EXCEPTION 'Option identity cannot change';
    END IF;
    target := CASE WHEN TG_OP = 'DELETE' THEN OLD.revision_id ELSE NEW.revision_id END;
    SELECT review_status INTO state FROM feelit.content_revisions WHERE id = target FOR UPDATE;
    IF state <> 'draft' THEN
        RAISE EXCEPTION 'Submitted poll options cannot change';
    END IF;
    IF TG_OP = 'DELETE' THEN RETURN OLD; END IF;
    RETURN NEW;
END $$;
CREATE TRIGGER protect_poll_options BEFORE INSERT OR UPDATE OR DELETE ON poll_options
    FOR EACH ROW EXECUTE FUNCTION protect_poll_options();

CREATE FUNCTION validate_publication() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE content_kind text; option_count integer;
BEGIN
    SELECT kind INTO content_kind FROM feelit.content_revisions WHERE id = NEW.revision_id FOR UPDATE;
    IF content_kind = 'poll' THEN
        SELECT count(*) INTO option_count FROM feelit.poll_options WHERE revision_id = NEW.revision_id;
        IF option_count NOT BETWEEN 3 AND 4 THEN
            RAISE EXCEPTION 'A published poll needs 3 or 4 options';
        END IF;
        PERFORM m.id FROM feelit.media_assets m
            JOIN feelit.poll_options o ON o.media_id = m.id
            WHERE o.revision_id = NEW.revision_id ORDER BY m.id FOR SHARE OF m;
        IF EXISTS (SELECT FROM feelit.poll_options o JOIN feelit.media_assets m ON m.id = o.media_id
                   WHERE o.revision_id = NEW.revision_id AND m.review_status <> 'approved') THEN
            RAISE EXCEPTION 'Published images must be approved';
        END IF;
    END IF;
    RETURN NEW;
END $$;
CREATE TRIGGER validate_publication BEFORE INSERT OR UPDATE ON publications
    FOR EACH ROW EXECUTE FUNCTION validate_publication();

CREATE FUNCTION protect_media() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.storage_key <> OLD.storage_key OR NEW.mime_type <> OLD.mime_type THEN
        RAISE EXCEPTION 'Create a new media asset to replace a file';
    END IF;
    IF NEW.review_status <> 'approved' AND EXISTS (
        SELECT FROM feelit.poll_options o JOIN feelit.publications p ON p.revision_id = o.revision_id
        WHERE o.media_id = OLD.id
    ) THEN
        RAISE EXCEPTION 'Unpublish referencing polls before revoking image approval';
    END IF;
    RETURN NEW;
END $$;
CREATE TRIGGER protect_media BEFORE UPDATE ON media_assets
    FOR EACH ROW EXECUTE FUNCTION protect_media();

CREATE TABLE poll_votes (
    poll_id uuid NOT NULL,
    revision_id uuid NOT NULL,
    kind text NOT NULL DEFAULT 'poll' CHECK (kind = 'poll'),
    voter_id uuid NOT NULL REFERENCES child_profiles,
    option_id uuid NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (poll_id, voter_id),
    FOREIGN KEY (poll_id, revision_id, kind) REFERENCES content_revisions (content_id, id, kind),
    FOREIGN KEY (revision_id, option_id) REFERENCES poll_options (revision_id, id)
);
CREATE INDEX votes_option ON poll_votes (revision_id, option_id);
CREATE TABLE content_reports (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id uuid NOT NULL REFERENCES child_profiles,
    revision_id uuid NOT NULL REFERENCES content_revisions,
    reason text NOT NULL CHECK (reason IN ('hurtful', 'personal_information', 'frightening', 'other')),
    status text NOT NULL DEFAULT 'received' CHECK (status IN ('received', 'reviewing', 'resolved')),
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (reporter_id, revision_id)
);
CREATE INDEX reports_queue ON content_reports (status, created_at);
CREATE TABLE moderation_actions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_id uuid NOT NULL REFERENCES accounts,
    revision_id uuid NOT NULL REFERENCES content_revisions,
    action text NOT NULL CHECK (action IN ('approve', 'reject', 'unpublish')),
    internal_reason text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX moderation_revision ON moderation_actions (revision_id, created_at);

CREATE TABLE hug_actions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id uuid NOT NULL REFERENCES child_profiles,
    content_id uuid REFERENCES content_items,
    idempotency_key uuid NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (sender_id, idempotency_key)
);
CREATE TABLE hug_deliveries (
    action_id uuid NOT NULL REFERENCES hug_actions,
    recipient_id uuid NOT NULL REFERENCES child_profiles,
    PRIMARY KEY (action_id, recipient_id)
);
CREATE INDEX hugs_received ON hug_deliveries (recipient_id);
CREATE TABLE gifts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    artwork_key text NOT NULL UNIQUE,
    grown_by uuid NOT NULL REFERENCES child_profiles,
    owner_id uuid NOT NULL REFERENCES child_profiles,
    created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX gifts_owner ON gifts (owner_id);
CREATE TABLE gift_transfers (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    gift_id uuid NOT NULL REFERENCES gifts,
    sender_id uuid NOT NULL REFERENCES child_profiles,
    recipient_id uuid NOT NULL REFERENCES child_profiles,
    idempotency_key uuid NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    CHECK (sender_id <> recipient_id),
    UNIQUE (sender_id, idempotency_key)
);
CREATE INDEX transfers_gift ON gift_transfers (gift_id, created_at);
CREATE FUNCTION transfer_gift(gift uuid, sender uuid, recipient uuid, request_key uuid)
RETURNS uuid LANGUAGE plpgsql AS $$
DECLARE current_owner uuid; previous feelit.gift_transfers; transfer_id uuid;
BEGIN
    SELECT owner_id INTO current_owner FROM feelit.gifts WHERE id = gift FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Gift does not exist'; END IF;
    SELECT * INTO previous FROM feelit.gift_transfers
        WHERE sender_id = sender AND idempotency_key = request_key;
    IF FOUND THEN
        IF previous.gift_id <> gift OR previous.recipient_id <> recipient THEN
            RAISE EXCEPTION 'Idempotency key reused for a different transfer';
        END IF;
        RETURN previous.id;
    END IF;
    IF current_owner <> sender THEN RAISE EXCEPTION 'Sender does not own gift'; END IF;
    INSERT INTO feelit.gift_transfers (gift_id, sender_id, recipient_id, idempotency_key)
        VALUES (gift, sender, recipient, request_key) RETURNING id INTO transfer_id;
    UPDATE feelit.gifts SET owner_id = recipient WHERE id = gift;
    RETURN transfer_id;
END $$;

CREATE TABLE help_resources (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    category text NOT NULL,
    organization_name text NOT NULL,
    country_code text NOT NULL,
    language_code text NOT NULL,
    phone_number text NOT NULL,
    website_url text,
    display_order integer NOT NULL,
    enabled boolean NOT NULL DEFAULT false,
    last_verified_at timestamptz
);
