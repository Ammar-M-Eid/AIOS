# Ubuntu VMware Telemetry Capture Guide

*A guide to the one minute passive sample*

This guide explains the Ubuntu environment record, collector settings, sample formats, field names, units, acronyms, and observed results from the 13 November 2026 VMware capture. The collector produced 61 host snapshots and 19,276 process rows in 60 seconds. The minute showed low guest-wide CPU use after the marked warm-up sample, stable available memory, and very small pressure-counter changes. It was a passive sample on Ubuntu 26.04.1, not an AIOS run, an Ubuntu 24.04 validation, or a controlled benchmark.

## 1 What was captured

The collector read host and process metrics through Python and psutil, plus Linux Pressure Stall Information (PSI) files under /proc/pressure. It wrote JSON Lines in the guest, and the output was copied into this project folder. The capture did not use sudo, eBPF, cgroup writes, process-priority changes, CPU affinity changes, or actuator actions.

The recorded window was 2026-11-13 18:23:31.050 UTC through 18:24:31.050 UTC. Each sampling pass records one host row and then one row for each visible process. The collector timestamps the pass once, so the host row and its process rows share the same UTC and monotonic timestamps. In this run, 316 process rows were written per pass: 61 x 316 = 19,276.

### Collector parameters

| Option | Value used | What it controls |
| --- | --- | --- |
| --output | /tmp/aios_telemetry_2026-11-13.jsonl | Guest-side destination for the raw JSON Lines file. The retained copy is under this folder's recordings directory. |
| --interval | 1 | Requests a sampling cadence of one second. The recorded host timestamps are about one second apart. |
| --duration | 60 | Stops after about 60 elapsed seconds. The loop takes an immediate first sample and also samples at the 60-second boundary, giving 61 time points. |
| --host-alias | ubuntu-26-04-vm01 | A label for this guest in the records; it is not the physical host name. |
| Privilege and controls | No elevated access | The command only reads telemetry and writes its output file. It does not change scheduling, memory limits, cgroups, or CPU placement. |

### Files and their roles

| File | Contents | How to use it |
| --- | --- | --- |
| telemetry.jsonl | 7,721,120 bytes; host and process records, one JSON object per line. | Raw source of the time-series data. Keep local because PIDs, process start times, and resource readings can be sensitive. |
| host_samples.csv | 61 host-only rows and a flattened subset of host fields. | Convenient for spreadsheet review. It omits process rows and some nested fields, so it is not a replacement for JSONL. |
| VM_Environment_Capture.txt | A separate guest environment snapshot and collector checksum. | Explains the OS, kernel, systemd, Python, psutil, CPU topology, memory, cgroup and PSI interfaces. |
| capture_manifest.json | Capture provenance, counts, summary values, limitations, and hashes. | Use to check where the sample came from and whether key files still match their recorded SHA-256 values. |
| VM_ReadOnly_Metadata_Capture.sh | The read-only shell commands used to record guest metadata. | Documents how the environment snapshot can be repeated. |
| README.md | Short capture interpretation and limitations. | Quick orientation; this guide provides the longer explanation. |

The JSONL file is the complete sample. The CSV is a convenience projection containing selected host fields only. For example, the raw host JSON retains per-CPU utilization, all three load averages, PSI some and full values, and disk operation counts; the CSV keeps a smaller set, including the one-minute load average, PSI some values, and disk byte totals.

Integrity values: telemetry.jsonl SHA-256 is 8cd652235a0d6429c9f41b2bb5c651339ddba5ef22f397d88c10a4df9529bdda. The collector source SHA-256 is b14379659d57b076945bbce18658f3db965ac95ec2ec5d4fbd6dc0030e1e35a7. The manifest contains hashes for the other captured files. SHA-256 fingerprints detect file changes; they do not encrypt the data.

## 2 Ubuntu environment explained

| Ubuntu output | Observed value | Meaning and limit |
| --- | --- | --- |
| Distribution | Ubuntu 26.04.1 LTS (Resolute) | The guest operating system used for this capture. The project design target remains Ubuntu 24.04 LTS, so this is not target-version validation. |
| Kernel | Linux 7.0.0-43-generic, x86_64 | The guest's Linux kernel build and 64-bit x86 architecture. |
| systemd | 259.5-0ubuntu3.4 | The service and system manager version installed in the guest. This does not mean AIOS services were installed or running. |
| Python and psutil | Python 3.14.4; psutil 7.1.0 | Runtime and library used by the read-only collector. |
| CPU topology | 2 logical CPUs; 1 thread per core; 1 core per socket; 2 sockets; 1 NUMA node | This is topology presented to the virtual machine. It does not reveal the physical host's core layout and does not show CPU pinning or a reserved AIOS core. |
| Memory | 3,513,298,944 bytes total; 44.9% used in the time series | About 3.27 GiB (3.51 decimal GB) visible to the guest. Available memory stayed around 1.80 GiB (1.94 decimal GB). |
| Swap | 3,529,502,720 bytes total; 46,018,560 bytes used | About 3.29 GiB of swap, with about 43.9 MiB used (1.3%). This was essentially unchanged during the sample. |
| cgroup filesystem | cgroup2fs | The guest exposed the unified cgroup v2 filesystem. Its presence alone does not prove that AIOS cgroups or resource limits were configured. |
| PSI interfaces | CPU, memory and I/O readable | The collector could parse /proc/pressure/cpu, memory and io. A readable interface is not itself evidence of resource pressure. |
| Temporary filesystem | /tmp mounted as tmpfs; 1% used in the metadata snapshot | A temporary filesystem visible to the guest. It is not an AIOS persistence or storage benchmark. |
| Process inventory | 316 processes in the environment snapshot | The collector recorded 316 process rows at each time point. Names and command lines were intentionally omitted. |

