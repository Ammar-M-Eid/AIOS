-- AIOS telemetry, decision, recommendation and action model
-- PROPOSED DRAFT: review with the AI/model, host, and security owners before adoption.
-- SQLite 3.38+ is assumed for the runtime database; this script uses core SQLite DDL.
-- Audit events live in a separate database; see aios_audit_store_schema.sql.
PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;

CREATE TABLE schema_metadata (
    singleton_id        INTEGER PRIMARY KEY CHECK (singleton_id = 1),
    schema_name         TEXT NOT NULL,
    schema_version      INTEGER NOT NULL CHECK (schema_version > 0),
    design_status       TEXT NOT NULL CHECK (design_status IN ('proposed', 'accepted')),
    created_at_utc      TEXT NOT NULL,
    notes               TEXT NOT NULL
);
INSERT INTO schema_metadata VALUES
(1, 'AIOS telemetry and decision store', 1, 'proposed',
 '2026-11-17T00:00:00Z',
 'Draft schema only. Team approval, retention limits, and Ubuntu 24.04 validation are pending.');

CREATE TABLE collection_run (
    run_id                  TEXT PRIMARY KEY,
    host_alias              TEXT NOT NULL,
    boot_id                 TEXT,
    os_release              TEXT,
    kernel_release          TEXT,
    collector_version       TEXT,
    schema_version          INTEGER NOT NULL DEFAULT 1,
    started_at_utc          TEXT NOT NULL,
    started_monotonic_ns    INTEGER NOT NULL CHECK (started_monotonic_ns >= 0),
    ended_at_utc            TEXT,
    ended_monotonic_ns      INTEGER CHECK (ended_monotonic_ns IS NULL OR ended_monotonic_ns >= 0),
    sample_interval_ns      INTEGER CHECK (sample_interval_ns IS NULL OR sample_interval_ns > 0),
    run_status              TEXT NOT NULL DEFAULT 'running'
                                CHECK (run_status IN ('running', 'completed', 'interrupted', 'failed')),
    source_profile          TEXT NOT NULL DEFAULT 'read_only',
    CHECK (ended_monotonic_ns IS NULL OR ended_monotonic_ns >= started_monotonic_ns)
);

CREATE TABLE host_sample (
    host_sample_id          INTEGER PRIMARY KEY,
    run_id                  TEXT NOT NULL REFERENCES collection_run(run_id),
    captured_at_utc         TEXT NOT NULL,
    monotonic_ns            INTEGER NOT NULL CHECK (monotonic_ns >= 0),
    quality_json            TEXT NOT NULL DEFAULT '{}',
    cpu_pct                 REAL CHECK (cpu_pct IS NULL OR cpu_pct BETWEEN 0 AND 100),
    cpu_per_core_pct_json   TEXT,
    load_average_json       TEXT,
    memory_total_bytes      INTEGER CHECK (memory_total_bytes IS NULL OR memory_total_bytes >= 0),
    memory_available_bytes  INTEGER CHECK (memory_available_bytes IS NULL OR memory_available_bytes >= 0),
    memory_used_bytes       INTEGER CHECK (memory_used_bytes IS NULL OR memory_used_bytes >= 0),
    memory_pct              REAL CHECK (memory_pct IS NULL OR memory_pct BETWEEN 0 AND 100),
    swap_total_bytes        INTEGER CHECK (swap_total_bytes IS NULL OR swap_total_bytes >= 0),
    swap_used_bytes         INTEGER CHECK (swap_used_bytes IS NULL OR swap_used_bytes >= 0),
    swap_free_bytes         INTEGER CHECK (swap_free_bytes IS NULL OR swap_free_bytes >= 0),
    swap_pct                REAL CHECK (swap_pct IS NULL OR swap_pct BETWEEN 0 AND 100),
    cpu_psi_status          TEXT,
    cpu_psi_some_avg10      REAL,
    cpu_psi_some_avg60      REAL,
    cpu_psi_some_avg300     REAL,
    cpu_psi_some_total_usec INTEGER CHECK (cpu_psi_some_total_usec IS NULL OR cpu_psi_some_total_usec >= 0),
    cpu_psi_full_avg10      REAL,
    cpu_psi_full_avg60      REAL,
    cpu_psi_full_avg300     REAL,
    cpu_psi_full_total_usec INTEGER CHECK (cpu_psi_full_total_usec IS NULL OR cpu_psi_full_total_usec >= 0),
    memory_psi_status       TEXT,
    memory_psi_some_avg10      REAL,
    memory_psi_some_avg60      REAL,
    memory_psi_some_avg300     REAL,
    memory_psi_some_total_usec INTEGER CHECK (memory_psi_some_total_usec IS NULL OR memory_psi_some_total_usec >= 0),
    memory_psi_full_avg10      REAL,
    memory_psi_full_avg60      REAL,
    memory_psi_full_avg300     REAL,
    memory_psi_full_total_usec INTEGER CHECK (memory_psi_full_total_usec IS NULL OR memory_psi_full_total_usec >= 0),
    io_psi_status           TEXT,
    io_psi_some_avg10       REAL,
    io_psi_some_avg60       REAL,
    io_psi_some_avg300      REAL,
    io_psi_some_total_usec  INTEGER CHECK (io_psi_some_total_usec IS NULL OR io_psi_some_total_usec >= 0),
    io_psi_full_avg10       REAL,
    io_psi_full_avg60       REAL,
    io_psi_full_avg300      REAL,
    io_psi_full_total_usec  INTEGER CHECK (io_psi_full_total_usec IS NULL OR io_psi_full_total_usec >= 0),
    disk_read_bytes         INTEGER CHECK (disk_read_bytes IS NULL OR disk_read_bytes >= 0),
    disk_write_bytes        INTEGER CHECK (disk_write_bytes IS NULL OR disk_write_bytes >= 0),
    disk_read_count         INTEGER CHECK (disk_read_count IS NULL OR disk_read_count >= 0),
    disk_write_count        INTEGER CHECK (disk_write_count IS NULL OR disk_write_count >= 0),
    UNIQUE (run_id, monotonic_ns),
    UNIQUE (host_sample_id, run_id)
);

