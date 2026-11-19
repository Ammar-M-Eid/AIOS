# Data Model Design Notes

## Scope and status

This package makes the data design reviewable while keeping the interface unapproved. It supports the proposed product flow across CPU, RAM, and I/O: observe, validate, predict, decide, recommend, and—only after independent host-local safety gates—attempt a bounded control on a preconfigured approved cgroup. `OBSERVE_ONLY` remains the default. The dashboard projection is read-only.

The relational structures are candidates derived from the existing telemetry/interface draft, the retained passive JSONL capture, the SRS and resource-control scope. The collector capture is from an Ubuntu 26.04.1 VMware guest and contains only passive observations; it does not demonstrate inference, decisions, action, or target Ubuntu 24.04 behavior.

## Store boundaries and relationships

### Telemetry and decision database

- `collection_run` owns capture provenance and run/host identity.
- `host_sample` records CPU, RAM/swap, CPU/memory/I/O PSI, and aggregate disk counters. Raw counter values remain distinct from interval deltas; rate calculation belongs to a reset-aware processing step.
- `process_sample` belongs to one host sample and records PID plus optional creation time as the proposed PID-reuse guard. If access is denied, sensitive/unknown measurements stay null and `quality_json` records why.
- `prediction_output` stores a generic payload plus resource, target, source-window bounds, time and quality. It intentionally has no algorithm-specific columns; the AI/model owners must define and approve the payload.
- `policy_decision` preserves the distinct `leave`, `recommendation`, `admitted`, `denied`, and `observe_only` outcomes. Admission is constrained to a cgroup target.
- `recommendation_projection` is a bounded read-only display projection, linked to its decision. It is not an action queue and does not create a human control path.
- `action_attempt` records an authorized or rejected control attempt, previous/requested/read-back values, result, and I/O device identity where applicable. `action_gate_check` provides an independent record for each candidate capability, ownership, policy, bounds, support, peer, and watchdog check. Persisting these fields does not prove the gates are implemented or safe.

### Separate audit database

`audit_event` is physically modeled in its own database. The schema deliberately has no foreign key into telemetry/decision tables. Opaque correlation identifiers connect event sequences to decisions and action attempts without coupling the stores. Each audit database contains one ordered chain; the audit table contains sequence, canonical payload, previous hash, and event hash. Append-only triggers reduce accidental edits through normal SQL, but do not make the file tamper-proof. A privileged owner can change the database and recompute a chain; implementation must define canonical serialization, transaction ordering, backup/rotation, file access, and a protected external anchor for the chain head.

## Field semantics and constraints

- `*_at_utc` values are RFC 3339 timestamps normalized to UTC. Monotonic nanoseconds are used for ordering within a run/boot; they are not wall-clock timestamps.
- PSI `avg10`, `avg60`, and `avg300` preserve the kernel's percentage values. PSI `total_usec` uses the kernel's cumulative microsecond unit.
- Bytes and counts are nonnegative raw observations. CPU/memory percentages are bounded only where the source semantics are 0–100; process CPU may exceed 100 on a multi-core process and is therefore only constrained to nonnegative.
- JSON text columns carry quality, per-core/load arrays, generic model output/uncertainty, and safe dashboard payloads. Their exact shape and validation contract need owner agreement.
- Process identity is the run-scoped pair `(pid, process_start_time_epoch_s)` when start time is available. A missing start time is allowed for access-denied observations and must not be treated as a stable identity.
- `io.max` attempts require major/minor device identity. `io.weight` may be group-scoped; whether it needs a device key is kernel/interface dependent and must be confirmed in implementation.
- The SQL permits only the proposed controls `cpu.weight`, `memory.high`, `io.weight`, and `io.max`. It does not include `memory.max`, process termination, arbitrary shell commands, or arbitrary control-file paths.

## Open decisions before implementation

1. AI/model owners approve the input-window contract, generic output JSON, uncertainty and freshness meanings, and target identity.
2. Host/security owners approve cgroup-v2 detection, supported per-resource controls, target ownership, bounds, gate names, privilege separation, and safe read-back/rollback behavior.
3. Team approves whether JSONL remains an interchange format and SQLite is the target local database; choose schema migration and compatibility policy.
4. Set retention duration, database/WAL size caps, cleanup behavior, disk-full behavior, and sample cadence using target-host measurements.
5. Decide whether per-device telemetry is required and extend collection only after interface review; the retained collector currently records aggregate disk counters.
6. Define audit event taxonomy and canonical hash input; test chain recovery, process crash behavior, rotation, external head anchoring, and restricted file access.
7. Validate schema/API agreement on Ubuntu 24.04 and verify every null/status/reset/permission path. The current guest capture does not satisfy this target validation.

## References to project evidence

- [`AIOS_Telemetry_Interface_Spec.md`](../telemetry-and-operations/AIOS_Telemetry_Interface_Spec.md) — candidate signals, time basis, missing-data, privacy, projection, and safety boundaries.
- [`Telemetry_Recording_Status.md`](../telemetry-and-operations/Telemetry_Recording_Status.md) — provenance and limits of the retained passive capture; the raw recording remains in the source workspace.
- [`AIOS_Resource_Control_Scope.md`](../requirements/AIOS_Resource_Control_Scope.md) — product resource/control scope and excluded actions.
- [`Ammar_Requirements_Traceability.csv`](../requirements/Ammar_Requirements_Traceability.csv) — detailed requirement priorities, verification methods, evidence limits, and status.
- [`10_logical_data_model.mmd`](../architecture/uml-and-supporting-diagrams/10_logical_data_model.mmd) — conceptual domain model, not a physical schema.