The environment text was captured at 18:27:17 UTC, after the telemetry window ended at 18:24:31 UTC. It is a separate point-in-time snapshot, so its memory readings can differ slightly from the time-series values without indicating an error.

## 3 How to read the records

### Host record fields

| Field | Unit or form | Meaning and reading advice |
| --- | --- | --- |
| record_type | Text | Identifies a row as host_sample or process_sample so readers can separate the two record types. |
| run_id | UUID text | One generated identifier shared by all records in this collection run; use it to group the capture. |
| host_alias | Text | The label ubuntu-26-04-vm01 used for this guest. |
| boot_id | UUID text; host rows | Linux boot identifier. It helps distinguish one boot session from another; it is not included in process rows. |
| ts_utc | RFC 3339 timestamp | Wall-clock time in UTC, shown with +00:00. Use it for human-readable ordering and cross-system comparison. |
| monotonic_ns | Nanoseconds | Monotonic clock reading from the guest. Its absolute origin is not meaningful; subtract two readings to estimate elapsed time without wall-clock adjustments. |
| quality.cpu_first_interval_warmup | True or False | True on the first host CPU row. Exclude that row from CPU averages; it reads 66.7% and is explicitly marked as warm-up. |
| cpu_pct | Percent | Guest-wide CPU utilization across its two logical CPUs. This is total guest activity, including the collector and other guest processes; it is not the collector's CPU cost. |
| cpu_per_core_pct | List of percentages | One utilization value per guest logical CPU, in stable CPU order. These are guest-visible vCPUs, not verified physical cores. |
| load_average | Three numbers | Linux load averages for 1, 5 and 15 minutes. They are queue/load indicators, not CPU percentages; they can include runnable and uninterruptible tasks. The capture started with history already accumulated before the one-minute run. |
| memory.total_bytes | Bytes | Physical memory visible to the guest, excluding swap. |
| memory.available_bytes | Bytes | Estimate of memory that can be given to processes without forcing swap. Prefer this to the free-memory figure when judging headroom. |
| memory.used_bytes and memory.percent | Bytes and percent | psutil's informational used value and percentage. The percentage is calculated from total and available memory; cached memory means used and free do not simply add to total. |
| swap.total_bytes, used_bytes, free_bytes, percent | Bytes and percent | Guest swap capacity and use. These fields are separate from physical RAM. |
| psi.<resource>.status | ok / parse_error / unsupported_or_unreadable | Describes whether the collector could read and parse the PSI file. All captured CPU, memory and I/O status values were ok. |
| psi.<resource>.some | avg10, avg60, avg300 percent; total microseconds | Some means at least one task was stalled on that resource. Averages describe the last 10, 60 and 300 seconds; total is cumulative since boot. Compare first and last totals for this run's change. |
| psi.<resource>.full | avg10, avg60, avg300 percent; total microseconds | Full means all non-idle tasks were stalled together. For system-wide CPU, the kernel defines full as unavailable and reports zero for compatibility, so CPU full=0 is not a CPU-pressure test result. |
| disk_io.read_bytes, write_bytes | Cumulative bytes | Guest-visible aggregate disk counters. Subtract consecutive samples and divide by elapsed seconds for an approximate rate. They are not per-process or physical-host counters. |
| disk_io.read_count, write_count | Cumulative operations | Guest-visible aggregate operation counters. These are retained in JSONL but not in the host CSV. |

### Process record fields

