# AIOS C4 architecture

This is the curated mirror of the active C4 diagrams in the project workspace. It contains 14 views: system context, container architecture, six scoped component views, dynamic behavior, deployment, and four focused container-relationship views. The service-oriented design is not arranged into horizontal layers.

## Diagram index

Editable PlantUML sources and rendered SVG, PNG, and JPG files are colocated in this folder.

| ID | View | Source | PNG |
|---|---|---|---|
| 01 | System Context | [PlantUML](01_c4_system_context.puml) | [PNG](01_c4_system_context.png) |
| 02 | Container Architecture | [PlantUML](02_c4_container_architecture.puml) | [PNG](02_c4_container_architecture.png) |
| 03 | Actuator Components | [PlantUML](03_c4_actuator_components.puml) | [PNG](03_c4_actuator_components.png) |
| 04 | Dynamic Telemetry-to-Action | [PlantUML](04_c4_dynamic_telemetry_to_action.puml) | [PNG](04_c4_dynamic_telemetry_to_action.png) |
| 05 | Ubuntu Deployment | [PlantUML](05_c4_ubuntu_deployment.puml) | [PNG](05_c4_ubuntu_deployment.png) |
| 06 | Telemetry Collector Components | [PlantUML](06_c4_telemetry_collector_components.puml) | [PNG](06_c4_telemetry_collector_components.png) |
| 07 | AI Inference Components | [PlantUML](07_c4_inference_service_components.puml) | [PNG](07_c4_inference_service_components.png) |
| 08 | Decision and Policy Components | [PlantUML](08_c4_decision_policy_components.puml) | [PNG](08_c4_decision_policy_components.png) |
| 09 | Safety Watchdog Components | [PlantUML](09_c4_safety_watchdog_components.puml) | [PNG](09_c4_safety_watchdog_components.png) |
| 10 | Dashboard API Components | [PlantUML](10_c4_dashboard_api_components.puml) | [PNG](10_c4_dashboard_api_components.png) |
| 12 | Dashboard and Telemetry Relationships | [PlantUML](12_c4_container_data_dependencies.puml) | [PNG](12_c4_container_data_dependencies.png) |
| 13 | Audit Relationships | [PlantUML](13_c4_container_audit_dependencies.puml) | [PNG](13_c4_container_audit_dependencies.png) |
| 14 | Policy and Watchdog Relationships | [PlantUML](14_c4_container_policy_watchdog_dependencies.puml) | [PNG](14_c4_container_policy_watchdog_dependencies.png) |
| 15 | Policy and Telemetry Relationships | [PlantUML](15_c4_container_policy_data_dependencies.puml) | [PNG](15_c4_container_policy_data_dependencies.png) |

## Relationship and component conventions

The main container diagram shows the primary monitor-to-action route. Views 12–15 put the remaining container connections directly on diagrams. The six component views each decompose one service and together show 31 component glyphs. Every component has paired compact tabs near its upper-left, named required/provided interfaces, and labeled connectors.

Relationships use dashed, directed arrows as an explicit project convention. Arrows point from the consumer to its provider. C4 itself does not require dashed lines. Required and provided interface names do not replace the labeled relationship between them.

## Safety boundary and evidence status

The collector and dashboard are read-only. The actuator is the only proposed host-resource writer. `OBSERVE_ONLY` is the default. Candidate cgroup v2 controls are CPU `cpu.weight`, RAM `memory.high`, and supported I/O `io.weight` or `io.max`, each behind a separate capability and safety gate. These diagrams describe a proposed design; they do not prove integrated implementation, Ubuntu 24.04 validation, safe live actuation, or workload benefit.

See the [C4 notation and relationship review](AIOS_C4_Notation_and_Relationship_Review.md), [supporting diagram guide](../uml-and-supporting-diagrams/AIOS_Diagram_Guide.pdf), and [final engineering review](../../research-and-evidence/AIOS_Final_Software_Engineering_Review.md). The authoritative working copies are under `11_C4_Architecture` in the A: project workspace.
