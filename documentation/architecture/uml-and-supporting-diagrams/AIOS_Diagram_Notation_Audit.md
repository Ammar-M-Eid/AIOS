# AIOS Diagram Notation Audit

**Review date:** 18 November 2026  
**Scope:** 24 numbered supporting views in this folder, 14 C4 views in `11_C4_Architecture`, and the project Gantt view.  
**Review basis:** UML 2.5.1 from OMG, official PlantUML and Mermaid syntax guides, C4 notation guidance, and visual inspection of the rendered exports.

This audit checks whether each view uses a notation suited to its purpose, whether relationships point and read correctly, and whether labels and legends explain the diagram. It reviews design artifacts only. A diagram does not prove that a service, interface, control, deployment, or safety property is implemented or validated.

## Notation boundary

UML is used for static structure and runtime behavior that benefit from UML semantics. C4 is used for architecture-level context, container, component, dynamic, and deployment views. Other diagrams retain their own project purpose: context maps, flowcharts, a DFD-style security view, and a Gantt schedule. C4 is notation-independent; its views are not UML diagrams merely because they use boxes and arrows. Dashed relationships across the C4 set are a project-wide visual convention, not a C4 requirement.

## Numbered software-engineering diagrams

| ID | View | Notation | Review result |
|---|---|---|---|
| 01 | Operational context and product boundary | Project context map | Labeled, directed product/host interactions; the note distinguishes it from C4 and UML. Human access ends at the read-only dashboard. |
| 02 | High-level process-aware architecture | Architecture flow map | Labeled service, storage, control, and viewer relationships; query and returned-data directions are distinguished. It is not presented as UML. |
| 03 | Component and responsibility diagram | UML component diagram (PlantUML) | UML component symbols; dashed open-arrow dependencies point from client to supplier. Legend identifies static dependency meaning and directs readers to the sequence view for ordering. |
| 04 | Autonomous behavior and read-only human interactions | UML use-case diagram (PlantUML source; canonical rendered SVG/PNG/JPG) | Named system boundary, actor, and 18 use cases. The human association reaches only UC-14 read-only oversight. Dashed open-arrow UML dependencies connect collection/validation, accepted-sample persistence, decision/policy admission, authenticated CPU/RAM/I/O control, watchdog/audit recording, and UC-14 to both read-only projections it consumes: UC-17 operational status/outcomes and UC-18 audit summary/verification. UC-17/18 identify UC-04 and UC-13 data sources without incorrectly invoking their write behaviors. |
| 05 | Autonomous telemetry-to-control cycle | UML activity diagram (PlantUML) | Actions, decision nodes, guarded alternatives, and terminal paths model the lifecycle and fail-closed checks. Diagram 06 expands distinct CPU, RAM, and supported I/O capability gates; watchdog ordering and recovery are cross-referenced to the sequence view. |
| 06 | Per-process decision and independent safety gates | Project decision flowchart (Mermaid) | Labeled directed flow; CPU, RAM, and I/O capability/bounds checks are separate. Watchdog recovery reuses the authenticated path and checks target/baseline before a write. It is not labeled UML. |
| 07 | Authenticated action and recovery | UML-style sequence diagram (Mermaid) | Lifelines, ordered messages, dashed replies, and guarded `alt`/`opt` fragments. The message sequence is proposed; payload contracts remain unspecified. |
| 08 | Proposed Ubuntu single-host placement | UML deployment diagram (PlantUML) | Host and client are `device` nodes; Linux is an `executionEnvironment`; service/configuration/data items are artifacts; the viewer path is a plain communication path. Host-provided APIs are described as dependencies, not as AIOS-deployed artifacts. |
| 09 | Data flow and trust boundaries | DFD-style flow and trust-boundary view (Mermaid) | Data/control flows are labeled, solid, directed arrows; stores and trust boundaries have a key. The view combines data-flow and security-boundary information and is not claimed as a normative UML or pure DFD model. |
| 10 | Resource monitoring and action audit model | Conceptual UML-style class diagram (Mermaid) | Class compartments, associations, and multiplicities are used. Multiplicities are explicitly conceptual, not an approved SQLite schema. |
| 11 | Operating and recovery modes | UML-style state machine (Mermaid) | Initial state, named states, guarded transitions, and transition effects are shown. Recovery returns to `OBSERVE_ONLY`; it does not silently re-enable control. |
| 12 | Action catalog and actuator guard | Project action flowchart (Mermaid) | Labeled branches distinguish recommendation, denial, per-resource control, and guarded recovery. Unsupported controls do not proceed to an OS write. |
| 13 | Optional CPU-affinity profile | Deployment-choice flowchart (Mermaid) | Affinity, `CPUQuota`, and physical-core isolation are treated as different choices and evaluated against a common measurement/safety gate. It is not presented as a UML deployment diagram. |
| 14 | Application services and ports | UML-style class diagram (Mermaid) | Dashed open-arrow dependencies point to required ports; dashed hollow-triangle realizations point from implementers to interfaces. The classes and ports are proposed, with signatures intentionally omitted. |
| 15 | Read-only dashboard query boundary | UML-style class diagram (Mermaid) | The API adapter depends on a query port; the service realizes it and depends on separate read ports; storage adapters realize those ports. No write/control port is exposed. |
| 16 | Startup and capability readiness | UML-style sequence diagram (Mermaid) | Shows service startup, capability reporting, safe OBSERVE_ONLY initialization, and fail-closed handling of invalid profiles or failed safety checks. |
| 17 | Sample collection, quality, and persistence | UML-style sequence diagram (Mermaid) | Shows resource collection, timestamp and process identity, quality checks, bounded local persistence, and stale/invalid evidence handling. |
| 18 | Inference and policy admission | UML-style sequence diagram (Mermaid) | Shows provenance-bound generic inference, per-process LEAVE/propose/deny evaluation, independent policy gates, and audit outcomes. |
| 19 | CPU guarded actuation | UML-style sequence diagram (Mermaid) | Shows local IPC, SO_PEERCRED, immediate revalidation, prior cpu.weight capture, bounded write, readback, and guarded recovery. |
| 20 | RAM guarded actuation | UML-style sequence diagram (Mermaid) | Shows bounded memory.high control and verification; memory.max and process termination are excluded. |
| 21 | Device-aware I/O actuation | UML-style sequence diagram (Mermaid) | Shows supported-controller/device checks, device-scoped io.weight/io.max, readback, and same-device guarded recovery. |
| 22 | Watchdog inhibit and rollback | UML-style sequence diagram (Mermaid) | Shows independent heartbeat/freshness checks, write inhibition, identity-checked recovery, audit, and preservation of Linux-native behavior. |
| 23 | Dashboard and audit projection | UML-style sequence diagram (Mermaid) | Shows read-only queries against separate telemetry/decision and audit SQLite databases, privacy projection, and explicit quality states. |
| 24 | UC-14 read-only interaction detail | UML use-case detail with UML dependencies and data-source dependencies (PlantUML source; canonical rendered SVG/PNG/JPG) | UC-14 includes UC-17 operational status/outcomes and UC-18 audit summary/verification. Dotted dependencies show UC-17 reading UC-04 persisted telemetry/decision data and UC-18 reading UC-13 audit history; the separate line style distinguishes these source dependencies from UML include/extend dependencies. |