| Field | Unit or form | Meaning and reading advice |
| --- | --- | --- |
| process_ref.pid | Integer | Linux process identifier. PIDs may be reused, so do not use the PID alone as a long-term identity. |
| process_ref.start_time_epoch_s | Unix epoch seconds | Process start time. Paired with PID, it helps distinguish a new process from an older process that used the same PID. |
| status | Text | Process state at collection time, such as sleeping, idle or running. It is a point-in-time state, not a health rating. |
| cpu_pct | Percent per process | psutil's process CPU use since its prior reading. It uses a different scale from host cpu_pct and can exceed 100% for multithreaded processes; do not sum process percentages as though they total 100%. Process rows have no separate warm-up flag. |
| rss_bytes | Bytes | Resident Set Size: non-swapped physical memory currently used by the process. Shared pages can appear in multiple processes, so summing RSS may double-count shared memory. |
| vms_bytes | Bytes | Virtual Memory Size: the process's virtual address space. It is not the amount of physical RAM currently occupied. |
| io_counters.read_bytes / write_bytes | Cumulative bytes or null | Per-process byte counters when available. Null means unavailable in this row, not zero. This collector does not preserve a reason for every null. |
| quality.visibility | Text | The normal row says partial_if_permission_limited to warn that visibility may be incomplete. That label does not prove this row was denied. An explicit permission_denied row is a separate fallback emitted after AccessDenied. |

If a process disappears or becomes inaccessible, the collector may skip a vanished process or emit a shorter permission-denied row with null values. A null, a numeric zero and an omitted field are different: null means unavailable, zero is an observed numeric value, and an omitted field may indicate that the fallback row could not supply it.

### What the host CSV keeps

The CSV columns are ts_utc, monotonic_ns, cpu_pct, load_1m, memory_total_bytes, memory_used_bytes, memory_available_bytes, memory_pct, swap_used_bytes, CPU/memory/I/O PSI some averages and totals, disk read/write byte totals, and cpu_first_interval_warmup. It does not contain process-level rows, CPU-per-core values, the 5- and 15-minute load averages, PSI full values, or disk operation counts. Use telemetry.jsonl when those details matter.

## 4 What the sample shows

| Measure | Observed result | Plain-language interpretation |
| --- | --- | --- |
| Capture volume | 61 host samples; 19,276 process samples; 316 process rows per time point; one run ID | The collector continuously emitted both host and process records for the requested minute. |
| Host CPU | First sample 66.7% and warm-up flagged. The remaining 60 samples averaged 1.392%, ranging from 0.5% to 2.0%. | Guest-wide activity was low in this short sample after warm-up. This is not the collector's isolated CPU cost because no without-collector baseline was recorded. |
| RAM | Memory stayed at 44.9% used. Available memory ranged from 1,935,966,208 to 1,936,355,328 bytes, about 1.80 GiB. | The guest's available memory was stable during the minute. Linux's free-memory number was lower because available memory also accounts for reclaimable memory. |
| Swap | 46,018,560 bytes used (about 43.9 MiB, 1.3%); unchanged in the host CSV. | No swap growth was observed in this short sample. |
| PSI averages | Reported avg10 maximum was 0.00% for CPU, memory and I/O. | No sustained recent pressure appeared at the precision of these rolling averages. A short average of zero does not mean no brief stall ever occurred. |
| PSI counter changes | Some-stall total increased by 77,750 microseconds for CPU, 0 for memory and 5,898 microseconds for I/O. Full totals did not increase. | These are small cumulative counter changes over the interval. Totals are since boot; differences are more useful than the absolute totals. |
| Guest disk counters | Read-byte total did not change; write-byte total increased by 233,472 bytes. | Only a small guest-visible write-counter change was recorded. This is not a disk performance or latency benchmark. |
| Process states | 13,786 sleeping; 5,426 idle; 64 running rows. | Most process observations were sleeping or idle. These counts are rows across all time points, not unique processes per status. |
| Process I/O availability | 13,908 of 19,276 process rows had null I/O counters; 0 explicit permission_denied rows were recorded. | The collector could not report I/O counters for many rows, and did not record why each counter was null. Do not treat null as zero or assume all nulls mean denied access. |

Across all 61 host rows, available memory changed by 389,120 bytes (about 380 KiB). The first host row is included in this memory range; only its CPU value is marked as warm-up. This small range and the steady 44.9% memory value are descriptive of this VM during this one minute, not a guarantee under load.

### What we can conclude

- The collector ran successfully on this Ubuntu 26.04.1 VMware guest and wrote parseable host and process records.
- The guest exposed cgroup v2 and readable CPU, memory and I/O PSI interfaces, which supports feasibility planning for those read-only inputs.
- The observed minute had low guest-wide CPU use after the warm-up row, stable available memory, no swap increase, and zero PSI avg10 values at the recorded precision.
- The capture includes no AI inference, prediction, decision, dashboard, actuator or resource-control execution. It cannot show that AIOS improves performance or is safe under control mode.

### What we cannot conclude

