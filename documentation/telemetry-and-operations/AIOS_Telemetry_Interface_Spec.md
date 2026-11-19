# AIOS telemetry and shared prediction interface

**Proposed draft for team agreement.** Model internals and exact API contracts remain with the team.

## Target and collection
- Target Ubuntu 24.04 LTS, as stated in the technical deep dive.
- Python/psutil and read-only procfs PSI; optional fixed eBPF only after security review.
- Candidate cadence 1 second, following the technical example; measure overhead and confirm with AI owners.
- Include RFC 3339 UTC and monotonic nanoseconds, run ID, opaque host alias and boot ID.
- Process reference uses PID plus start time. Omit process name, command line, environment, open files and username by default unless a privacy-reviewed display need is agreed.

## Candidate signal groups
| Area | Inputs | Handling |
|---|---|---|
| CPU | Host/per-core utilization, runnable count, CPU PSI some/full avg10/60/300/total | Preserve units/window; flag unsupported PSI |
| Memory | MemTotal, MemAvailable, swap, memory PSI, readable fault/reclaim counters | Bytes/counts; reset-aware deltas |
| I/O | Disk counters, I/O PSI, blocked tasks if available | Raw counters and interval deltas; record device scope |
| Process | PID + start time, status, CPU %, RSS, optional I/O | Nullable; partial visibility is explicit |
| Quality | Freshness, warm-up, unsupported, denied, parse error, reset | Null + reason; no zero-fill |

JSON Lines is proposed for portable recordings; SQLite is proposed for accepted telemetry and a bounded read-only recommendation projection; the append-only hash-chain audit is a separate logical store. Candidate relational schemas and EERDs are provided in [`data-model/`](../data-model/); exact fields, JSON envelopes, retention, prediction contract, REST paths and socket messages remain unapproved and require team agreement.

## User-facing boundary
- Human access is through a read-only dashboard projection for status, recommendations, safety health and audit history.
- The dashboard/API has no command, action-submit, action-approval, mode-change, or policy-edit path. It cannot access the actuator socket or write cgroup controls.
- Decisions and any permitted bounded control are autonomous and follow host-local reviewed deployment policy. No user approval is requested at runtime.
- Authentication, network binding/exposure, exact API routes and viewer role names are not specified; review them before deployment without weakening the query-only boundary.

## Proposed safe fallback for bounded control
- Before any approved CPU, RAM, or I/O control change, capture the prior value and target identity; include device identity for I/O in the action/audit record.
- On watchdog or unsafe-state entry, block new AI writes. Restore the captured value only if the same target is still valid and remains under AIOS control; verify and audit the result.
- If rollback cannot be safely verified, remain fail-closed, report degraded fallback, and require host-side recovery. Never issue a generic shell command or guess a target.
- These are proposed design safeguards, not implementation evidence. Numeric bounds, ownership rules and timeout values need security review.

## Missing and invalid data
- Preserve partial records; unsupported and permission-limited values are null with reason.
- Reject malformed/out-of-range values and record quality events.
- Detect counter reset and process identity change; do not compute a negative rate across a reset.
- Mark first rate sample as warm-up. Never silently forward-fill/interpolate.
- Stale required input cannot authorize an action; OBSERVE_ONLY remains available.
- Collection is read-only: no process movement, cgroup writes, priority changes, signals or service changes.

