# AIOS Requirements and Behavior Specification

Version 1.0 • 18 November 2026 • Draft for team review

This companion package names every canonical requirement and derives use cases, user stories with acceptance criteria, and sequence diagrams. It covers CPU, RAM, and disk I/O. It describes proposed behavior, not implementation evidence. Canonical shall statements, priorities, verification methods, evidence and status remain in `Ammar_Requirements_Traceability.csv`.

## 1. Named requirements

| ID | Name | Description | Priority |
|---|---|---|---|
| 1.1.1 | Host and Process CPU Telemetry | The collector shall record host and eligible-process CPU observations using supported read-only Linux interfaces and preserve the source and unit for each value. | Must |
| 1.1.2 | Host and Process Memory Telemetry | The collector shall record available host and eligible-process memory observations and mark each metric with its source, unit, and scope. | Must |
| 1.1.3 | Host and Process I/O Telemetry | The collector shall record available host and eligible-process I/O observations with device or cgroup scope and interval context where the source requires deltas. | Must |
| 1.1.4 | Pressure Stall Information Collection | When supported by the running kernel and target, the collector shall read CPU, memory, and I/O Pressure Stall Information and identify unsupported or inaccessible resources. | Must |
| 1.1.5 | Opt-In eBPF Collection | Optional eBPF collection shall remain disabled unless a fixed probe set has been reviewed, configured, and approved for the target kernel. | Should |
| 1.1.6 | Dual-Clock Sample Ordering | Each sample shall carry a UTC timestamp and a monotonic ordering value sufficient to detect ordering across wall-clock adjustment. | Must |
| 1.2.1 | Stable Process Instance Identity | A process-scoped observation shall include PID and process start-time identity so a reused PID is not treated as the same process instance. | Must |
| 1.2.2 | Observation Quality Validation | Before inference or policy evaluation, the pipeline shall validate required field shape, unit, source health, and counter-delta validity. | Must |
| 1.2.3 | Explicit Data Availability States | The pipeline and read-only view shall distinguish measured zero from unavailable, permission-denied, stale, warming-up, and degraded data states. | Must |
| 1.2.4 | Invalid Delta and Identity Rejection | A reset counter, missing interval, stale sample, or changed process identity shall invalidate dependent deltas and prevent those values from authorizing an action. | Must |
| 1.3.1 | Bounded Local Telemetry Persistence | Accepted telemetry shall be stored locally in SQLite for bounded inspection and recent-window access. | Must |
| 1.3.2 | Database and WAL Size Limits | Telemetry retention, database size, and SQLite write-ahead-log growth shall be bounded by reviewed host-local settings. | Must |
| 1.3.3 | Read-Only Dashboard Data Path | Dashboard data access shall use a read-only projection and shall not receive the actuator socket or cgroup write permission. | Must |
| 1.4.1 | Model-Agnostic Inference Contract | The telemetry-to-inference boundary shall pass approved observations and receive generic prediction outputs without prescribing model type, algorithm, or internals. | Must |
| 1.4.2 | Prediction Window and Quality Provenance | A prediction used for a decision shall remain associated with its source window and available time/quality context; exact fields and schema require team agreement. | Must |
| 1.4.3 | Inference Without Privileged Writes | Inference outputs shall not write to the operating system or call the privileged actuator directly. | Must |
| 1.5.1 | Per-Process Decision Outcome | For each eligible process and evaluated window, the decision service shall produce LEAVE or a proposal/denial outcome with a reason. | Must |
| 1.5.2 | Policy Admission Guard | Before admitting a proposal, policy shall check operating mode, target eligibility, allowlist membership, evidence freshness, action bounds, and cooldown. | Must |
| 1.5.3 | Safe OBSERVE_ONLY Startup | OBSERVE_ONLY shall be the default at first start and after restart, missing/invalid configuration, or failed safety health; no dashboard action shall enable control. | Must |
| 1.5.4 | Resource-Specific Bounded Controls | For every supported resource class, AIOS shall permit only bounded writes to preconfigured approved cgroups: cpu.weight for CPU, memory.high for RAM, and supported io.weight/io.max for I/O. Each resource requires independent capability and authorization checks; unsupported controls remain recommendation-only. | Must |
| 1.5.5 | Prohibited and Unsupported Action Denial | AIOS shall not write memory.max, terminate processes, invoke arbitrary shell commands, or write a control whose controller/device is unsupported or whose target is not approved. Denied or unavailable actions shall remain recommendations and be audited. | Must |
| 1.6.1 | Local Actuator IPC | Decision/policy-to-actuator requests shall use a host-local Unix domain socket. | Must |
| 1.6.2 | Peer Credential Authentication | The actuator shall authenticate the connecting local process with SO_PEERCRED and reject peers outside the reviewed local peer policy. | Must |
| 1.6.3 | Pre-Write Target and Policy Revalidation | Immediately before a write, the actuator shall revalidate request bounds, mode, allowlist, target cgroup, process-instance identity where applicable, and AIOS ownership. | Must |
| 1.6.4 | Capture Apply and Verify Control | For every admitted resource-control write, the adapter shall capture the prior control value, apply only the bounded and authorized value, and read back the effective value. I/O values shall retain their device identity. | Must |
| 1.6.5 | Guarded Write-Failure Restoration | If a write or verification fails, the adapter shall attempt only a guarded restoration of a still-verified AIOS-owned target and shall never invoke an arbitrary shell command. | Must |
| 1.7.1 | Correlated Security and Action Audit | The audit path shall record decisions, denials, authentication/validation failures, action attempts, verification outcomes, and fallback events with correlation context. | Must |
| 1.7.2 | Tamper-Evident Audit Chain | Audit records shall be appended to a hash-chained log whose verification can detect modification, missing links, or reset history. | Must |
| 1.7.3 | Independent Safety Watchdog | A watchdog shall monitor service heartbeat and input freshness independently of the ordinary decision path. | Must |
| 1.7.4 | Fail-Closed Watchdog Response | On stale evidence, watchdog failure, or unsafe state, AIOS shall block new OS writes, enter fallback, and record a reason. | Must |
| 1.7.5 | Identity-Checked Fallback Restoration | Fallback restoration shall use the captured prior resource-control value for a target whose cgroup identity and AIOS ownership still match; I/O restoration shall also match the recorded device. Read back and verify the restored value. | Must |
| 1.8.1 | Read-Only Operational Projection | The dashboard shall expose read-only status, recommendations, operating mode, service health, safety state, action outcomes, and audit summaries through projections. | Must |
| 1.8.2 | No Dashboard Control Surface | The dashboard shall provide no command, approval, policy edit, mode change, or resource-control operation, and shall not provide a path to the actuator socket. | Must |
| 1.8.3 | Visible Telemetry Quality States | The dashboard shall present measured zero separately from unavailable, stale, degraded, warming-up, and denied data. | Must |
| 1.9.1 | systemd Lifecycle Supervision | systemd shall supervise proposed service lifecycle and expose service health/failure state to the read-only projection. | Must |
| 1.9.2 | Optional CPU Affinity Profile | As an optional host-local profile, selected non-safety AIOS compute services may be restricted to a host-selected set of online logical CPUs; the effective mask shall be checked. | Could |
| 1.9.3 | Optional AIOS CPU Quota Profile | As an optional host-local profile, CPUQuota/cpu.max may cap aggregate CPU time for selected non-safety AIOS compute services; the watchdog, policy, and actuator shall not receive an unvalidated tight quota. | Could |
| 1.9.4 | Explicit Host Prerequisite Reporting | AIOS shall report Ubuntu, kernel, cgroup-v2, PSI, and optional eBPF prerequisites and shall disable or degrade unsupported features explicitly. | Must |
| 2.1.1 | Least-Privilege Actuator Permissions | Service permissions shall follow least privilege; only the narrow actuator process may receive the approved cgroup write permission. | Must |
| 2.1.2 | Process and Interface Separation | Collector, inference, decision/policy, actuator, audit, and dashboard access shall be separated at the process/interface boundary appropriate to the deployed profile. | Must |
| 2.1.3 | Audit Integrity Actuation Lockout | The system shall make audit-chain breaks, missing history, resets, or unverifiable events visible and disable actuation until review. | Must |
| 2.2.1 | Fail-Safe Deny on Invalid Evidence | Invalid, stale, unauthenticated, out-of-bounds, wrong-target, or integrity-failed evidence shall produce LEAVE/deny and no OS write. | Must |
| 2.2.2 | Preserve Linux Native Control | Failure of AIOS services shall not replace Linux-native scheduling or memory-management behavior; watchdog/control shall remain outside any unvalidated CPU cap. | Must |
| 2.2.3 | Safe Restart Requires Valid Configuration | A service restart shall not enable control unless the reviewed host-local configuration and required safety health are valid. | Must |
| 2.3.1 | Runtime Cost and Workload Evaluation | Evaluation records shall include AIOS CPU use, RSS, storage and write rate, sample freshness, decision latency, and foreground workload impact. | Must |
| 2.3.2 | Thresholds Based on Host Measurement | Sampling, staleness, latency, storage, and control thresholds shall be approved from target-host measurements before active control is enabled. | Must |
| 2.4.1 | Privacy-Preserving Telemetry Defaults | By default, telemetry and dashboard projections shall use an opaque host alias and process identity; command lines, environment variables, usernames, filesystem paths, and payload contents shall be omitted. | Must |
| 2.5.1 | Capability-Aware Compatibility | The deployment shall report prerequisite availability by Ubuntu/kernel/cgroup/PSI/eBPF capability and shall not silently assume every optional interface exists. | Must |
| 2.6.1 | Clear Outcome Presentation | The read-only view shall visibly distinguish observation, prediction/recommendation, admitted action, denial, and fallback outcome without offering user control. | Must |
| 2.7.1 | Reviewable Responsibility Boundaries | The design shall keep telemetry collection, validation, inference adaptation, decision policy, IPC, actuation, persistence, audit, watchdog, and dashboard query responsibilities separately reviewable. | Should |
| 2.8.1 | Requirement Verification and Evidence Status | Each leaf requirement shall have a planned verification method and a status that separates proposed design, implemented behavior, and collected evidence. | Must |
| 2.8.2 | Separate Technical Evidence from Demand Evidence | Market needs shall remain hypotheses until local participant evidence is collected and reviewed; technical documentation shall not be presented as proof of demand or benefit. | Must |