CREATE TABLE process_sample (
    process_sample_id           INTEGER PRIMARY KEY,
    host_sample_id              INTEGER NOT NULL,
    run_id                      TEXT NOT NULL,
    pid                         INTEGER NOT NULL CHECK (pid > 0),
    process_start_time_epoch_s  REAL,
    process_status              TEXT,
    cpu_pct                     REAL CHECK (cpu_pct IS NULL OR cpu_pct >= 0),
    rss_bytes                   INTEGER CHECK (rss_bytes IS NULL OR rss_bytes >= 0),
    vms_bytes                   INTEGER CHECK (vms_bytes IS NULL OR vms_bytes >= 0),
    io_read_bytes               INTEGER CHECK (io_read_bytes IS NULL OR io_read_bytes >= 0),
    io_write_bytes              INTEGER CHECK (io_write_bytes IS NULL OR io_write_bytes >= 0),
    quality_json                TEXT NOT NULL DEFAULT '{}',
    FOREIGN KEY (host_sample_id, run_id) REFERENCES host_sample(host_sample_id, run_id),
    UNIQUE (host_sample_id, pid, process_start_time_epoch_s)
);

CREATE TABLE prediction_output (
    prediction_id                   TEXT PRIMARY KEY,
    run_id                          TEXT NOT NULL REFERENCES collection_run(run_id),
    produced_at_utc                 TEXT NOT NULL,
    produced_monotonic_ns           INTEGER NOT NULL CHECK (produced_monotonic_ns >= 0),
    target_scope                    TEXT NOT NULL CHECK (target_scope IN ('host', 'process', 'cgroup')),
    target_ref                      TEXT NOT NULL,
    resource_kind                   TEXT NOT NULL CHECK (resource_kind IN ('cpu', 'memory', 'io')),
    input_window_start_monotonic_ns INTEGER NOT NULL CHECK (input_window_start_monotonic_ns >= 0),
    input_window_end_monotonic_ns   INTEGER NOT NULL CHECK (input_window_end_monotonic_ns >= input_window_start_monotonic_ns),
    horizon_ms                      INTEGER CHECK (horizon_ms IS NULL OR horizon_ms > 0),
    output_payload_json             TEXT NOT NULL,
    uncertainty_json                TEXT,
    quality_status                  TEXT NOT NULL DEFAULT 'unknown'
                                        CHECK (quality_status IN ('valid', 'stale', 'incomplete', 'invalid', 'unknown'))
);