## C4 architecture views

| IDs | View | Review result |
|---|---|---|
| 01–02 | System context and container architecture | C4 element types, responsibilities, relationships, and technology/protocol labels are provided where known. Human access remains read-only. |
| 03, 06–11 | Six scoped component views and the whole-system component inventory | Seven views contain 62 displayed component glyphs representing 31 unique components. Each component uses the requested compact UML1 double-tab glyph. The six scoped views show labeled, dashed interface arrows; the whole-system view inventories components without duplicating the network. All 20 cross-container connections are visible on C4 container diagram 02. |
| 04 | Dynamic telemetry-to-action scenario | C4 supporting dynamic view shows a numbered nominal accepted action. Rejection and recovery branches are covered in the UML activity/sequence views. |
| 05 | Ubuntu deployment view | C4 deployment view shows proposed instance placement. It is distinct from the UML deployment view in Diagram 08. |

## Cross-view consistency checks

- Resource scope is consistent across the views: proposed bounded CPU (`cpu.weight`), RAM (`memory.high`), and supported I/O (`io.weight` or `io.max`) controls each require a separate capability and safety gate. Unsupported actions remain recommendations; `memory.max`, process termination, and arbitrary shell commands are excluded.
- The dashboard remains read-only. No view provides a human command, approval, policy-edit, mode-change, or actuator path.
- Telemetry/decision and append-only, hash-chained audit data are separate SQLite databases. Read requests and returned data are distinguished where a view shows a query interaction.
- Normal actions and watchdog recovery pass through the same authenticated local actuator boundary. The actuator rechecks peer identity, target ownership, and bounds; recovery also verifies the captured baseline before restoring it.
- `OBSERVE_ONLY` is the default. All service boundaries, interfaces, and deployment placement remain proposed unless implementation evidence says otherwise.

## Verification record

The 24 numbered supporting sources are rendered to SVG, PNG, and JPG. The eight new sequences are linked through `02_Requirements/AIOS_Requirement_Behavior_Traceability.csv`; the requirement catalog, use cases, and stories are in the companion behavior specification and CSV catalogs. The current contact sheet was rebuilt from the rendered sources. C4 images remain canonical in `11_C4_Architecture`; this extension does not recreate them. Final diagram documents should use the canonical image exports rather than drawing their own versions of the diagrams.

## References

- OMG, [Unified Modeling Language 2.5.1](https://www.omg.org/spec/UML/2.5.1/PDF) — normative UML specification.
- PlantUML, [component diagrams](https://plantuml.com/component-diagram), [activity diagrams](https://plantuml.com/activity-diagram-beta), [sequence diagrams](https://plantuml.com/sequence-diagram), and [deployment diagrams](https://plantuml.com/deployment-diagram).
- Mermaid, [class diagrams](https://mermaid.js.org/syntax/classDiagram.html), [sequence diagrams](https://mermaid.js.org/syntax/sequenceDiagram.html), and [state diagrams](https://mermaid.js.org/syntax/stateDiagram.html).
- C4 Model, [notation](https://c4model.com/diagrams/notation) and [diagram review checklist](https://c4model.com/diagrams/checklist).


## Visual review — 19 November 2026

- Refreshed the numbered diagram raster exports and rebuilt the contact sheet from the current SVGs.
- Updated the responsibility overview, UML component overview, and UML deployment overview with consistent title/body typography, stronger boundary contrast, and aligned node placement. The C4 views remain in 11_C4_Architecture and are authoritative for detailed C4 relationships.
- Reviewed the use-case, activity, sequence, data-flow, data-model, state, and class views in the refreshed contact sheet for terminology and CPU/RAM/I/O and safety-boundary consistency.
- The architecture remains proposed. Host support, I/O-controller availability, deployment separation, and rollback behavior still require validation on Ubuntu.
