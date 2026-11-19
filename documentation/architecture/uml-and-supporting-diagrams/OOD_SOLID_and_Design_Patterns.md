# AIOS Object Design and Software Principles

## Purpose and status

This note explains the proposed object design behind Diagrams 10, 14, and 15. The diagrams use standard notation for their purpose: UML classes for static structure, UML use cases for the human boundary, and the existing activity, sequence, deployment, data-flow, and state notations for runtime behavior. These are design proposals, not claims that the classes or interfaces have already been implemented.

AIOS remains autonomous. A human can only read status, recommendations, operating mode, safety health, and audit projections through the dashboard. There is no user command, action approval, policy edit, or mode-change path to the control plane.

## UML conventions

The class views follow the CSE454 UML lecture conventions: class rectangles with names and only the conceptual attributes needed to explain the model; solid, labeled associations with multiplicities at both ends; and no navigation arrow unless one-way access is an intentional part of the design. Diagram 10 therefore uses plain associations. Diagrams 14 and 15 use dashed dependency arrows for “uses” relationships and hollow-triangle realization arrows where an adapter or service fulfills an interface.

Generalization is reserved for a genuine “is-a” relationship. Aggregation and composition diamonds are omitted because the current design does not specify whole-part lifecycle ownership. Method signatures, API routes, socket message formats, exact SQLite tables, and model-specific fields are omitted because the source material does not define them.

## SOLID and object-oriented design

| Principle | Proposed application in AIOS |
|---|---|
| Single Responsibility | Collection, validation, decision building, policy admission, OS control, audit writing, watchdog supervision, and dashboard projection have separate responsibilities. |
| Open/Closed | New telemetry sources and reviewed resource adapters can be added behind ports. A new control still requires an explicit policy, security review, bounds, and target checks. |
| Liskov Substitution | Every implementation of a port must preserve its safety meaning. Missing or unsupported telemetry stays explicit; an adapter must not turn it into a successful value or bypass bounds. |
| Interface Segregation | Collection writes, inference reads, dashboard reads, audit appends, and audit queries use separate interfaces. The FastAPI viewer has no command or actuator interface. |
| Dependency Inversion | Application services depend on ports. psutil/procfs, optional fixed eBPF probes, SQLite, Unix sockets, FastAPI, and cgroups v2 sit at the edges as adapters. |

Composition and delegation are preferred over inheritance. The design does not force Singleton, inheritance hierarchies, or ownership diamonds where they add no value.

## Patterns selected for this system

| Pattern or approach | AIOS use | Why it fits |
|---|---|---|
| Hexagonal architecture (Ports and Adapters) | Core services depend on telemetry, inference, policy, audit, and actuation ports; platform integrations stay at the boundary. | Keeps Linux and storage details out of decision rules and makes privilege boundaries visible. |
| Adapter | psutil/procfs and optional fixed eBPF inputs; SQLite readers/writers; the Unix-socket client/server; the fixed cgroups v2 resource adapter; and the FastAPI read-only adapter. | Translates external mechanisms to narrow application interfaces without giving each component broad OS access. |
| Repository and read projection | SQLite telemetry and recommendation-projection access are isolated behind repository/read-projection interfaces; audit is separate logical storage. | Separates storage details from business decisions and keeps the viewer query-only. |
| Strategy | `OBSERVE_ONLY` is the default policy strategy; reviewed host-local policy may admit bounded CPU (`cpu.weight`), RAM (`memory.high`), or supported I/O (`io.weight`/`io.max`) control for an approved cgroup, each behind its own gate. | Makes policy variants explicit while preventing the model output or dashboard from choosing privileged controls. |
| Delegation | The collector delegates validation, the policy gate delegates policy choice, and the actuator delegates OS changes to a fixed resource adapter. | Keeps each object small and replaces subclassing where the relationship is “uses,” not “is-a.” |
| Safety supervisor / watchdog | A stale heartbeat or unsafe condition blocks new writes and requests a verified safe fallback through the same guarded local path. | Keeps failure handling explicit and fail-closed; it does not create a dashboard bypass or arbitrary rollback. |

## Diagram assumptions and constraints

Diagram 10 is a conceptual logical model, not an approved database schema. Its multiplicities are proposed to make the expected relationships reviewable. `ProcessInstance` and the proposed PID-plus-start-time identity guard address PID reuse; the exact key, fields, cardinalities, retention, and normalization remain team decisions. Prediction outputs stay generic, with no model type or algorithm internals.

Diagram 14 shows responsibilities and outbound ports for the autonomous control path. Diagram 15 shows the dashboard query boundary and read-only projections. The class diagrams intentionally omit exact method signatures so they cannot be mistaken for approved API contracts. Proposed active control covers bounded `cpu.weight` (CPU), `memory.high` (RAM), and supported `io.weight` or `io.max` (I/O) on approved workload cgroups. Each resource has an independent capability, policy, authorization, bounds, read-back, audit, and guarded-recovery check. Requests still pass Unix-domain-socket peer authentication with `SO_PEERCRED` and actuator-side revalidation. `OBSERVE_ONLY` remains the default; `memory.max`, process termination, and arbitrary commands are excluded. No live action is claimed as implemented.

Optional placement applies to selected non-safety compute services: affinity restricts eligible logical CPUs; CPUQuota is a separate CPU-time ceiling. Neither reserves a physical core. Watchdog, policy, and actuator stay outside an unvalidated tight quota. See AIOS_Diagram_Notation_Audit.md for the current view-by-view review and 11_C4_Architecture/AIOS_C4_Notation_and_Relationship_Review.md for C4 relationship details.
