# AIOS Software Engineering Package — Final Quality Review

**Review date:** 18 November 2026  
**Workspace:** `A:\CS Study\7th Sem\GP\mid\AIOS_Ammar_Software_Engineering`  
**Reference/rubric directory:** `00_Source_References`

## Release scope

The curated release contains the current requirements, architecture, research and evidence artifacts; the canonical project plan and technology glossary; the final engineering review; and the final university-template presentation. The proposed relational data model is documented in `14_Data_Model`, with independent SQLite schemas and Crow-foot EERDs for the telemetry/decision store and separate audit store. It remains a design draft pending team/security approval, host validation, retention policy, and implementation. Use `12_Engineering_Review/Final/AIOS_Software_Engineering_Presentation_Final_2026-11-17_University_Rubric_v4_Source_Diagrams.pptx` as the canonical deck. It contains 37 slides: 25 visible talk slides and 12 hidden technical backup slides. Superseded working presentations are excluded from the release archive. The root manifest and ZIP are refreshed after these final content updates.

## Rubric and delivery consistency

The presentation covers the problem and research question, configured Linux baselines and previous work, research method, software architecture and notations, requirements and safety, available evidence and evaluation plan, full-product estimate, risks, and Scrum delivery plan. The supplied presentation template and evaluation rubric are retained in `00_Source_References`. The cover uses the five team names from Notion and lists supervisor Prof. Dr. Ahmed Younes.

The whole-product base estimate is **133–195 person-days** for the proposed CPU/RAM/I/O monitor-to-action product. The separately stated provisional remaining estimate from Sprint 5 is **95–160 person-days**. For Sprints 5–16 through the internal 9 May target, five contributors at 2.5–3.5 focused days each per Sprint provide **150–210 person-days**; nominal capacity is 180, leaving 20 days above the high remaining estimate. The low-capacity case is short by 10 days. The GP2 date and member availability remain unconfirmed; 31 May is sensitivity only. No PERT calculation or quantified contingency reserve is claimed.

## Proposed data-model package

- The telemetry/decision SQLite DDL defines 9 tables for run provenance, CPU/RAM/I/O host and process samples, generic prediction output, decisions, read-only recommendation projections, action attempts, and per-attempt safety checks.
- The separate audit-store DDL defines 3 tables, one ordered hash chain per database, correlation references without cross-store foreign keys, and ordinary-SQL update/delete guard triggers. This is not tamper-proof storage; protected chain-head anchoring and hashing implementation remain open.
- Both SQL files execute successfully against in-memory SQLite; `PRAGMA foreign_key_check` reports no issues. Two editable Mermaid EERDs were rendered to SVG, PNG, and JPG and visually inspected. This verifies SQL syntax and artifact rendering only; field agreement, API/model contracts, database limits, and Ubuntu 24.04 operation remain unverified.

## Verification results

- The six files in `00_Source_References` remain the supplied source set; no rubric, template, or course-reference file was changed.
- The C4 tab verifier passes for **31 component glyphs across six scoped component views**. All six use the requested compact upper-left double tabs and UML1 component glyphs; each source/render SVG, PNG, and JPG set is byte-identical.
- All **14 active C4 views** were reviewed. Relationships are labeled, directed, and dashed as the project convention. SQLite telemetry is shown as a database cylinder; append-only audit files are shown as a directory; applications, systems, and people use their matching labeled shapes. C4 is a separate architecture notation, not UML.
- Version 4 PPTX package integrity and slide geometry both pass with 0 findings and 0 warnings; Artifact Tool imported and rendered all 37 slides. SHA-256: `287264ba9c49160057e18831788f23405073d8526a4d6a2a5d179f9cef712f39`; size: 6648658 bytes.
- Artifact Tool rendered all 37 version 4 slides. The updated contact sheet represents the current deck; slides 10 and 26–28 were inspected individually, including the full sequence picture and its three detail views.
- All **14 active C4 render PNGs and four sequence PNGs** match their source bytes (18/18). Slide 10’s sequence is one picture object, with the canonical source aspect ratio preserved; diagram contents are not recreated as native slide shapes. The embedded slide deck has not yet been refreshed with the 18 November storage-symbol correction.
- The timed speaker notes specify 16:05 for the main talk plus 3:55 for Q&A. The 16-sprint plan and estimates remain planning forecasts, not verified velocity or team commitments.
- The SPMP DOCX/PDF has a 12-page A4 rendering; its retained render evidence is in `qa_render/spmp_final_2026-11-17`.
- The 15 numbered views were checked against their intended notations. Four formal UML views use PlantUML (component, use case, activity, deployment); the Mermaid sequence, class, and state views use UML-style syntax; C4, context, flowchart, DFD-style, and schedule views are labeled separately. The PlantUML sources pass syntax checking, and Mermaid diagrams retain their rendered labels. Diagram 05 was simplified for legibility; Diagram 06 carries the separate CPU, RAM, and supported I/O gates. The guide’s 15 embedded pictures and the consolidated handbook’s 11 C4 plus 15 numbered SVGs were byte-checked against canonical renders. The 17-page guide and four-page QA report were exported and visually reviewed. The dated 16 November rasterization folder remains labeled as historical evidence.
- The handbook source register contains 101 retained local artifacts; its hashes were refreshed against those current source files.
- The refreshed release contains 372 manifest-listed files plus `PACKAGE_MANIFEST.csv` in the ZIP (373 archive entries). The project ZIP was refreshed to replace the C4 section with the 14-view service-oriented release; retired and historical C4 QA renders were removed from the release archive. The manifest records the packaged entries' byte sizes and SHA-256 values; the archive is checked against those recorded entries and ZIP CRC.

## Verification limits and evidence still required

Native PowerPoint and font rendering were not verified. The imported-deck layout validator recognized Arial and Aeonik TRIAL and reported no geometry findings; this does not establish native PowerPoint font fidelity. The university template’s visual branding, layout, sizing, and alignment were reviewed in Artifact Tool renders.

The checks establish artifact structure, recorded content, rendered visibility, diagram-picture inclusion, and release-package integrity. They do **not** establish an integrated product, Ubuntu 24.04 target support, local user demand, predictor quality, safe live actuation, rollback success, or workload benefit. The retained collection evidence is a passive Ubuntu 26.04.1 VM capture; it is not a target-version benchmark or AIOS action trace. `OBSERVE_ONLY` remains default. Proposed CPU, RAM, and supported I/O controls require separate host validation and safety gates. `memory.max`, process killing, multi-host operation, and broad production hardening are outside this proposed demonstrator scope.

Retained deliverables and the canonical presentation link are listed in `README.md`. The detailed rubric/readiness assessment is `12_Engineering_Review/Final/AIOS_Final_Software_Engineering_Review.md`; estimates, schedule scenarios, risks, dependencies, and Scrum rules are in `12_Engineering_Review/Final/AIOS_Software_Engineering_Estimates_Risks_Scrum_Plan.md`.



