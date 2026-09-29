# Modul 01: Linux Fundamentals & Advanced Log Parsing

## 1. Konsep & Industri Utility
Log parsing otomatis digunakan untuk memantau error rate, deteksi brute-force attack, serta pembuatan JSON report terstruktur untuk integrasi alert system.

## 2. Topologi Alur Log Engine
```mermaid
graph LR
    Log[Access Log] --> Engine[advanced_log_parser.sh]
    Engine --> Stats[Kalkulasi Error Rate]
    Stats --> Report[Export JSON Report]
3. Komponen Utama
advanced_log_parser.sh : Script parsing log ke JSON report.

CHEATSHEET_DEVOPS_LINUX.md : Panduan 12 kategori command vital Linux.

hands_on_practice.sh : Script latihan profiling sistem.
