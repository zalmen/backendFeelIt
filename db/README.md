# FeelIt data model

PostgreSQL 18 foundation for the [screen mockups](../README.md#מסכים).
This PR creates the database, migrations and integrity tests. The existing
MongoDB chat prototype in `server/` still runs separately; no routes or existing
data are migrated. The new app's APIs will use this schema.

## Run locally

```sh
docker compose up -d --wait postgres
docker compose run --rm db-tools
docker compose run --rm db-tools -f /db/tests.sql
```

Host connection: `postgresql://feelit:feelit-local-only@localhost:5433/feelit`.
Set `FEELIT_DB_PORT` if needed. Credentials are for local development only;
the database port binds to localhost. Data persists in a Docker volume.
`docker compose down` stops it without deleting data.

Migrations run explicitly, in a transaction, under an advisory lock. Re-running
the runner skips recorded versions. Add numbered SQL files and a corresponding
version block to `migrate.sql`; never edit an applied migration. No automatic
rollback is provided: use a forward migration, or restore a backup.

## The model at a glance

All product tables live in the `feelit` schema. IDs are UUIDs; timestamps include
time zones. Foreign keys restrict deletion unless references are removed explicitly.

| Screen / concern | Tables | Meaning |
|---|---|---|
| Joining | `accounts`, `child_profiles` | Login identity and account role are separate from the child's minimal profile. `auth_subject` is an opaque identity-provider identifier; no password or email is stored here. |
| Verification | `organizations`, `enrollment_verifications`, `consent_records` | School/charity verification and consent are separate records. Verification does not grant a school access to a child's activity. Consent evidence is a restricted external reference. |
| Community | `communities`, `community_memberships` | Explicit audience membership; a community is not automatically a school. Start with one managed community. |
| Daily feelings | `daily_check_ins` | Five scores from 1–5, one entry per child/local day, with questionnaire version and timezone. Updating today's entry must also update `updated_at`. |
| My plant | `plants`, `growth_events`, `stickers`, `profile_stickers` | Appearance, participation rewards and approved sticker choices. Growth points are the sum of events; each source action earns once. |
| Polls / stories / endings | `content_items`, `content_revisions`, `poll_options`, `publications` | One content identity with separate revisions. An ending belongs to a story in the same community. Publication selects one approved revision; unpublished content stays available to its author. |
| Images | `media_assets` | Object-storage keys and review status; image bytes stay outside PostgreSQL. Published polls require approved images. |
| Voting | `poll_votes` | One vote per child per poll, referencing an option in the exact poll revision. |
| Hugs | `hug_actions`, `hug_deliveries` | One sending action, with a fixed set of recipient deliveries. Received-hug totals are delivery counts, not a spendable balance. |
| Gifts | `gifts`, `gift_transfers` | Each unique artwork has one gift and one current owner. Keep creator and transfer history privately. |
| Reporting | `content_reports`, `moderation_actions` | Report the exact revision seen; track report handling separately from approve/reject/unpublish decisions. |
| Help | `help_resources` | Configurable hotline directory, disabled until verified. No child incident records or call-click tracking. |

```mermaid
flowchart LR
    Account --> Child[Child profile]
    Child --> CheckIn[Daily check-ins]
    Child --> Plant[Plant and growth]
    Child --> Content[Poll / story / ending]
    Content --> Revision[Content revisions]
    Revision --> Publication[Approved publication]
    Revision --> Report[Content reports]
    Revision --> Options[Poll options]
    Options --> Votes[Votes]
    Child --> Hugs[Hug actions and deliveries]
    Child --> Gift[Gifts and transfers]
```

## Important flows

**Publish:** create a draft revision and its options → submit for review → approve
→ insert into `publications`. Submitted text and options cannot be edited; create
a new revision. A published poll needs 3–4 image options. Removing a publication
hides it from the feed without erasing the revision a report refers to. Unpublish
before revoking approval. To reject a previously approved image, unpublish every
poll that uses it, then change its review status in the same transaction. Retain
its metadata for review; the API must prevent serving rejected images. Object
storage keys are immutable: replacing an image creates a new asset.

**Give a gift:** call `SELECT feelit.transfer_gift(gift_id, sender_id, recipient_id,
request_key)`. The function locks the gift, checks ownership, records the transfer
and changes the owner atomically. An identical retry returns the original transfer;
reusing the key for a different request fails. Future APIs must call this function,
not write ownership/history independently.

**Send hugs:** select eligible recipients once, then insert the action and all
deliveries in one transaction. Reuse the request key on retry; do not recalculate
recipients. **Grow:** record a unique source action in `growth_events`; derive the
visual stage from the total and the chosen growth rules.

## What the API must enforce

The schema enforces data integrity, **not user authorization**. The local database
user owns the schema; it must not be the deployed API role. Before exposing APIs:

- Authenticate every request; check active accounts, consent, membership and staff
  permissions. Configure least-privilege database grants; children never connect
  directly. School verification is not permission to view feelings or reports.
- Return allowlisted fields. Never expose author IDs, gift senders/history, raw
  check-ins, or reporter identity to peers. Anonymity is between children, not from
  the authorized safety team.
- Read feeds through `publications`; also check parent-story visibility for endings.
  Accept votes only on the currently published poll. Freeze the published poll
  revision after its first vote (or close it and create a new poll).
- Limit actions and content length appropriately, prevent self-gifting/self-hugs,
  validate timezone/day boundaries, verify file contents and strip image metadata.
- Record moderation actions and status changes in one transaction. Require moderator
  authorization; the schema's actor FK alone does not check staff role.
- Derive peer similarity from eligible recent check-ins. Apply a minimum cohort size
  and exclude the viewer; do not return member identities or exact small-group data.

## Decisions still open

See [open questions](../OPEN-QUESTIONS.md). This foundation does not decide age
bands, enrollment/parent-consent methods, free-text availability, similarity rules,
growth/reward rates, or retention/deletion periods. No gender, precise birthdate or
mandatory city is collected yet. There is no spendable-hug wallet, direct messaging,
notification inbox, or automatic reporting to authorities. Add those only after
their product rules are agreed. Help-directory content must be verified and loaded
before enabling the help screen.
