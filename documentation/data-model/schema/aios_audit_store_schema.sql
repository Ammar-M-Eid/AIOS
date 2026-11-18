-- AIOS separate logical audit store
-- PROPOSED DRAFT: review event taxonomy, anchoring, rotation, permissions, and retention.
-- This database has no foreign keys into the telemetry/decision database.
PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;

CREATE TABLE audit_store_metadata (
    singleton_id        INTEGER PRIMARY KEY CHECK (singleton_id = 1),
    schema_name         TEXT NOT NULL,
    schema_version      INTEGER NOT NULL CHECK (schema_version > 0),
    design_status       TEXT NOT NULL CHECK (design_status IN ('proposed', 'accepted')),
    created_at_utc      TEXT NOT NULL,
    hash_algorithm      TEXT NOT NULL DEFAULT 'SHA-256',
    notes               TEXT NOT NULL
);
INSERT INTO audit_store_metadata VALUES
(1, 'AIOS audit event store', 1, 'proposed', '2026-11-17T00:00:00Z', 'SHA-256',
 'Draft only. Hash-chain calculation and protected external head anchoring require implementation and security review.');

-- One ordered chain per audit database. Rotation may create a new database/chain.
CREATE TABLE audit_chain_head (
    chain_id            TEXT PRIMARY KEY,
    singleton_id        INTEGER NOT NULL UNIQUE CHECK (singleton_id = 1),
    next_sequence       INTEGER NOT NULL CHECK (next_sequence > 0),
    head_hash_hex       TEXT,
    updated_at_utc      TEXT NOT NULL
);
INSERT INTO audit_chain_head(singleton_id, chain_id, next_sequence, head_hash_hex, updated_at_utc)
VALUES (1, 'initial-chain', 1, NULL, '2026-11-17T00:00:00Z');

CREATE TABLE audit_event (
    sequence_no             INTEGER PRIMARY KEY CHECK (sequence_no > 0),
    event_id                TEXT NOT NULL UNIQUE,
    chain_id                TEXT NOT NULL REFERENCES audit_chain_head(chain_id),
    occurred_at_utc         TEXT NOT NULL,
    monotonic_ns            INTEGER CHECK (monotonic_ns IS NULL OR monotonic_ns >= 0),
    event_type              TEXT NOT NULL,
    severity                TEXT NOT NULL DEFAULT 'info' CHECK (severity IN ('debug', 'info', 'warning', 'error', 'critical')),
    correlation_id          TEXT NOT NULL,
    run_id                  TEXT,
    decision_id             TEXT,
    action_attempt_id       TEXT,
    target_ref              TEXT,
    payload_json            TEXT NOT NULL,
    previous_hash_hex       TEXT,
    event_hash_hex          TEXT NOT NULL UNIQUE,
    hash_algorithm          TEXT NOT NULL DEFAULT 'SHA-256',
    CHECK ((sequence_no = 1 AND previous_hash_hex IS NULL) OR
           (sequence_no > 1 AND previous_hash_hex IS NOT NULL))
);

CREATE INDEX idx_audit_event_time ON audit_event(occurred_at_utc, sequence_no);
CREATE INDEX idx_audit_event_correlation ON audit_event(correlation_id, sequence_no);
CREATE INDEX idx_audit_event_type_time ON audit_event(event_type, occurred_at_utc);

-- Defense in depth against accidental row edits through ordinary SQL. This is
-- not tamper-proof storage: a privileged owner could alter schema/files and
-- recompute a chain. Secure file permissions, checkpoint/export policy,
-- external head anchoring, and key management remain deployment decisions.
CREATE TRIGGER audit_event_no_update
BEFORE UPDATE ON audit_event
BEGIN
    SELECT RAISE(ABORT, 'audit_event is append-only');
END;
CREATE TRIGGER audit_event_no_delete
BEFORE DELETE ON audit_event
BEGIN
    SELECT RAISE(ABORT, 'audit_event is append-only');
END;

PRAGMA user_version = 1;
COMMIT;