## 2. Use cases

### UC-01 — Check host readiness and capabilities
- **Primary actor:** Host configuration owner
- **Trigger:** Start/restart
- **Main flow:** Read reviewed local profile; probe OS, kernel, cgroup v2, PSI and optional eBPF; report each capability; default to OBSERVE_ONLY.
- **Alternatives/failure:** Unsupported features disabled; invalid config or failed health remains fail-closed.
- **Requirement trace:** 1.9.1;1.9.2;1.9.3;1.9.4;2.2.3;2.5.1

### UC-02 — Collect CPU, RAM, I/O and PSI observations
- **Primary actor:** Collector
- **Trigger:** Sampling tick
- **Main flow:** Read supported host/process interfaces; preserve source, unit, scope, interval, UTC and monotonic time; eBPF only when approved.
- **Alternatives/failure:** Represent missing, denied, stale and unsupported inputs explicitly.
- **Requirement trace:** 1.1.1;1.1.2;1.1.3;1.1.4;1.1.5;1.1.6

### UC-03 — Validate sample quality and process identity
- **Primary actor:** Quality gate
- **Trigger:** Sample received
- **Main flow:** Validate shape, units, age, source health, counters, PID and start time; invalidate deltas on reset or identity change.
- **Alternatives/failure:** Invalid or stale input cannot authorize a write.
- **Requirement trace:** 1.2.1;1.2.2;1.2.3;1.2.4;2.2.1

