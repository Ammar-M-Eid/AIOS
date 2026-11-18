# AIOS Software Engineering — Full-Product Estimate, Risk Register, and Scrum Plan

**Revision:** Deadline-fit reforecast, 17 November 2026  
**Status:** Detailed estimate and risk companion. The controlling Scrum roles, capacity rules, 16-sprint calendar, risk scoring, Definition of Done and course alignment are in `06_Project_Management/AIOS_Software_Project_Management_Plan.docx`. The official GP2 final date and team availability remain unconfirmed; 9 May is an internal target and 31 May is sensitivity only.  
**Planning evidence:** Team Notion “To Dos” page, read 15 November 2026; project SRS, architecture, safety notes, evidence register, and Ubuntu collection evidence. Notion provides task ownership and dependencies, but no calendar due dates, measured velocity, or effort history.

## 1. Direct answer and product scope

**Yes, this revision estimates the final monitor → process → predict → decide → safely act product.** The previous 79–106 person-day estimate was for a recommendation-only prototype; it did not include completing the resource actuators. It is superseded by this full-product estimate.

The estimate covers a **single-host, Ubuntu 24.04 research demonstrator** that:

1. Monitors CPU, memory, and I/O pressure and relevant host/cgroup/process telemetry.
2. Validates, normalizes, stores, and exposes the telemetry through a read-only dashboard/API.
3. Evaluates and integrates per-resource prediction for CPU, memory, and I/O, with documented baselines and held-out-run evaluation.
4. Sends predictions through a separate decision/policy service; model output cannot select or execute a privileged operation.
5. Applies bounded actions only to explicitly approved cgroups and only when the host supports the control.
6. Verifies writes by reading values back, records an audit event, and provides a guarded recovery/rollback path.

**Action scope assumed:** CPU `cpu.weight`; memory `memory.high` only; I/O `io.weight` and/or `io.max` only when the target kernel/controller supports the requested operation. Actions require explicit authorization, allow-listed cgroups, target/identity checks, bounds, cooldowns, read-back, audit, and rollback. The initial mode remains `OBSERVE_ONLY`; actions are introduced in isolated stages only after the relevant safety and security gate passes. Unsupported or unsafe operations fall back to a recommendation. **No `memory.max`, process killing, arbitrary shell command, or model-to-actuator bypass is included.**

The estimate does not include multi-host/fleet operation, high availability, unrestricted production deployment, broad kernel compatibility, commercial support, or production hardening beyond what is needed to test the bounded research demonstrator. A research prototype is not represented as a proven or production-ready controller.

## 2. Estimation method and range

This is a bottom-up, range-based estimate: work was decomposed from the team task board, system path, resource controls, integration boundaries, acceptance evidence, and named owners. A person-day means eight focused hours of project work, including engineering, integration, testing, review and evidence work. Low and high bounds reflect unresolved dataset quality, kernel/controller support, integration effort, and the security review of privileged writes. These are planning judgments, not statistical confidence intervals and not measured team velocity. No PERT calculation or contingency reserve is included. A previously stated flat 15% uplift (153–225 person-days) had no project-specific evidence and is withdrawn.

| Work package | Included outcomes | Effort (person-days) | Primary owners from Notion |
|---|---|---:|---|
| Product scope, requirements, research, and threat model | Target scenario, measurable requirements, design decisions, safety boundary, evidence and threat review | 23–30 | All five; Ammar; Mazen |
| Data contracts, datasets, event labels, and baselines | Versioned telemetry/prediction schemas; CPU/memory/I/O labels; data inventory; run-safe splits; baseline protocol | 20–29 | AI owners; Ammar; Hana |
| Monitoring, processing, storage, and read-only dashboard | Host adapters, validation, normalization, persistence, quality state, query-only views/API | 20–28 | Ammar; Hana; Hany; Noreen |
| CPU, memory, and I/O predictors with offline evaluation | Per-resource baselines/candidates, held-out evaluation, metrics, limitations and evidence | 18–28 | Hany; Noreen; Hana |
| Policy service and bounded CPU/memory/I/O actuators | Policy admission, authorization, approved cgroup writes, per-controller bounds and cooldown, read-back/audit | 20–32 | Ammar; Mazen; resource owners |
| Integration, Ubuntu deployment, safety tests, and rollback | End-to-end integration, fault behavior, controller capability checks, recovery, repeatable host evidence | 24–36 | All five; Ammar; Mazen |
| Evidence, documentation, review, and presentation | Traceable results, updated diagrams/docs, team review, demo and rehearsal | 8–12 | All five |
| **Base estimate** | **Complete bounded single-host product scope above** | **133–195** | |
| **Contingency reserve** | **Not quantified; no supported buffer is included** | **TBD** | |

