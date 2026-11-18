# AIOS Software Engineering Presentation — slide and speaker guide

**Presentation:** `AIOS_Software_Engineering_Presentation_Final_2026-11-17_University_Rubric_v4_Source_Diagrams.pptx`  
**Audience:** GP1 midterm committee  
**Talk timing:** 16:05 planned presentation + 3:55 Q&A  
**Visible story:** Slides 1–25  
**Hidden technical backup:** Slides 26–37 (A1–A12)

The deck uses the supplied university template and follows the presentation rubric’s problem/research, related work, method, software design, evidence, plan, and delivery expectations. Cover roster: Ammar, Mazen, Hana, Hany, Noreen. Supervisor: Prof. Dr. Ahmed Younes.

All architecture, sequence, and evaluation plans are **proposed** unless a slide explicitly identifies retained passive collection evidence. Planned tests are not completed tests. The full C4 and sequence diagrams are inserted as images from project renders; they are not recreated from slide shapes.

## Main talk

| Slide | Slide title | Speaking point | Visual / source |
|---:|---|---|---|

| 1 | AIOS — research hypothesis | Introduce the question: can a guarded Linux agent act earlier on resource pressure? State the answer is not yet known. | University cover. Team: Ammar · Mazen · Hana · Hany · Noreen. Supervisor: Prof. Dr. Ahmed Younes. |
| 2 | Linux exposes pressure; the benefit remains open | Explain PSI and configured systemd responses as a baseline. AIOS value must be measured against it. | Linux PSI documentation; research question and talk route. |
| 3 | Monitor all resources; gate each control separately | Frame the product path across CPU, RAM, and I/O. `OBSERVE_ONLY` is default; control requires separate approved checks. | Resource scope and safety boundaries; proposed Ubuntu 24.04 research demonstrator. |
| 4 | AIOS must show added value over the configured baseline | Compare Linux controls, prior systems, and the proposed research layer. Related work guides design; it does not prove AIOS novelty or benefit. | PSI/cgroup v2, systemd and Kubernetes documents; Alicherry & Gopinath, Redline, Caladan. Literature-search scope is stated on slide. |
| 5 | Candidate users and local needs remain unvalidated | Describe candidate operating contexts and identify local needs as evidence still to collect. | Use-case picture; candidate market-context table. No interviews or survey responses are claimed. |
| 6 | C4 system context | Identify the actors, AIOS boundary, Ubuntu host and external host interfaces. | C4 context diagram picture. |
| 7 | C4 shows boundaries and service responsibilities | Walk through collection, telemetry, inference, decision/policy, watchdog, dashboard, actuator, and host interfaces. | C4 container architecture picture; proposed design. |
| 8 | Actuator component view | Show the narrow actuator boundary and its checks before Linux controls. | C4 actuator component diagram picture with compact adjacent tabs and dashed relationships. |
| 9 | Use C4 for architecture, UML for behavior, DFD for data | Explain why each notation is used for its intended view and how the diagrams complement each other. | Notation comparison and sources. |
| 10 | Every proposed resource action follows one guarded path | Trace collection, validation, inference, decision, policy admission, authenticated local IPC, target revalidation, bounded write/read-back, audit and recovery. | Original authenticated-action sequence picture; not rebuilt from slide shapes. |
| 11 | Requirements turn safety claims into checks | Describe SRS v2 and planned negative/fault checks. Make clear the tests are not reported as executed. | 52 hierarchical leaf requirements and acceptance cases. |
| 12 | Dataset plan: target-host runs are primary candidate | Separate the retained passive capture, planned Ubuntu 24.04 runs, auxiliary public traces, and synthetic pipeline stress. No evaluation set is claimed as selected. | Dataset sources and their roles; passive capture proves collection/provenance only. |
| 13 | Evaluate cost and benefit before enabling control | Compare no AIOS, observe-only, and reviewed-control conditions. Measure workload result, overhead, safety, freshness and data quality. | Proposed matched evaluation design; thresholds require team agreement. |
| 14 | Three gates control design through evaluation | Present scope/contract agreement, observe-only integration, then evaluation after safety tests and workload benchmarks. | Three delivery gates; dates/owners require confirmation. |
| 15 | Software design keeps change at the edges | Explain Ports and Adapters, repositories, policy strategy, and watchdog fail-safe boundaries. | Design-pattern / SOLID diagram. |
| 16 | Safety invariants become checks at each boundary | Check identity and freshness, authenticate and authorize, capture baseline, apply bounded action, read back, audit and fail closed. | Five-step safety diagram; CPU/RAM/I/O checks are planned. |
| 17 | Remaining effort and five-person capacity | Distinguish 133–195 PD whole-product baseline from 95–160 PD remaining work. Compare five-person capacity through internal 9 May target and label 31 May sensitivity. | Estimate slide; no PERT or quantified reserve. |
| 18 | Roadmap — agree scope, research, system design | Summarize Sprint 1–4 outcomes and their exit evidence. | Four sprint cards; tentative calendar. |
| 19 | Roadmap — prepare research, data, monitoring | Summarize Sprint 5–8 research, evidence contract, target-data readiness and validated read-only monitoring. | Four sprint cards; data dependencies. |
| 20 | Roadmap — establish monitoring and observe-only policy | Summarize Sprint 9–12; a single CPU `cpu.weight` action remains behind a separate review gate. | Four sprint cards; OBSERVE_ONLY remains default. |
| 21 | Roadmap — gate RAM and I/O, evaluate and release | Summarize separate memory and supported I/O gates, integration/evaluation, then report/demo. | Sprint 13–16 cards; unsupported controls remain recommendations. |
| 22 | Dependencies that protect quality and safety | Describe event/label decisions, collector contract, benchmark readiness, and independent actuator reviews. | Dependency sequence. |
| 23 | Highest delivery risks and response actions | Cover data gaps, evaluation leakage, unsafe action, host/controller drift and scope/capacity risk with trigger and response. | Qualitative risk register; review at Sprint Reviews. |
| 24 | Scrum cadence, ownership and completion rules | Explain two-week planning/review/retrospective, daily coordination, refinement, Ready/Done, team-board roles and two-Sprint reforecast. | Scrum cadence and task dependencies from Notion “To Dos”. |
| 25 | AIOS is testable design, not a proven controller | Close with evidence still required: local need, target baseline, observe-only integration, safety negatives and controlled benchmark. | Closing slide; no measured-benefit claim. |