### UC-04 — Persist bounded telemetry
- **Primary actor:** Telemetry store
- **Trigger:** Validated sample
- **Main flow:** Append to local SQLite with retention, database and WAL limits; expose read-only projections.
- **Alternatives/failure:** Record storage errors; never fabricate zero for unavailable data.
- **Requirement trace:** 1.3.1;1.3.2;1.3.3

### UC-05 — Generate provenance-bound prediction
- **Primary actor:** Inference adapter
- **Trigger:** Approved window
- **Main flow:** Exchange generic prediction with exact source-window and quality context; keep inference unprivileged.
- **Alternatives/failure:** Reject late/invalid outputs; inference has no OS write or direct actuator path.
- **Requirement trace:** 1.4.1;1.4.2;1.4.3

### UC-06 — Decide per-process outcome
- **Primary actor:** Decision service
- **Trigger:** Validated window
- **Main flow:** Emit LEAVE or reasoned proposal/denial for each eligible process and window.
- **Alternatives/failure:** Insufficient evidence yields LEAVE.
- **Requirement trace:** 1.5.1;1.5.5

### UC-07 — Apply policy admission gates
- **Primary actor:** Policy service
- **Trigger:** Proposal available
- **Main flow:** Check mode, target, allowlist, freshness, bounds, cooldown, authorization and separate resource capability.
- **Alternatives/failure:** OBSERVE_ONLY, unsupported or forbidden actions become audited recommendations/denials.
- **Requirement trace:** 1.5.2;1.5.3;1.5.4;1.5.5;2.2.1

