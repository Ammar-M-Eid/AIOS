# Research and evidence index

This folder records what the project has researched, measured, and reviewed. It distinguishes published sources and passive collection evidence from proposed architecture and unvalidated hypotheses.

## Current review and evidence records

- [Final software-engineering review](AIOS_Final_Software_Engineering_Review.md)
- [Package quality review](Package_Quality_Review.md)
- [Source log](Research_Source_Log.csv)
- [AIU course crosswalk](AIU_Course_Crosswalk.csv)
- [GP1 rubric readiness](AIU_GP1_Rubric_Readiness.csv)
- [Safety acceptance cases](AIOS_Safety_Acceptance_Cases.csv)
- [File-level inventory](AIOS_File_by_File_Review.csv)
- [Research paper draft](AIOS_Research_Paper_Draft.docx)

## Evidence boundaries

The retained Ubuntu 26.04.1 VMware capture is passive collector evidence. It does not validate Ubuntu 24.04 compatibility, an integrated inference/policy/actuation path, model quality, safe live actions, local market demand, or workload benefit. No participant responses or market-size estimates are supplied. The project design remains proposed; candidate CPU, RAM, and supported I/O controls require separate target-host and safety evidence.

## Published-source context capture

The `Internet_Evidence` subfolder contains rendered examples from the public USENIX SREcon24 EMEA slide deck, *Granular CPU Capacity Management at Scale with eBPF* by George Brighton and Cameron Howes (31 October 2024). These captures are source context only, not AIOS data or project measurements. See `Internet_Source_Evidence_Register.csv` for slide labels, claim limits, capture date, and hashes. The published slides refer to the official [Linux PSI documentation](https://docs.kernel.org/accounting/psi.html).
