# AIOS Software Engineering Presentation — final QA record

**Revision:** Canonical diagram-image correction, 17 November 2026  
**Canonical presentation:** `12_Engineering_Review/Final/AIOS_Software_Engineering_Presentation_Final_2026-11-17_University_Rubric_v4_Source_Diagrams.pptx`  
**SHA-256:** `287264ba9c49160057e18831788f23405073d8526a4d6a2a5d179f9cef712f39`  
**File size:** 6648658 bytes

Version 4 replaces the full sequence-diagram picture with the exact canonical PNG from `01_Diagrams` and preserves its aspect ratio. Version 3 was left untouched because it was open in PowerPoint during this correction; version 4 is the canonical deliverable.

## Deck and delivery

The deck has 37 slides: 25 visible talk slides and 12 hidden technical backup slides. The planned speaker-note timing is 16:05 for the main presentation plus 3:55 for questions. The cover names Ammar, Mazen, Hana, Hany, and Noreen from the team task board and lists Supervisor Prof. Dr. Ahmed Younes.

The visible story covers the problem and research question, configured Linux baselines and prior research, candidate users and evidence limits, C4/UML/DFD design, guarded CPU/RAM/I/O actions, requirements and safety, dataset and evaluation, software design patterns, whole-product estimate and remaining capacity, risk analysis, and a 16-sprint Scrum plan. The supplied university template and presentation rubric informed the structure and visual hierarchy. This is a design and project plan; it does not claim an implemented controller or measured AIOS benefit.

## Checks completed

- The PPTX package check passed with 0 findings; slide geometry passed with 0 findings and 0 warnings for 37 slides at 26.6667 × 15 inches. Artifact Tool imported and rendered all 37 slides.
- The v4 contact sheet was regenerated from those renders and reviewed. Slides 10 and 26–28 were also inspected individually. The full sequence on slide 10 is an overview; backup slides 26–28 show focused picture views of its policy, authenticated-write, and recovery/read-only sections.
- All 11 C4 render PNGs and all four sequence PNGs (full sequence plus three detail pictures) are embedded byte-for-byte: **15/15 source-image matches**. The diagram on slide 10 is one picture object; its frame preserves the canonical image’s 7030 × 5150 aspect ratio. The sequence and architecture diagrams remain pictures in the slides.
- C4 component notation check passed for 60 compact upper-left double-tab glyphs across seven scoped component views. The seven C4 component sources and rendered formats match; C4 relationships are labeled, directed, and dashed by project convention.
- The 15 numbered views are separated by notation: four formal UML views use PlantUML (component, use case, activity, deployment); Mermaid sequence, class, and state views use UML-style syntax; C4, context, flowchart, DFD-style, and schedule views are identified separately. The PlantUML sources pass syntax checking. C4 is not UML, and dashed C4 arrows are a project convention.
- The main talk contains the 25-slide narrative; the 12 supporting sequence, UML, and C4 views are hidden during normal slide show and available as backup slides.

## Verification limits and scope

Native PowerPoint rendering and native font rendering were not verified. The supplied visual template, spacing, sizing, and alignment were reviewed in Artifact Tool renders. These structural, image-source, and visual checks do not establish model accuracy, production safety, Ubuntu 24.04 target support, or workload benefit.

The estimate includes the full proposed monitor → process → predict → decide → bounded act product across CPU, RAM, and supported I/O. The whole-product baseline is 133–195 person-days; provisional remaining work from Sprint 5 is 95–160 person-days. For five contributors through the internal 9 May target, assumed capacity is 150–210 person-days (nominal 180); the low case is 10 days below the high remaining estimate and the nominal case has 20 days of headroom. The exact GP2 deadline and each person’s availability remain unconfirmed. The 31 May case is sensitivity only. No PERT calculation or quantified contingency reserve is claimed.

Target scope is a bounded Ubuntu 24.04 research demonstrator. `OBSERVE_ONLY` is the default; each resource actuator needs its own authorization, capability, bounds, read-back, audit, and recovery gate. No `memory.max`, process killing, multi-host operation, or broad production hardening is included. The retained Ubuntu 26.04.1 passive capture supports collection/provenance only. It does not establish target support, prediction quality, safe live actuation, or workload benefit.