### UC-08 — Authenticate and revalidate actuator request
- **Primary actor:** Actuator
- **Trigger:** Admitted local request
- **Main flow:** Use Unix socket and SO_PEERCRED; immediately recheck mode, bounds, cgroup/process identity, ownership and device.
- **Alternatives/failure:** Reject peer/target mismatch with no write.
- **Requirement trace:** 1.6.1;1.6.2;1.6.3;2.1.1;2.1.2

### UC-09 — Apply guarded CPU control
- **Primary actor:** CPU adapter
- **Trigger:** Authorized CPU request
- **Main flow:** Capture prior cpu.weight, apply bounded value to approved cgroup, read back and audit.
- **Alternatives/failure:** Restore only if current identity and AIOS ownership still verify.
- **Requirement trace:** 1.5.4;1.6.4;1.6.5

### UC-10 — Apply guarded RAM control
- **Primary actor:** Memory adapter
- **Trigger:** Authorized memory request
- **Main flow:** Capture prior memory.high, apply bounded value, read back and audit.
- **Alternatives/failure:** Never write memory.max or terminate a process; guarded restore only.
- **Requirement trace:** 1.5.4;1.5.5;1.6.4;1.6.5

### UC-11 — Apply guarded device-specific I/O control
- **Primary actor:** I/O adapter
- **Trigger:** Authorized I/O request
- **Main flow:** Check supported controller/device; capture prior io.weight/io.max for that device; apply and read back same control.
- **Alternatives/failure:** Unsupported device or mismatch means no write; rollback requires same device identity.
- **Requirement trace:** 1.5.4;1.5.5;1.6.4;1.6.5;1.7.5

### UC-12 — Inhibit and recover on unsafe runtime
- **Primary actor:** Watchdog
- **Trigger:** Heartbeat/freshness failure
- **Main flow:** Independently detect stale evidence or failed heartbeat; block writes; restore captured prior values after target/ownership verification.
- **Alternatives/failure:** If checks fail, do not write; flag review and preserve Linux-native behavior.
- **Requirement trace:** 1.7.3;1.7.4;1.7.5;2.2.2

### UC-13 — Append and verify audit history
- **Primary actor:** Audit service / security reviewer
- **Trigger:** Decision or security/action event
- **Main flow:** Append correlated event to hash-chained audit DB; verify chain and report gaps, resets or modification.
- **Alternatives/failure:** Integrity failure disables actuation pending review.
- **Requirement trace:** 1.7.1;1.7.2;2.1.3

