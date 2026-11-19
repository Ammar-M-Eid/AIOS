# AIOS Final Software Engineering Review

**Review date:** 19 November 2026<br>
**Review basis:** university rubric and template in `00_Source_References`, current SRS and traceability, active C4 and non-C4 diagrams, research/evidence artifacts, team task/dependency snapshot, current schedule, and final presentation.

## Readiness summary

The deliverable set now presents a consistent proposed CPU, RAM, and supported I/O resource-optimizer design. It distinguishes existing artifacts and observed passive collection from proposed services and controls. It does not establish an integrated product, Ubuntu 24.04 validation, model accuracy, safe live actuation, local user demand, or workload benefit.

The SRS is version 2.1 with 52 hierarchical leaf requirements and a detailed traceability register. The behavior package links 18 use cases, 19 user stories, and sequence views. No legacy-ID crosswalk is part of the active requirements baseline.

The estimate covers the whole monitor → process → predict → decide → bounded act → verify/audit product: 133–195 person-days from project start and a provisional 95–160 person-days remaining from Sprint 5. Five-person availability is assumed at 2.5–3.5 focused days per two-week Sprint. Sprints 5–16 provide 150–210 person-days through the internal 9 May 2027 target; nominal capacity is 180. The low case is 10 days short of the high remaining estimate, while nominal capacity has 20 days of headroom. The exact GP2 deadline and team availability remain unconfirmed; 31 May is sensitivity only. No PERT result or quantified reserve is claimed.

## Rubric mapping

| Evaluation area | Supplied weight | Current evidence | Status and limit |
|---|---:|---|---|
| Problem formulation and solution identification | 5 | Problem statement, research question, hypothesis, prior work, alternatives, source register | Local user validation remains open. |
| Proposed design and methodology | 5 | SRS, traceability, C4/UML/DFD set, safety cases, data contract, resource plan, SPMP | Design is prepared; target implementation is not demonstrated. |
| Knowledge/correctness | 2 | Glossary, cited Linux/systemd/C4/UML references, research draft, evidence limits | No model or controller result is established. |
| Presentation delivery | 2 | University-template deck with 25 visible slides, 12 hidden backups, and speaker guide | Rehearsal and live delivery remain. |
| Slide quality | 2 | Version 5 deck with current project diagrams inserted as pictures and updated backup view | Artifact render reviewed; native PowerPoint/font rendering is unverified. |
| Questions and interaction | 2 | Prior work, design choices, risks, open decisions, and safety boundaries | Rehearse answers against evidence and limits. |
| Time management | 2 | Timed presentation plan and GP1 template | Run a team rehearsal and follow supervisor allocation. |

The supplied GP1 template identifies 19 November 2026 as the midterm date. The roadmap specifies GP2 in May 2027 but not an exact final presentation date; confirm the date with the supervisor before treating an internal target as a commitment.

## Architecture and notation

The active C4 set has 14 views: system context, container, six scoped component diagrams, dynamic, deployment, and four focused container-relationship views. All six component diagrams use compact paired upper-left tabs, named required/provided interfaces, and labeled dashed relationships. Dashed connectors and consumer-to-provider direction are project conventions, not universal C4 or UML rules. UML, context, flow, DFD-style, data-model, and schedule views are identified separately.

The proposed control boundary keeps people and the dashboard read-only, separates inference from policy admission, and limits OS mutation to the guarded actuator path. CPU (`cpu.weight`), RAM (`memory.high`), and supported I/O (`io.weight`/`io.max`) are gated independently. `OBSERVE_ONLY` is default. The telemetry/decision store and audit store are separate candidate SQLite databases; hash chaining alone is not described as tamper proof.

## Deliverables ready for review

- SRS v2.1, detailed requirement register, behavior specification, use cases, stories, and linked sequences.
- Active C4 and non-C4 diagrams with editable sources, rendered exports, guides, and notation reviews.
- Proposed telemetry/decision and separate audit-store schemas, EERDs, and design notes; team/security approval remains pending.
- Technology, tool, component, and glossary reference.
- SPMP and estimate/risk/Scrum plan with assumptions and deadline sensitivity.
- Version 5 university-template presentation (25 visible slides, 12 hidden backups), picture-based source diagrams, speaker guide, contact sheet, and QA record.
- Synchronized offline handbook, C4 ZIP, project ZIP, and package manifest.

## Actions for the next delivery period

1. Confirm team availability, accountabilities, supervisor-approved scope, and the exact GP2 assessment date.
2. Ratify or revise the remaining-work range after checking the task board; preserve the difference between forecast and committed scope.
3. Confirm the local-need research method, consent/ethics path, and authorized Ubuntu 24.04 host/data access.
4. Agree the physical schema, inference payload, retention/migration policy, audit-chain handling, and resource-specific policy with the relevant owners.
5. Freeze telemetry fields and event labels before model comparison.
6. Integrate and measure the monitor/predict/policy path in `OBSERVE_ONLY`; consider each writer only after its independent safety gate is reviewed and evidenced.
7. Reforecast from completed work and observed capacity after two Sprints.

See `10_Evidence_Closure/Package_Quality_Review.md` for release checks and `12_Engineering_Review/Final/AIOS_Software_Engineering_Estimates_Risks_Scrum_Plan.md` for schedule assumptions and sources.
