# C4 architecture set

These are the current C4 views for the AIOS proposed Linux resource optimizer. Every diagram includes an editable PlantUML source (`.puml`) and scalable SVG and PNG exports. The complete relationship review is in [AIOS_C4_Notation_and_Relationship_Review.md](AIOS_C4_Notation_and_Relationship_Review.md).

| ID | View | File stem |
|---|---|---|
| 01 | System context | `01_c4_system_context` |
| 02 | Container architecture | `02_c4_container_architecture` |
| 03 | Resource Manager / Actuator components | `03_c4_actuator_components` |
| 04 | Dynamic telemetry-to-action flow | `04_c4_dynamic_telemetry_to_action` |
| 05 | Proposed Ubuntu deployment | `05_c4_ubuntu_deployment` |
| 06 | Telemetry Collector components | `06_c4_telemetry_collector_components` |
| 07 | AI Inference Service components | `07_c4_inference_service_components` |
| 08 | Decision and Policy Service components | `08_c4_decision_policy_components` |
| 09 | Safety Watchdog components | `09_c4_safety_watchdog_components` |
| 10 | Read-only Dashboard API components | `10_c4_dashboard_api_components` |
| 12 | Container data dependencies | `12_c4_container_data_dependencies` |
| 13 | Container audit dependencies | `13_c4_container_audit_dependencies` |
| 14 | Policy, watchdog, and recovery dependencies | `14_c4_container_policy_watchdog_dependencies` |
| 15 | Policy data dependencies | `15_c4_container_policy_data_dependencies` |

Relationships in this project’s C4 views are drawn as dashed, directed arrows as a visual convention. Dashed lines are not a universal C4 requirement. Component diagrams use the project’s adjacent double-tab component glyph convention and show named interfaces. The deployment and dynamic views are labeled for their distinct purpose rather than treated as additional static C4 levels.

The architecture is a design proposal. Linux interface availability, target Ubuntu behavior, I/O control support, and safe actuation/rollback require implementation and target-host validation. `OBSERVE_ONLY` is the default; people use read-only dashboard views.

For related UML, sequence, activity, use-case, state, class, data-flow, and decision diagrams, see [the supporting diagram set](../uml-and-supporting-diagrams/AIOS_Diagram_Notation_Audit.md).
