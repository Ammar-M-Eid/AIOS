# AIOS Software Engineering Package — Final Quality Review

**Review date:** 19 November 2026<br>
**Workspace:** `A:\CS Study\7th Sem\GP\mid\AIOS_Ammar_Software_Engineering`<br>
**Reference/rubric directory:** `00_Source_References`

## Release scope and canonical files

The active release contains the SRS and behavior/traceability set, active C4 and supporting diagrams, research and evidence records, estimates/risks/Scrum plan, proposed data model, technology glossary, final engineering review, offline handbook, and university-template presentation. Superseded drafts, QA renders, and review history remain in `qa_render` locally and are excluded from the release ZIP.

The SRS is version 2.1 with 52 hierarchical requirement leaves; there is no legacy-ID crosswalk in the current baseline. The behavior set includes 18 use cases, 19 user stories, and requirement-linked sequences. The artifacts describe proposed behavior, not an integrated runtime.

## Architecture, diagrams, and data model

- The active C4 baseline is service-oriented and has 14 views. Six scoped component diagrams contain 31 displayed component glyphs. The component-tab verifier passed; all six PlantUML sources use UML1 glyphs, paired compact upper-left tabs, and synchronized SVG/PNG/JPG exports.
- The C4 release ZIP contains 120 current source and render files. Container relationships appear on the main and focused diagrams; component connectors show named interfaces, caller actions, and project dependency direction.
- There are 24 numbered supporting views with editable PlantUML/Mermaid sources and canonical renders. The refreshed 3-page guide and view-by-view notation audit identify UML, C4, context/flow, DFD-style, data-model, and schedule views separately.
- CPU (`cpu.weight`), RAM (`memory.high`), and supported I/O (`io.weight`/`io.max`) have independent proposed capability and safety gates. `OBSERVE_ONLY` is default; the dashboard is read-only. `memory.max`, process termination, and arbitrary shell commands are excluded.
- SQL/EERD files are proposed SQLite models. Telemetry/decision and audit records use separate stores. Hash chaining does not itself make the audit store tamper proof.

## Estimate and evidence limits

The whole-product estimate is 133–195 person-days; provisional remaining work from Sprint 5 is 95–160 person-days. Five-person capacity is assumed at 150–210 person-days through the internal 9 May 2027 target. The exact GP2 date and member availability are unconfirmed; 31 May is sensitivity only. No PERT calculation or quantified contingency reserve is claimed.

Technical references support Linux mechanism descriptions and constraints. No local interview/survey results, market-size estimate, Ubuntu 24.04 target benchmark, model-quality result, safe live actuation, or workload-benefit result is claimed. The retained Ubuntu 26.04.1 passive VM sample supports collection/provenance only.

## Presentation and release validation

The canonical presentation is `12_Engineering_Review/Final/AIOS_Software_Engineering_Presentation_Final_2026-11-19_University_Rubric_v5_Updated_C4.pptx`. It contains 37 slides: 25 visible talk slides and 12 hidden technical backups. Its SHA-256 is `0bebdd6e09819877582b35aa722d9c887d5c05cc7eb5a16c94c331a2354ef8f1` and size is 7,375,614 bytes. Artifact Tool rendered all slides; package integrity and slide geometry checks returned 0 findings and 0 warnings. Seventeen refreshed diagram pictures are embedded: 11 C4, four sequence, and two UML images. Native PowerPoint/font rendering remains unverified.

The current project ZIP contains 423 project files plus the manifest, for 424 archive entries. `PACKAGE_MANIFEST.csv` records 423 file paths, sizes, and SHA-256 digests. The file-level inventory records metadata for 422 retained files; its entries are an index, while semantic and visual checks are described above and in each document’s QA record. QA history and superseded files are excluded from the release ZIP.

The release checks establish archive/file integrity and documented visual review; they do not establish implementation completeness, target support, safety, or performance improvement.