Before approving a contingency, the Developers should estimate optimistic, most-likely, and pessimistic effort by work package and review quantified risk exposure. PERT expected effort `(O + 4M + P) / 6` may be used after those estimates are agreed; the current 133–195 range is not a PERT result. Avoid double-counting the same uncertainty in both a range and a reserve.

### Capacity and schedule assumptions

- Whole-project forecast: **16 proposed two-week sprints from 28 September 2026 through the internal 9 May 2027 target**. The supplied course plan gives only “May 2027” for GP2; 10–31 May is a sensitivity window, not a confirmed course-date or contingency buffer. The 19 November 2026 GP1 midterm is the only fixed assessment date in the supplied materials.
- Whole-project capacity assumption: five contributors × 2.5–3.5 focused project days per Sprint = **12.5–17.5 team person-days per Sprint**, or **200–280 across all 16 planned Sprints** if availability is sustained. This historical whole-plan calculation does not establish remaining capacity; the separate Sprint 5–16 comparison below is the deadline-fit forecast. Confirm the roster and actual academic availability; no capacity is credited to an unconfirmed sixth member.
- Against the whole-project base range, 200 person-days at low availability leave only 5 days above the 195-day upper estimate; the 15-day working case yields 240 days, 45 above that upper estimate. These totals assume capacity across all 16 proposed Sprints and cannot be reused as the remaining-work margin. For the current deadline-fit comparison, use the 95–160 person-day remaining range and Sprints 5–16 below. No reserve is included; do not reduce safety or evaluation work to fit.
- Count Scrum event time within project capacity. Account for academic commitments and holidays before each Sprint forecast. The task board has no completed-point history or effort record; after two consecutive Sprints with verified Done items and known capacity, use observed throughput and reforecast. If the updated estimate plus any explicitly approved contingency exceeds remaining capacity to the course window, extend the forecast or agree a scope change.

## 2.1 Remaining-work reforecast and five-person deadline fit — 17 November 2026

The **133–195 person-day** range above remains the bottom-up estimate for the complete product from project start, including bounded CPU, RAM and supported I/O control. It cannot by itself answer whether the remaining calendar is sufficient because the team has no completed-effort or velocity ledger. The table below is a provisional, evidence-informed re-estimate of work still open from **Sprint 5 (23 November 2026)**. It is a planning range, not a measured estimate at completion, statistical confidence interval, PERT result, or team-approved commitment. Existing requirements, diagrams, a read-only collector, dashboard wireframe, and passive Ubuntu VM capture are documentary/design evidence; they do not establish integrated implementation, target Ubuntu 24.04 validation, predictors, live actuation, or safety results.

| Remaining work package | Person-days | Evidence and remaining work |
|---|---:|---|
| Product framing, requirements and threat decisions | 5–10 | Draft SRS, scope and design exist; team/supervisor acceptance, workload, target-host and research decisions remain. |
| Data contracts, datasets, labels and baselines | 10–20 | Schema draft and passive VM sample exist; authorized Ubuntu 24.04 data, labels, run-safe splits and baseline evidence remain. |
| Integrated monitoring, processing, storage and read-only dashboard | 15–25 | Read-only collector and wireframe exist; integrated adapters, processing, persistence, query views and target checks are not evidenced. |
| CPU, RAM and I/O predictors with offline evaluation | 15–30 | No per-resource predictor or held-out target evaluation is evidenced; build baselines, compare candidates and report data limits. |
| Policy service and bounded CPU/RAM/I/O actuation | 20–30 | Architecture is specified; live writes are not evidenced. Implement and separately gate `cpu.weight`, `memory.high`, and supported `io.weight`/`io.max`. |
| Integration, Ubuntu 24.04 deployment, safety tests and rollback | 25–35 | End-to-end integration, authorized target validation, fault handling, read-back, audit and recovery evidence remain. |
| Final evidence, report, review, demo and handoff | 5–10 | Design documents and GP1 deck exist; final results, report, measured claims and GP2 demonstration remain. |
| **Remaining base range** | **95–160** | Provisional; team ratification required. No PERT calculation and no quantified contingency reserve. |