## Hidden backup slides

Use these after the main talk when a question needs a closer technical view. They are hidden during the normal slide show.

- **A1 — Sequence detail: policy admission** — source project diagram remains an image.
- **A2 — Sequence detail: authenticated write** — source project diagram remains an image.
- **A3 — Sequence detail: recovery and read-only viewing** — source project diagram remains an image.
- **A4 — C4 telemetry collector components** — source project diagram remains an image.
- **A5 — C4 decision/policy and actuator** — source project diagram remains an image.
- **A6 — C4 safety watchdog** — source project diagram remains an image.
- **A7 — C4 dashboard API** — source project diagram remains an image.
- **A8 — UML read-only dashboard classes** — source project diagram remains an image.
- **A9 — C4 dynamic telemetry-to-action** — source project diagram remains an image.
- **A10 — C4 Ubuntu deployment** — source project diagram remains an image.
- **A11 — C4 inference service components** — source project diagram remains an image.
- **A12 — C4 whole-system component overview** — source project diagram remains an image.

## Presenter notes and claim boundaries

- Keep the architecture and component diagrams labeled as proposed design. Do not imply model accuracy, product integration, safe live writes, or performance improvement without run evidence.
- Explain `p95` as the 95th percentile of foreground-task latency; report CPU, memory, and supported I/O together with throughput, controller overhead, data freshness, safety outcomes, and confidence intervals.
- The retained Ubuntu 26.04.1 VM capture has 61 host samples and 19,276 process rows. It supports a collection/provenance claim only; Ubuntu 24.04 target runs remain planned.
- The estimate is for the full bounded monitor → process → predict → decide → act product. It is not only a CPU prototype estimate. The internal 9 May target and five-person availability assumptions are not supervisor-confirmed; 31 May is sensitivity only.
- No PERT calculation or quantified contingency reserve is included. Reforecast after two Sprints with verified Done work.
- The default remains `OBSERVE_ONLY`. CPU, RAM, and supported I/O actions have distinct authorization and recovery gates. No `memory.max`, process termination, or human action-approval path is proposed.

## Source pointers

- Course rubric, presentation instructions and university template: `00_Source_References/`.
- Research and technology source log: `10_Evidence_Closure/Research_Source_Log.csv`.
- C4 views and editable source: `11_C4_Architecture/`.
- UML, DFD and authenticated-action sequence: `01_Diagrams/`.
- Requirements, evidence, estimate, risk and Scrum plan: `02_Requirements/`, `10_Evidence_Closure/`, and this folder’s `AIOS_Software_Engineering_Estimates_Risks_Scrum_Plan.md`.
- Final artifact checks and limits: `AIOS_Software_Engineering_Presentation_QA.md`.