### UC-14 — Review status and outcomes (read-only)
- **Primary actor:** Sysadmin/SRE
- **Trigger:** Open dashboard
- **Main flow:** Read status, recommendations, mode, health, outcomes and audit summaries; distinguish zero from unavailable/stale/degraded/warming-up/denied.
- **Alternatives/failure:** No commands, approvals, policy/mode edits or actuator route; omit sensitive fields by default.
- **Requirement trace:** 1.3.3;1.8.1;1.8.2;1.8.3;2.4.1;2.6.1

### UC-15 — Measure overhead and workload impact
- **Primary actor:** Researcher/evaluator
- **Trigger:** Evaluation run completes
- **Main flow:** Record AIOS CPU/RSS/storage/write rate, freshness, decision latency and foreground impact; approve thresholds from target-host measurements.
- **Alternatives/failure:** Technical references are not demand evidence or measured benefit.
- **Requirement trace:** 2.3.1;2.3.2;2.8.2

### UC-16 — Review least privilege and evidence status
- **Primary actor:** Security reviewer / maintainer
- **Trigger:** Design/release review
- **Main flow:** Inspect process/interface separation, actor permissions, privacy defaults, traceability, evidence labels and responsibility boundaries.
- **Alternatives/failure:** Privilege expansion, data leakage or unsupported claim blocks release/control.
- **Requirement trace:** 2.1.1;2.1.2;2.4.1;2.7.1;2.8.1;2.8.2


### UC-17 — Read operational status and outcome projection
- **Primary actor:** Sysadmin/SRE through UC-14
- **Trigger:** UC-14 dashboard review requests operational data
- **Main flow:** Query the read-only telemetry/decision projection persisted from accepted observations; return current mode, health, recommendations, action outcomes, timestamps, and explicit quality/availability states.
- **Alternatives/failure:** On unavailable, stale, degraded, or denied data, return its explicit state; never return an invented zero or expose a write/actuator path.
- **Requirement trace:** 1.3.3; 1.8.1; 1.8.3; 2.4.1; 2.6.1
- **Use-case relationship:** Included by UC-14; reads the UC-04 projection without executing persistence.

### UC-18 — Read audit summary and verification status
- **Primary actor:** Sysadmin/SRE through UC-14
- **Trigger:** UC-14 dashboard review requests audit information
- **Main flow:** Query a read-only summary of the separate audit store; return recent correlated event summaries and chain-verification status without exposing a mutation path.
- **Alternatives/failure:** If verification is broken, missing, or unavailable, show an explicit integrity/degraded state and preserve actuation lockout; never modify audit records.
- **Requirement trace:** 1.7.1; 1.7.2; 1.8.1; 2.1.3; 2.4.1; 2.6.1
- **Use-case relationship:** Included by UC-14; reads UC-13 history without executing the append behavior.

## UML use-case relationships

The use-case diagram uses UML `include` and `extend` dependencies to show shared required behavior and conditional behavior. Dashed dependency arrows point toward the included or extended use case.

- **UC-02 includes UC-03:** every collection cycle passes observations through quality and process-identity validation.
- **UC-04 extends UC-03 [accepted sample]:** persistence occurs only when validation accepts the sample.
- **UC-07 extends UC-06 [proposal available]:** policy admission is conditional on a proposed action.
- **UC-08 extends UC-07 [policy admits proposal]:** authenticated request validation follows successful policy admission.
- **UC-09, UC-10, and UC-11 each include UC-08:** CPU, RAM, and device-specific I/O writes all require peer authentication and immediate target/policy revalidation before the resource-specific write.
- **UC-12 includes UC-13:** watchdog triggers and recovery outcomes are recorded in the audit history.
- **UC-14 includes UC-17 and UC-18:** the read-only dashboard retrieves operational status/outcomes and the separate audit summary as two distinct projections. UC-17 reads the persisted telemetry/decision projection from UC-04; UC-18 reads the audit history produced by UC-13. These are data-source relationships, not dependencies that execute the write use cases.

