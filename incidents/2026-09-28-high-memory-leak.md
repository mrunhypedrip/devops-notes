# Incident Post-Mortem Report

- **Tanggal:** 28 September 2026
- **Status:** Resolved
- **Author:** unhypedrip

## Summary
Layanan mengalami lonjakan *memory usage* akibat *process memory leak* pada *container worker*.

## Root Cause
Aplikasi gagal membebaskan alokasi memori setelah memproses *payload* file berukuran besar.

## Action Items
1. [x] Masking service yang gagal dan sesuaikan `.wslconfig` cgroup limits.
2. [x] Menambahkan limit memori pada *container definition* di Docker / Kubernetes.