- Ubuntu 24.04 compatibility: the guest is Ubuntu 26.04.1 and runs a different kernel, systemd, Python and psutil build.
- Collector overhead: host CPU includes the whole guest and the collector. No matched run with collection off was made, and the collector's own RAM/CPU was not isolated.
- Behavior under workload: the minute was not a controlled load test and did not include labeled application behavior or a repeated baseline.
- Core reservation or pinning: the 2-CPU topology is only what VMware presents to this guest. No CPU affinity or quota was applied or tested.
- AIOS implementation or benefit: no AIOS services or model decisions were exercised, and no OS resource action occurred.

### Recommended next evidence

- Repeat the same read-only capture on the specified Ubuntu 24.04 target and retain its environment and checksum metadata.
- To estimate collector cost, compare repeated matched runs with collection off and on, under both idle and approved representative workloads. Record collector-process CPU/RSS, host CPU/memory, PSI, and run-to-run variation.
- Keep missing-data reasons explicit in future records, especially for per-process I/O counters, so unavailable, denied and unsupported values can be distinguished.
- Keep resource-control experiments separate. Do not enable cgroup, priority or CPU-placement actions until bounds, ownership, rollback and safety checks have been reviewed and tested on the target host.

## 5 Acronym and unit glossary

| Term | Expanded form | Meaning here |
| --- | --- | --- |
| AIOS | AI-Native Adaptive Operating System | The proposed graduation project. It was not running during this capture. |
| CPU | Central Processing Unit | Processor resources visible to the guest. |
| vCPU | Virtual CPU | A virtual processor presented by VMware; it is not a direct count of physical host cores. |
| RAM | Random Access Memory | Physical memory assigned/visible to the guest. |
| VM | Virtual Machine | The Ubuntu guest running inside VMware Workstation. |
| OS | Operating System | Ubuntu and its Linux kernel in this capture. |
| LTS | Long Term Support | Ubuntu release designation shown in the guest version string. |
| PSI | Pressure Stall Information | Linux measurements of time tasks spend stalled because CPU, memory or I/O is contested. |
| I/O | Input/Output | Data read from or written to storage in these counters. |
| RSS | Resident Set Size | Non-swapped physical memory attributed to a process. |
| VMS | Virtual Memory Size | Virtual address space attributed to a process; not physical RAM use. |
| PID | Process Identifier | The guest's numeric identifier for a process; may be reused after a process exits. |
| UTC | Coordinated Universal Time | Timezone standard used in ts_utc timestamps. |
| ns / us | Nanoseconds / microseconds | One billionth / one millionth of a second. monotonic_ns is a clock reading; PSI total uses microseconds. |
| cgroup | Control group | Linux mechanism for grouping processes and applying resource controls. This run only observed that cgroup v2 was mounted. |
| NUMA | Non-Uniform Memory Access | Memory topology label. The guest reported one NUMA node; this does not describe the physical host fully. |
| JSONL | JSON Lines | A text format with one independent JSON object per line. |
| CSV | Comma-Separated Values | A table-like text format used here for host-only review. |
| UUID | Universally Unique Identifier | A long identifier used as run_id and boot_id. |
| SHA-256 | Secure Hash Algorithm 256-bit | A file fingerprint used to detect changes. It is not encryption and does not hide the data. |
| GB / GiB | Gigabyte / Gibibyte | GB uses powers of 1,000; GiB uses powers of 1,024. The capture stores bytes; this guide labels both when useful. |

## 6 Example records and how to read them

The first host row is timestamped 2026-11-13T18:23:31.050+00:00. It has record_type=host_sample, cpu_pct=66.7 and quality.cpu_first_interval_warmup=true. Keep the row as raw evidence, but exclude its CPU value from the steady-minute average. The same row reports 3,513,298,944 bytes total memory and 1,936,355,328 bytes available. Its CPU PSI some averages are avg10=0.00%, avg60=0.00% and avg300=0.06%; the longer windows include history from before this one-minute capture.

A process row from that same pass reports status=sleeping, cpu_pct=0.0, rss_bytes=17,571,840, vms_bytes=26,718,208 and io_counters=null. The process PID and start time are left out of this example, but they remain in the local raw JSONL. RSS is about 16.8 MiB and VMS about 25.5 MiB. The null I/O value means unavailable in that row; it is not a measured zero. Host and process rows share the timestamp because the collector creates one timestamp for each sampling pass.

## 7 References and provenance

The measurements and version strings above come from the captured Ubuntu files in this project folder. The references below explain the general Linux and psutil field meanings; they do not replace the guest's recorded values.

- Linux kernel PSI documentation, including some/full, rolling averages and cumulative microsecond totals [1].
- psutil documentation for CPU percentages, process RSS/VMS and system memory fields [2].
- Linux proc_loadavg manual page for the load-average and runnable/uninterruptible queue description [3].

[1] https://docs.kernel.org/7.0/accounting/psi.html
[2] https://psutil.readthedocs.io/stable/
[3] https://man7.org/linux/man-pages/man5/proc_loadavg.5.html