### Capacity comparison

Assumption: five contributors each provide 2.5, 3.0, or 3.5 focused project days per two-week Sprint, after academic commitments and including Scrum-event time. Sprints 5–16 give **12 remaining Sprints** from 23 November to the **internal 9 May target**. The project roadmap says only “May 2027” for GP2; no exact GP2 final presentation date appears in the supplied sources. AIU’s official policy says the annually issued academic calendar provides exact semester, exam and holiday dates; the current exact GP2 date is therefore an open decision [official policy](https://aiu.edu.eg/wp-content/uploads/2024/07/16-Academic-calendar-Policy.pdf).

| Scenario | Calculation | Capacity | Balance against high remaining estimate (160 PD) |
|---|---:|---:|---:|
| 9 May internal target — low | 12 × 5 × 2.5 | 150 PD | −10 PD |
| 9 May internal target — nominal | 12 × 5 × 3.0 | 180 PD | +20 PD |
| 9 May internal target — high | 12 × 5 × 3.5 | 210 PD | +50 PD |
| 31 May sensitivity — low | 13.5 × 5 × 2.5 | 168.75 PD | +8.75 PD |
| 31 May sensitivity — nominal | 13.5 × 5 × 3.0 | 202.5 PD | +42.5 PD |
| 31 May sensitivity — high | 13.5 × 5 × 3.5 | 236.25 PD | +76.25 PD |

At low availability, the remaining estimate misses the 9 May internal target by 10 person-days before any reserve. The nominal case leaves 20 person-days above the high estimate; that headroom is **not a contingency reserve**. The 31 May case is a sensitivity, not an approved course deadline. Confirm the official GP2 date and each member’s availability during Sprint 5, then replace assumptions with observed results after two Sprints containing verified Done items. Do not reduce per-resource safety gates, evaluation or required evidence to make the plan appear to fit.

### Immediate GP1 checkpoint — 19 November 2026

Before the fixed midterm presentation, confirm names and speaker order, complete a timed rehearsal on the presentation machine, and verify all diagram images at presentation size. Afterward, record supervisor feedback and place resulting work into the ordered Sprint 5 backlog. This checkpoint is separate from the remaining implementation estimate.

## 3. Sixteen-sprint course-aligned roadmap

Sprints are proposed two-week increments from 28 September 2026 through 9 May 2027. Detailed Scrum accountabilities, estimation practice and evidence-based status rules are in the controlling SPMP. Sprints 1–3 have passed on this proposed calendar and Sprint 4 is in progress as of 17 November; reconcile task status against the board and Definition of Done before reporting completion.

| Sprint / window | Sprint Goal | Increment and exit evidence |
|---|---|---|
| **1 — 28 Sep–11 Oct 2026** | Align on Product Goal, roster, project type and ordered backlog. | Team agreement, open decisions and evidence rules recorded. |
| **2 — 12–25 Oct 2026** | Prove the problem and research framing. | Traceable problem/objectives, alternatives, literature and evidence gaps. |
| **3 — 26 Oct–8 Nov 2026** | Agree requirements and system boundaries. | Reviewed SRS, interfaces, safety boundaries and acceptance checks. |
| **4 — 9–22 Nov 2026** | Present a credible GP1 midterm. | Rubric-mapped design/problem evidence, timed rehearsal and feedback; fixed midterm 19 Nov. |
| **5 — 23 Nov–6 Dec 2026** | Close the first-term research package. | Draft with objectives, literature, methodology and starting implementation evidence. |
| **6 — 7–20 Dec 2026** | Freeze the shared evidence contract. | Dataset/schema inspection, units, labels, privacy, run IDs and splits reviewed. |
| **7 — 21 Dec 2026–3 Jan 2027** | Secure target-data readiness. | Approved Ubuntu 24.04 access/workload plan or a documented blocker and advisory fallback. |
| **8 — 4–17 Jan 2027** | Build the validated monitor path. | Read-only adapters, quality/freshness/identity checks and repeatable target sample. |
| **9 — 18–31 Jan 2027** | Make monitoring inspectable. | Bounded persistence and query-only health/history views; overhead measured. |
| **10 — 1–14 Feb 2027** | Establish per-resource prediction baselines. | CPU/memory/I/O held-out-run metrics and leakage checks, or documented data limits. |
| **11 — 15–28 Feb 2027** | Integrate guarded inference/policy in observe-only mode. | Recommendation trace, freshness/allow-list/LEAVE checks; actuator remains disabled. |
| **12 — 1–14 Mar 2027** | Gate and test the first bounded CPU control increment. | Isolated `cpu.weight` capability, authorization, bounds, read-back, audit and rollback evidence; later increments add independently gated RAM and I/O controls or keep unsupported actions advisory. |
| **13 — 15–28 Mar 2027** | Gate memory control separately. | `memory.high` isolated evidence or no-write decision; never use `memory.max`. |
| **14 — 29 Mar–11 Apr 2027** | Gate I/O control separately. | `io.weight`/`io.max` capability/bounds/recovery evidence or advisory fallback. |
| **15 — 12–25 Apr 2027** | Evaluate the integrated product and risks. | End-to-end, failure, restart, stale-data, permission, safety, overhead and benefit results. |
| **16 — 26 Apr–9 May 2027** | Complete report and course-ready release. | Final paper/report, diagrams, provenance, demo, handoff and unresolved-risk log. |

## 4. Dependency and safety gates

1. Agree resource event definitions, inputs, labels and prediction targets **before** choosing models.
2. Inspect data and freeze the versioned collector/schema contract **before** training.
3. Split by complete workload/run IDs; fit preprocessing on training data only; retain a blind final test.
4. Keep inference separate from policy admission and the privileged actuator.
5. Require a resource-specific security/policy review and an approved Ubuntu target before live writes. Start in `OBSERVE_ONLY`; enable one resource at a time on isolated approved cgroups.
6. Require a bounded write, read-back verification, audit event and tested recovery path for each admitted action. If the target, permissions, evidence, or actuator state is uncertain, fail closed and remain non-actuating.

The ordering follows the dependencies recorded in the Notion task page. CPU, memory and I/O actuator readiness are separate gates; passing one does not authorize the others.

## 5. Risk register

These qualitative likelihood/impact labels are initial judgments (H = high, M = medium, VH = very high), not measured probabilities. The SPMP carries the controlling 1–5 scoring and response cadence. Reassess likelihood, impact, owner and mitigation status at every Sprint Review.

| Risk | Initial rating | Early warning | Response / owner |
|---|---|---|---|
| Dataset lacks PSI, run IDs, useful labels or a relevant workload | H / H | Schemas cannot support the agreed event definition or target horizon. | Inspect schemas in Sprint 2; collect safe local data where feasible; mark mismatched public data as auxiliary; narrow claims. **Hana, Noreen.** |
| Evaluation leakage or unstable labels exaggerate performance | M / H | Related samples cross splits; preprocessing uses test data; labels vary by run. | Split by complete run; train transformations only on training data; blind final test; report event-level metrics. **Hany, all AI owners.** |
| Unsafe or unauthorized privileged write | M / VH | Model can bypass policy; stale identity; unapproved cgroup; write lacks verified recovery. | `OBSERVE_ONLY` default; strict allow-list/auth/bounds; read-back, audit, rollback; negative and fault tests; no process killing or `memory.max`. **Mazen, Ammar.** |
| Ubuntu kernel/controller/device does not support an assumed control | M / H | Expected cgroup files or semantics absent or differ on target. | Capability-detect on Ubuntu 24.04; test each controller/device; pin contract; unsupported operation returns recommendation. **Ammar, resource owners.** |
| Action is supported but harms workload or causes oscillation | M / VH | Repeated reversals, worse latency/throughput, growing pressure or recovery. | Stage one resource at a time; cooldown/hysteresis and action limits; matched workload baseline; monitor recovery; disable on guardrail breach. **AI owners, Mazen, Ammar.** |
| Telemetry/prediction contract drifts during parallel work | M / H | Units, timestamps, null semantics, identity or payload fields diverge. | Version schema before training; shared fixtures and contract review; integration checks at each merge. **Ammar and all AI owners.** |
| Audit, watchdog, or recovery fails during restart/disk pressure | M / H | Missing audit event, stale recovery state, WAL growth or uncertain previous value. | Define fail-closed behavior; bounded storage/rotation; restart and disk-failure tests; surface degraded state; retain immutable run manifests. **Ammar, Mazen.** |
| Remaining effort, academic schedule or an unconfirmed GP2 date exceeds capacity | H / H | Confirmed GP2 date precedes the internal 9 May target, actual availability is below the assumption, or the reforecast exceeds capacity. | Confirm date and availability in Sprint 5; compare the provisional 95–160 PD remaining range with capacity; reforecast after two verified Sprints; extend or agree an explicit scope decision while protecting safety and evaluation. **All five + supervisor.** |

## 6. Scrum working agreement

### Two-week cadence

- **Sprint Planning (Day 1):** agree one Sprint Goal; select work to confirmed team capacity; expose dependencies, owners, acceptance checks and evidence path.
- **Daily Scrum:** 15 minutes for Developers on every working day, focused on progress toward the Sprint Goal and the next actionable plan. An asynchronous status post may support coordination but is not labelled the formal event unless the team explicitly documents an adaptation.
- **Backlog refinement (ongoing, usually weekly):** split oversized items; clarify outcome, test/evidence, dependency and size. Refinement is not a formal Scrum event.
- **Sprint Review (final day):** inspect the working increment and evidence with stakeholders; invite the supervisor when available; revise the ordered backlog from feedback.
- **Sprint Retrospective (final day):** choose one improvement, name its owner and set a follow-up check.

### Ownership and decisions

- The task list maps Noreen to scope/methodology/narrative; Hana to I/O/data evidence; Hany to CPU/baselines/metrics; Ammar to software engineering/collector/integration/diagrams/Gantt; Mazen to cybersecurity/safety/policy review. These are domain coordination leads, not formal Scrum accountabilities.
- All three AI owners agree shared labels, run-safe splits and comparison protocol. All five review technical claims and rehearse.
- The Notion snapshot does not appoint a formal Product Owner or Scrum Master. The current SPMP proposes candidates for team ratification; one person must own Product Backlog ordering and one must serve Scrum Master accountability. The supervisor is a stakeholder unless the team explicitly decides otherwise.

### Definition of Ready

A task has a clear user or engineering outcome, one accountable owner, acceptance and evidence checks, visible dependencies/blockers, an estimate range/confidence, and agreed prerequisites. Actuator work also has a named resource owner, target capability, authorization, bounds, and recovery criteria before implementation.

### Definition of Done

Acceptance checks pass or the gap is recorded; implementation and evidence artifacts are reviewable; required diagrams, sources and status are current; a peer reviews the result; claims are labeled planned, built, or measured; and no unsafe failure path enables action. A task is not done merely because it has an owner or a diagram.

## 7. Evidence and references

The estimate is derived from the team’s backlog and architecture, not from paper productivity claims. Technical sources support the scope and validation gates; they do not prove that the proposed controller works or improve workload outcomes. Final performance and safety claims require the team’s own target-host run artifacts.

- Team responsibilities and dependencies: [Notion — To Dos](https://app.notion.com/p/To-Dos-41554a70b00d80ee8387f69376297f4b).
- Sprint events and empiricism: [The Scrum Guide (2020)](https://scrumguides.org/scrum-guide.html).
- Linux pressure-stall information: [Linux PSI documentation](https://docs.kernel.org/accounting/psi.html).
- Resource-control semantics and controller files: [Linux cgroup v2 documentation](https://docs.kernel.org/admin-guide/cgroup-v2.html). Validate exact behavior against the target Ubuntu kernel; support is capability-dependent.
- Related coordinated CPU/memory/I/O management: Yang et al., [“Redline: First Class Support for Interactivity in Commodity Storage Clusters” (OSDI 2008)](https://www.usenix.org/legacy/event/osdi08/tech/full_papers/yang/yang_html/). This is related systems research, not evidence of AIOS effectiveness or a direct implementation template.
- Resource-control research context: Fried et al., [“Caladan: Mitigating Interference at Microsecond Timescales” (OSDI 2020)](https://www.usenix.org/conference/osdi20/presentation/fried). Its specialized design is not a drop-in baseline for this project.
- Diagram notation sources: [C4 notation](https://c4model.com/diagrams/notation) and [OMG UML 2.5.1](https://www.omg.org/spec/UML/2.5.1). C4 is used for architecture communication; UML/DFD remain responsible for behavior and data movement.

## Revision note

This document supersedes the earlier recommendation-only estimate of 79–106 person-days, which did not include the final product’s resource actuators. A previously stated 91–122 figure added an unsupported reserve and is also withdrawn. The present 133–195 person-day base range explicitly includes bounded CPU, memory and I/O actuation and the integration, safety, verification and recovery work needed around it.
