# AIOS Software Engineering Presentation — final QA record

**Revision:** v5, 19 November 2026<br>
**Canonical presentation:** [`AIOS_Software_Engineering_Presentation_Final_2026-11-19_University_Rubric_v5_Updated_C4.pptx`](AIOS_Software_Engineering_Presentation_Final_2026-11-19_University_Rubric_v5_Updated_C4.pptx)<br>
**SHA-256:** `0bebdd6e09819877582b35aa722d9c887d5c05cc7eb5a16c94c331a2354ef8f1`<br>
**File size:** 7,375,614 bytes

Version 5 refreshes the deck’s UML use-case, full authenticated-action and three sequence-detail pictures, selected C4 views, dashboard class view, source captions, SRS reference, and final backup slide. The sequence and architecture diagrams remain pictures from the project exports; the slides do not redraw them as shapes. The final backup slide now shows C4 container data dependencies instead of the retired whole-system component inventory.

## Deck and delivery

The deck has 37 slides: 25 visible talk slides and 12 hidden technical backup slides. Planned speaker-note timing is 16:05 for the main presentation plus 3:55 for questions. The cover names Ammar, Mazen, Hana, Hany, and Noreen from the team task board and lists supervisor Prof. Dr. Ahmed Younes.

The visible story covers the research question, Linux baselines and prior work, candidate users and evidence limits, C4/UML/DFD views, guarded CPU/RAM/I/O actions, requirements and safety, available evidence and evaluation plan, design patterns, the whole-product estimate, risks, and Scrum delivery. It follows the supplied university template and rubric. It presents proposed design and plans, not an implemented controller or measured AIOS benefit.

## Checks completed

- Artifact Tool imported, updated, exported, and rendered all 37 slides. Package integrity reports 0 findings and 0 warnings; slide geometry reports 0 findings and 0 warnings at 26.6667 × 15 inches.
- The current 37-slide contact sheet was reviewed. Slides 5–10 and selected backup slides 26–30, 34, and 37 were inspected individually. Slide 10 is the dense full-sequence overview; hidden slides 26–28 are focused picture excerpts for policy admission, authenticated write, and recovery/read-only access.
- The deck contains 17 refreshed source-diagram pictures: 11 C4 PNGs, four sequence PNGs, and two UML pictures. The full authenticated-action sequence remains one picture object. The C4 diagrams are proposed views and preserve the canonical service-oriented organization.
- The six component views in the C4 set use compact paired upper-left tabs, named provided/required interfaces, and labeled dashed project relationships. C4 arrows are not being described as UML connectors; the dashed style and consumer-to-provider direction are project conventions.
- The 25-slide main story and 12 hidden sequence/UML/C4 backup views remain separated for normal presenting.

## Verification limits and scope

Native PowerPoint rendering and native font rendering were not verified. Visual review used Artifact Tool renders. The package and layout checks establish file structure and slide geometry, not font fidelity, model accuracy, safe live actuation, Ubuntu 24.04 support, or workload benefit. The three detail sequence images intentionally show focused excerpts; the complete source sequence is available on slide 10 and in the editable diagram package.

The estimate covers the full proposed monitor → process → predict → decide → bounded-act product across CPU, RAM, and supported I/O. The whole-product baseline is 133–195 person-days; provisional remaining work from Sprint 5 is 95–160 person-days. For five contributors through the internal 9 May target, assumed capacity is 150–210 person-days (nominal 180). The low-capacity case is 10 days below the high remaining estimate and the nominal case has 20 days of headroom. The exact GP2 deadline and member availability remain unconfirmed; 31 May is sensitivity only. No PERT calculation or quantified contingency reserve is claimed.

The target is a bounded Ubuntu 24.04 research demonstrator. `OBSERVE_ONLY` is the default. Each resource actuator needs its own authorization, capability, bounds, read-back, audit, and recovery gate. `memory.max`, process termination, multi-host operation, and broad production hardening are out of scope. The retained Ubuntu 26.04.1 passive capture supports collection/provenance only, not target support, prediction quality, safe live actuation, or benefit.
