# Linux telemetry recording status

**A real read-only sample is included from the available Ubuntu 26.04.1 VMware guest.** It was captured on 13 November 2026 over 60 seconds with the project collector: 61 host records and 19,276 process records. The run directory contains the JSONL, host-only CSV, guest environment output, metadata command script, summary, manifest, and SHA-256 values. The guest reported kernel 7.0.0-43-generic, systemd 259, two logical CPUs, cgroup v2, and readable CPU, memory, and I/O PSI interfaces.

This is a passive recorder/format sample from a VMware guest; it is not an AIOS runtime trace, controlled workload, benchmark, or evaluation result. The specified project host remains Ubuntu 24.04, so target-version compatibility and host-specific behavior are still unverified. No eBPF probe, cgroup write, priority change, CPU placement, or other resource action was performed.

The separate Internet captures in `10_Evidence_Closure/Internet_Evidence/` are published examples only, not readings from this VM. For target-host evidence, repeat the finite read-only capture on an authorized Ubuntu 24.04 host and retain version, topology, workload, permission, quality, and checksum metadata. Process telemetry is sensitive; the collector omits names, command lines, environments, usernames, and paths by default, but PID/start-time identifiers and resource readings should remain local to the approved project folder.

For explanations of the sample fields, command parameters, acronyms, measured values, and limits, see Ubuntu_VM_Telemetry_Data_Guide.docx and Ubuntu_VM_Telemetry_Data_Guide.md.