CREATE TABLE policy_decision (
    decision_id             TEXT PRIMARY KEY,
    run_id                  TEXT NOT NULL REFERENCES collection_run(run_id),
    prediction_id           TEXT REFERENCES prediction_output(prediction_id),
    correlation_id          TEXT NOT NULL,
    decided_at_utc          TEXT NOT NULL,
    decided_monotonic_ns    INTEGER NOT NULL CHECK (decided_monotonic_ns >= 0),
    target_scope            TEXT NOT NULL CHECK (target_scope IN ('host', 'process', 'cgroup')),
    target_ref              TEXT NOT NULL,
    resource_kind           TEXT NOT NULL CHECK (resource_kind IN ('cpu', 'memory', 'io')),
    outcome                 TEXT NOT NULL CHECK (outcome IN ('leave', 'recommendation', 'admitted', 'denied', 'observe_only')),
    reason_code             TEXT NOT NULL,
    explanation             TEXT,
    policy_profile_ref      TEXT,
    CHECK (outcome <> 'admitted' OR target_scope = 'cgroup')
);

CREATE TABLE recommendation_projection (
    recommendation_id       TEXT PRIMARY KEY,
    decision_id             TEXT NOT NULL UNIQUE REFERENCES policy_decision(decision_id),
    created_at_utc          TEXT NOT NULL,
    expires_at_utc          TEXT,
    projection_status       TEXT NOT NULL CHECK (projection_status IN ('current', 'expired', 'superseded', 'withdrawn')),
    display_payload_json    TEXT NOT NULL
);

CREATE TABLE action_attempt (
    action_attempt_id       TEXT PRIMARY KEY,
    decision_id             TEXT NOT NULL REFERENCES policy_decision(decision_id),
    correlation_id          TEXT NOT NULL,
    created_at_utc          TEXT NOT NULL,
    target_ref              TEXT NOT NULL,
    resource_kind           TEXT NOT NULL CHECK (resource_kind IN ('cpu', 'memory', 'io')),
    control_name            TEXT NOT NULL CHECK (control_name IN ('cpu.weight', 'memory.high', 'io.weight', 'io.max')),
    device_major            INTEGER CHECK (device_major IS NULL OR device_major >= 0),
    device_minor            INTEGER CHECK (device_minor IS NULL OR device_minor >= 0),
    previous_value          TEXT,
    requested_value         TEXT,
    readback_value          TEXT,
    attempt_status          TEXT NOT NULL CHECK (attempt_status IN ('denied', 'not_started', 'write_failed', 'verification_failed', 'verified', 'rollback_requested', 'rollback_verified', 'rollback_failed')),
    result_detail           TEXT,
    CHECK ((resource_kind = 'cpu' AND control_name = 'cpu.weight') OR
           (resource_kind = 'memory' AND control_name = 'memory.high') OR
           (resource_kind = 'io' AND control_name IN ('io.weight', 'io.max'))),
    CHECK (resource_kind <> 'io' OR control_name <> 'io.max' OR (device_major IS NOT NULL AND device_minor IS NOT NULL))
);

CREATE TABLE action_gate_check (
    gate_check_id       INTEGER PRIMARY KEY,
    action_attempt_id   TEXT NOT NULL REFERENCES action_attempt(action_attempt_id),
    gate_name           TEXT NOT NULL CHECK (gate_name IN ('resource_capability', 'target_approved', 'target_owned', 'policy_admitted', 'within_bounds', 'control_supported', 'actuator_peer_authenticated', 'watchdog_healthy')),
    checked_at_utc      TEXT NOT NULL,
    gate_result         TEXT NOT NULL CHECK (gate_result IN ('pass', 'fail', 'unknown')),
    reason_code         TEXT,
    UNIQUE (action_attempt_id, gate_name)
);

CREATE INDEX idx_host_sample_run_time ON host_sample(run_id, monotonic_ns);
CREATE INDEX idx_process_sample_pid_time ON process_sample(pid, process_start_time_epoch_s, host_sample_id);
CREATE INDEX idx_prediction_run_time ON prediction_output(run_id, produced_monotonic_ns);
CREATE INDEX idx_decision_time ON policy_decision(decided_at_utc, resource_kind, outcome);
CREATE INDEX idx_decision_correlation ON policy_decision(correlation_id);
CREATE INDEX idx_recommendation_status_expiry ON recommendation_projection(projection_status, expires_at_utc);
CREATE INDEX idx_action_attempt_time ON action_attempt(created_at_utc, resource_kind, attempt_status);

PRAGMA user_version = 1;
COMMIT;


