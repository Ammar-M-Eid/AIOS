# AIOS project documentation

This folder is the curated software-engineering documentation set for the AIOS graduation project. It was reviewed against the project workspace on **19 November 2026**. It contains the current deliverables and diagram sources/exports; superseded presentations, temporary QA renders, course source files, and the large working-directory ZIP archives are intentionally omitted.

## Read first

1. [Requirements and Behavior Specification](requirements/AIOS_Requirements_and_Behavior_Specification.pdf) — named requirements, linked use cases and user stories, acceptance criteria, and behavior flows. The formal [Software Requirements Specification](requirements/AIOS_Software_Requirements_Specification.pdf) and [detailed requirement traceability](requirements/Ammar_Requirements_Traceability.csv) are included as companion artifacts.
2. [C4 architecture set](architecture/c4/README.md) — current context, container, component, dynamic, and deployment views with PlantUML sources and SVG/PNG exports.
3. [Diagram guide](architecture/uml-and-supporting-diagrams/AIOS_Diagram_Guide.pdf) and [notation audit](architecture/uml-and-supporting-diagrams/AIOS_Diagram_Notation_Audit.md) — current index and review for the 24 numbered supporting views; C4 is maintained separately.
4. [Software Project Management Plan](planning/AIOS_Software_Project_Management_Plan.pdf) and [estimates, risks, and Scrum plan](planning/AIOS_Software_Engineering_Estimates_Risks_Scrum_Plan.md).
5. [Proposed data model](data-model/README.md) — SQLite schema files, design notes, and the two EERDs.
6. [Final university-template presentation](presentation/AIOS_Software_Engineering_Presentation_Final_2026-11-19_University_Rubric_v5_Updated_C4.pptx), with the [slide content guide](presentation/AIOS_Software_Engineering_Slide_Content.md) and [presentation QA record](presentation/AIOS_Software_Engineering_Presentation_QA.md).
7. [Technology, tools, components, and glossary](reference/AIOS_Technology_Tools_Components_and_Glossary.docx).
8. [Consolidated offline handbook](AIOS_Software_Engineering_Handbook.html).
9. [Final engineering and package review](research-and-evidence/AIOS_Final_Software_Engineering_Review.md) and [release quality record](research-and-evidence/Package_Quality_Review.md), with the [source-workspace file inventory](research-and-evidence/AIOS_File_by_File_Review.csv).

## Contents

- `architecture/c4/` — 14 C4 views (context, container, component, dynamic, and deployment), each with editable PlantUML and SVG/PNG exports, plus architecture and relationship review notes.
- `architecture/uml-and-supporting-diagrams/` — the 24 numbered supporting diagrams in editable PlantUML/Mermaid form with SVG/PNG exports, the current guide, notation audit, object-design notes, and contact sheet.
- `requirements/` — SRS and behavior specification in PDF/Word/Markdown, requirement/use-case/story catalogs, traceability, resource-control scope, and market-scope references.
- `planning/` — SPMP in PDF/Word, whole-product and remaining-work estimates, risk register, Scrum plan, and schedule/Gantt files.
- `data-model/` — proposed SQL schemas for telemetry/decisions and the separate audit store, EERD sources and renders, and design notes.
- `research-and-evidence/` — source registers, safety acceptance cases, current rubric/course crosswalk, package review, final software-engineering review, and file-level inventory. The research paper is explicitly a **draft**.
- `telemetry-and-operations/` — telemetry interface, capture status and guide, and resource-budget artifacts.
- `reference/` — technology, tool, component, and glossary document.
- `presentation/` — the latest canonical presentation, slide text, quality record, and contact sheet. Earlier deck revisions and intermediate slide renders are omitted.

## Status and evidence limits

AIOS is documented as a **proposed** Linux user-space optimizer for CPU, RAM, and I/O pressure. The diagrams, interfaces, schemas, safety gates, and actuation paths are design artifacts; they do not prove a deployed integrated product, Ubuntu 24.04 validation, model accuracy, safe live actuation, or workload improvements. The collector capture in the source workspace demonstrates passive collection/provenance only. The project defaults to `OBSERVE_ONLY`; any target-host write requires separate capability, policy, authorization, and safety validation.

The estimate and capacity figures are planning assumptions, not measured team velocity or approved commitments. Review their assumptions and date scenarios in the estimate document before using them as a baseline. The research paper is a draft and should not be cited as a published result.

## Provenance

Authoritative source workspace: `A:\CS Study\7th Sem\GP\mid\AIOS_Ammar_Software_Engineering`. The repository package preserves final deliverables in a navigable documentation tree; the original workspace remains the richer source for scripts, raw captures, course materials, and build/QA work files.
