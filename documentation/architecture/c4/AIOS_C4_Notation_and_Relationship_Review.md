# AIOS C4 Notation and Relationship Review

## Review basis

This review applies C4 semantics to the service-oriented AIOS architecture. C4 distinguishes software systems, containers (runnable applications or data stores), and components (responsibilities inside one container). C4 is notation-independent; concrete shapes, dashed connectors, and UML ports below are explicit project conventions used to clarify element type, direction, and interfaces.

## Scope by view

| View | Correct scope | AIOS use |
|---|---|---|
| System Context | One system and its users/external systems | AIOS, Sysadmin/SRE, selected workloads, Ubuntu/Linux host |
| Container | Deployable applications and data stores inside the system, plus external systems | Six service processes plus telemetry and audit stores; remaining relations are in focused container views |
| Component | Components inside one selected container | Six separate views: actuator, collector, inference, policy, watchdog, dashboard |
| Dynamic | Ordered interactions for a scenario | One representative telemetry-to-action path; not a substitute for static architecture |
| Deployment | Software containers mapped to deployment nodes | Proposed Ubuntu 24.04 single-host profile |

The active diagrams follow the earlier service-oriented baseline and do not group components into horizontal layers. A composite whole-system component map and the later functional-only experiment are historical artifacts under `qa_render/`, not active C4 views.

## Element notation

- **Person:** a stick-figure person labeled with role and access scope.
- **Software system / external software system:** a labeled rectangular box; the system boundary is shown separately.
- **Application container:** a rounded rectangle labeled with the container type, technology, and responsibility.
- **Database container:** a cylinder labeled with the database technology and responsibility. The telemetry/read-projection store is SQLite, so it uses the cylinder symbol.
- **Database stores:** the telemetry/decision data and append-only, hash-chained audit records are separate SQLite databases. Both are drawn with database-cylinder notation. The hash chain describes record integrity and does not make the audit database a filesystem directory.
- **Component:** a UML1 component rectangle with two compact upper-left tabs, plus required/provided interfaces where shown.
- **Relationships:** one-way, labeled, dashed arrows; dashed lines are a project convention rather than a C4 rule.

C4 is notation-independent, so the cylinder for SQLite, folder for filesystem logs, person glyph, paired component tabs, palette, and dashed-arrow style are explicit project choices. They make the element types recognizable and consistent across views. App containers remain labeled boxes, external systems use grey boxes, and the system boundary is separate from element shapes.

## Relationship direction and completeness

Container arrows point from the calling/consuming container to the depended-on provider. Every relationship is labeled with the caller action and known protocol or interface. All arrows are one-way and dashed by project convention. The container main view shows the core path; views 12–15 complete the secondary relationships:

- **Main view 02:** human-to-dashboard, dashboard-to-projection store, collector-to-store and host, inference-to-store, policy-to-store/inference/actuator, and actuator-to-host.
- **View 12:** person-to-dashboard access and dashboard reads from telemetry and audit stores.
- **View 13:** decision/action audit writes and read-only audit access.
- **View 14:** service health, policy inhibit, verified outcomes, and guarded recovery.
- **View 15:** policy context, read-model projection writes, and watchdog freshness checks.

The union covers every declared edge in the renderer’s container relationship model. It avoids an unreadable all-edges-on-one-canvas while keeping every connection visible on a diagram.

## Component interfaces

Each component diagram encloses one C4 container and places clients, stores, or operating-system interfaces outside its boundary. Components use UML1 component glyphs with paired, close-set tabs at their upper-left corners. A required socket connects to a provided lollipop through a labeled interface and a dashed directed relationship. Request and response contracts are named separately where the transport carries both directions. The dashed arrow represents project dependency direction; the UML assembly connector itself is not inherently directional.

The actuator view shows the only privileged writer. The socket endpoint forwards requests through peer authentication, shape/action checks, target revalidation, bounded cgroup operations, and audit. Rejected requests terminate at the rejection/audit paths. The collector view shows read-only host access, sample checks, normalization, and storage. The decision/policy and watchdog views remain separate from the actuator’s authority.

## Technology and safety accuracy

- Linux PSI and procfs are observation interfaces. Cgroup v2 is the proposed resource-control boundary.
- `cpu.weight`, `memory.high`, and `io.weight` / `io.max` are candidate controls whose availability and semantics must be checked on the actual host, cgroup hierarchy, and device.
- AI output is advisory. The independent policy and actuator validations determine whether a write can proceed.
- The diagrams show proposed boundaries; they do not claim that services, authenticated IPC, controls, rollback, or outcome checks are implemented or tested.
- Host-wide sysctl, CPU-governor, and I/O-scheduler mutation is excluded from this design baseline.

## Source references

- [C4 diagram hierarchy and scope](https://c4model.com/diagrams)
- [C4 notation](https://c4model.com/diagrams/notation)
- [C4 container diagram](https://c4model.com/diagrams/container)
- [C4 component diagram](https://c4model.com/diagrams/component)
- [C4 diagram checklist](https://c4model.com/diagrams/checklist)
- [Linux Pressure Stall Information](https://docs.kernel.org/accounting/psi.html)
- [Linux cgroup v2](https://docs.kernel.org/admin-guide/cgroup-v2.html)

## Component relationship labels and connector visibility — 19 November 2026

The regenerated component diagrams label every dashed connector with an action phrase and its interface contract name. This makes the relationship semantics visible instead of showing only the required/provided interface names. Label text has no opaque white backing and is positioned adjacent to the route, leaving the connector itself visible. Arrows indicate dependency direction from consumer to provider, following the project convention; the UML assembly connector has no intrinsic direction. Where a single transport exchanges requests and outcomes, the external relation uses one endpoint contract and its component description documents both directions.