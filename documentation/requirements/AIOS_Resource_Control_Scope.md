# AIOS CPU, RAM, and I/O Control Scope

**Status:** proposed product scope for the Ubuntu 24.04 research demonstrator. `OBSERVE_ONLY` remains the default. This document defines the intended resource boundary; it is not evidence that live controls are implemented, enabled, or validated.

## Product statement

AIOS will monitor CPU, RAM, and I/O pressure, process and workload context, and generate resource-specific recommendations. After host-owner and security review, the design may apply a bounded control to an explicitly approved cgroup. Each resource control has an independent capability, ownership, policy, authorization, bounds, read-back, audit, and guarded-recovery check. A missing or unsupported control returns a recommendation without writing. Model output never selects a kernel file or writes to the host directly.

## Proposed controls

| Resource | Proposed cgroup v2 control | Intended effect | Availability and safety boundary |
|---|---|---|---|
| CPU | `cpu.weight` | Adjusts a cgroup’s relative CPU share among active siblings under contention; it does not reserve CPU time. | Require the CPU controller, approved cgroup ownership, reviewed bounds, prior-value capture, read-back, audit, and guarded restore. |
| RAM (memory pressure) | `memory.high` | Establishes a high boundary that can cause reclaim/throttling when a cgroup exceeds it; it is not a hard `memory.max` cap. | Require the memory controller and a reviewed per-workload boundary. Never write `memory.max` or terminate processes. |
| Block I/O | `io.weight` and/or `io.max` | `io.weight` expresses proportional I/O share where supported; `io.max` caps BPS and/or IOPS for a specific device. | Detect supported controller/device files and semantics at runtime. Review per-device limits and restore values. Unsupported paths remain recommendation-only. |

These controls have different effects and must not share one generic numeric interpretation. The policy layer identifies the resource/action class; a fixed adapter maps it to an allow-listed control. One resource passing its gate does not authorize another resource or a multi-resource action.

## Common action path

1. Begin in `OBSERVE_ONLY`; keep measurements, predictions, recommendations, decisions, and applied outcomes distinct.
2. Confirm fresh evidence, process-instance identity, cgroup ownership, host-manager ownership, and target eligibility.
3. Detect that the specific controller and control are available for that target.
4. Check that the active reviewed profile permits this resource, target, value, rate, and cooldown.
5. Authenticate the local caller, validate again at the actuator, capture the prior value, apply only the bounded request, and read back the effective state.
6. Audit the decision and outcome. Restore only a captured value for the same still-verified AIOS-owned target; otherwise fail closed and report degraded recovery.

The dashboard remains query-only. The system has no arbitrary shell executor, process-kill action, `memory.max` write, or user command/approval path.

## Scope and evidence status

The architecture, SRS, diagrams, plan, estimates, and presentation describe all three resources as the product target. Implementation is phased: CPU is the first proposed isolated action, followed by separately gated RAM and supported I/O actions, then multi-resource integration. The retained Ubuntu capture demonstrates read-only CPU, memory, and I/O telemetry availability only. It contains no inference, policy, or cgroup write, so no live control or benefit is claimed.

## Technical sources

- Linux Kernel Documentation, [Control Group v2](https://docs.kernel.org/admin-guide/cgroup-v2.html): CPU weights, memory controls, and I/O weight/rate interfaces; host/controller/device support must be checked.
- Linux Kernel Documentation, [Pressure Stall Information](https://docs.kernel.org/accounting/psi.html): current CPU, memory, and I/O pressure signals, including per-cgroup interfaces when configured. PSI is an observation signal, not a forecast.
- Linux Kernel Documentation, [systemd resource-control documentation](https://www.freedesktop.org/software/systemd/man/latest/systemd.resource-control.html): systemd exposes configuration for resource controls and may own target cgroups.