The sequence diagrams provide message order, resource-specific checks, and failure paths.


## 3. User stories and acceptance criteria

### US-01
- **Story:** As a host operator, I need readiness checks so unsupported controls stay disabled.
- **Use cases:** UC-01
- **Requirements:** 1.9.1;1.9.4;2.2.3;2.5.1
- **Given / When / Then:** Given unsupported or inaccessible interfaces, when readiness runs, then affected features are reported unavailable and disabled.

### US-02
- **Story:** As AIOS, I need sourced CPU, RAM, I/O, pressure and ordered samples.
- **Use cases:** UC-02
- **Requirements:** 1.1.1;1.1.2;1.1.3;1.1.4;1.1.5;1.1.6
- **Given / When / Then:** Given supported sources, when a sample is emitted, then source/unit/scope and UTC/monotonic ordering are present; unapproved eBPF stays off.

### US-03
- **Story:** As AIOS, I need process identity and data-quality checks so bad evidence cannot drive actions.
- **Use cases:** UC-03
- **Requirements:** 1.2.1;1.2.2;1.2.3;1.2.4;2.2.1
- **Given / When / Then:** Given stale data, reset counters or PID reuse, when validated, then dependent values are rejected and no action is authorized.

### US-04
- **Story:** As an operator, I need bounded telemetry retention and read-only access.
- **Use cases:** UC-04
- **Requirements:** 1.3.1;1.3.2;1.3.3
- **Given / When / Then:** Given retention limits, when storage grows, then DB/WAL remain bounded and dashboard queries cannot actuate.

### US-05
- **Story:** As a model integrator, I need a generic provenance-bound inference boundary without OS privilege.
- **Use cases:** UC-05
- **Requirements:** 1.4.1;1.4.2;1.4.3
- **Given / When / Then:** Given an approved window, when inference returns, then provenance is retained and inference cannot call actuator or write OS controls.

### US-06
- **Story:** As an operator, I need a reasoned LEAVE/propose/deny decision per process/window.
- **Use cases:** UC-06;UC-07
- **Requirements:** 1.5.1;1.5.2
- **Given / When / Then:** Given a proposal, when policy evaluates it, then the result records its reason and all admission gates.

### US-07
- **Story:** As a safety reviewer, I need OBSERVE_ONLY defaults and independent CPU/RAM/I/O gates.
- **Use cases:** UC-01;UC-07
- **Requirements:** 1.5.3;1.5.4;1.5.5;2.2.1;2.2.3
- **Given / When / Then:** Given restart, invalid config or unsupported control, when admission runs, then no forbidden or unauthorized write occurs.

### US-08
- **Story:** As the actuator, I need authenticated IPC and immediate identity revalidation.
- **Use cases:** UC-08
- **Requirements:** 1.6.1;1.6.2;1.6.3;2.1.1;2.1.2
- **Given / When / Then:** Given an untrusted peer or changed target, when a request arrives, then it is rejected before any OS write.

### US-09
- **Story:** As an operator, I need bounded CPU control with readback and guarded restoration.
- **Use cases:** UC-09
- **Requirements:** 1.5.4;1.6.4;1.6.5
- **Given / When / Then:** Given an admitted request, when cpu.weight changes, then prior/new values and verification are recorded; restoration is identity-checked.

### US-10
- **Story:** As an operator, I need RAM control restricted to memory.high.
- **Use cases:** UC-10
- **Requirements:** 1.5.4;1.5.5;1.6.4;1.6.5
- **Given / When / Then:** Given an admitted request, when memory.high is changed, then it is bounded/read back and memory.max/process termination never occurs.

### US-11
- **Story:** As an operator, I need device-aware I/O control and same-device rollback.
- **Use cases:** UC-11
- **Requirements:** 1.5.4;1.5.5;1.6.4;1.6.5;1.7.5
- **Given / When / Then:** Given unsupported or changed device identity, when write/rollback is checked, then no mismatched device control is written.

