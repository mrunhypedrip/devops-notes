# Real-World Incident Troubleshooting Playbook

Panduan langkah taktis saat menghadapi masalah operasional server produksi.

## 1. Skenario: Server CPU/Memory High Alert (100% Load)
- **Gejala:** Response time aplikasi melambat, HTTP Status 504 Gateway Timeout.
- **Langkah Diagnosa:**
  1. Cek konsumsi proses tertinggi: `ps aux --sort=-%cpu | head -n 10`
  2. Cek apakah ada kecenderungan OOM (Out of Memory): `dmesg -T | grep -i oom`
  3. Identifikasi port yang terkunci: `ss -tulpn`
- **Mitigasi:** Kirim SIGHUP untuk reload graceful (`kill -HUP <PID>`) atau kill proses gantung (`kill -9 <PID>`).

## 2. Skenario: SSL Certificate Expired / Unsecure Warning
- **Gejala:** Browser memblokir akses user ke web publik.
%- **Langkah Diagnosa:**
  1. Jalankan skrip diagnosa SSL: `./02-networking/production_net_diag.sh domain.com 443`
  2. Cek tanggal pasti kadaluarsa via OpenSSL.
- **Mitigasi:** Renew sertifikat via Certbot / Let's Encrypt atau update Secret SSL di Kubernetes.

## 3. Skenario: Kubernetes Pod CrashLoopBackOff / Pending
- **Gejala:** Pod aplikasi tidak kunjung status `Running`.
- **Langkah Diagnosa:**
  1. Cek event log pod: `kubectl describe pod <pod-name> -n production`
  2. Cek log runtime Kontainer: `kubectl logs <pod-name> -n production --tail=100`
- **Penyebab Umum:**
  - *CrashLoopBackOff:* Error pada skrip aplikasi / gagal terkoneksi ke Redis database.
  - *Pending:* Cluster kehabisan resource CPU/RAM (periksa `requests` dan `limits` di manifest).
