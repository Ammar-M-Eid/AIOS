# AIOS supporting software-engineering diagrams

This folder contains 24 numbered supporting views. C4 architecture is maintained separately in [`../c4/`](../c4/README.md) and is not recreated here.

## Start here

- [Diagram Guide (PDF)](AIOS_Diagram_Guide.pdf) and [editable DOCX](AIOS_Diagram_Guide.docx)
- [Notation and consistency audit](AIOS_Diagram_Notation_Audit.md)
- [Contact sheet](AIOS_Diagram_Contact_Sheet.jpg)
- [Object design, SOLID, and patterns](OOD_SOLID_and_Design_Patterns.md)
- [All diagram sources and renders](.)

Each numbered diagram has an editable PlantUML or Mermaid source and canonical SVG/PNG exports. The guide explains the notation and cross-view boundaries; the audit records the rationale and evidence limits. Use the exported image when placing a diagram in slides or reports, and keep its source and export together. In this repository the files are colocated in this folder; the authoritative working copies are under `01_Diagrams` in the A: project workspace.

The set covers operational context, software architecture, UML component/use-case/activity/class/deployment/state views, behavior sequences, a DFD-style trust-boundary view, resource/action flows, and the UC-14 read-only interaction detail. Diagrams document a proposed design and do not establish implementation or target-host validation.