### US-12
- **Story:** As a safety reviewer, I need an independent watchdog and fail-closed recovery.
- **Use cases:** UC-12
- **Requirements:** 1.7.3;1.7.4;1.7.5;2.2.2
- **Given / When / Then:** Given stale inputs or missed heartbeat, when watchdog triggers, then writes stop and only verified prior values are restored.

### US-13
- **Story:** As a security reviewer, I need correlated tamper-evident audit history.
- **Use cases:** UC-13
- **Requirements:** 1.7.1;1.7.2;2.1.3
- **Given / When / Then:** Given a chain break, when verification runs, then integrity failure is visible and active control is disabled.

### US-14
- **Story:** As a sysadmin/SRE, I need a clear read-only dashboard with no control path.
- **Use cases:** UC-14
- **Requirements:** 1.8.1;1.8.2;1.8.3;2.6.1
- **Given / When / Then:** Given dashboard status, when viewed, then outcomes and data quality are distinct and no write/approval action is possible.

### US-15
- **Story:** As a privacy reviewer, I need least privilege and sensitive fields omitted by default.
- **Use cases:** UC-14;UC-16
- **Requirements:** 2.1.1;2.1.2;2.4.1
- **Given / When / Then:** Given default projections, when host/process data is shown, then opaque aliases are used and command lines, environment, users, paths and payloads are omitted.

### US-16
- **Story:** As an evaluator, I need resource cost and foreground impact measures for threshold setting.
- **Use cases:** UC-15
- **Requirements:** 2.3.1;2.3.2
- **Given / When / Then:** Given an evaluation run, when thresholds are proposed, then CPU/RSS/storage/freshness/latency/impact evidence is recorded first.

### US-17
- **Story:** As a maintainer, I need requirement-level verification and honest implementation status.
- **Use cases:** UC-16
- **Requirements:** 2.7.1;2.8.1
- **Given / When / Then:** Given a release review, when a requirement is checked, then planned verification, implementation and collected evidence are distinguished.

### US-18
- **Story:** As a research team, I need demand hypotheses separated from technical evidence.
- **Use cases:** UC-15;UC-16
- **Requirements:** 2.8.2
- **Given / When / Then:** Given a technical reference, when benefit/need is stated, then it is not represented as participant evidence or validated demand.

### US-19
- **Story:** As an operator, I need optional CPU placement/quotas excluded from safety-critical services.
- **Use cases:** UC-01
- **Requirements:** 1.9.2;1.9.3;2.2.2
- **Given / When / Then:** Given a reviewed profile, when optional affinity/quota is used, then effective mask is checked and watchdog/policy/actuator are not tightly capped.

## 4. Sequence diagrams

Editable Mermaid sequence sources and rendered images are in `01_Diagrams`. These are non-C4 behavior views. Each sequence is mapped to requirement IDs in the behavior traceability CSV.
- **SEQ-01:** Startup and capability readiness
- **SEQ-02:** Collect, validate, and persist samples
- **SEQ-03:** Inference, decision, and policy admission
- **SEQ-04:** CPU guarded actuation
- **SEQ-05:** RAM guarded actuation
- **SEQ-06:** Device-aware I/O guarded actuation
- **SEQ-07:** Watchdog inhibit and guarded rollback
- **SEQ-08:** Read-only dashboard and audit projection

## 5. Safety and scope invariants

- Separate gates: CPU `cpu.weight`, memory `memory.high`, supported device-scoped I/O `io.weight`/`io.max`.
- No `memory.max`, process termination, arbitrary shell, dashboard control, or direct inference-to-actuator path.
- Capture prior value, apply bounded authorized value, read back, and audit. Rollback requires verified cgroup identity and AIOS ownership; I/O also requires device identity.
- Invalid/stale evidence, peer failure, unsupported targets or audit integrity failure blocks new writes.
- Telemetry/decision and append-only audit stores are separate SQLite databases. Dashboard uses read-only projections.
- Model type, algorithm and internal schema remain generic/TBD.
- Requirements remain Draft pending team review, implementation and collected verification evidence.
