# Linux Networking & Process Management

- **Tanggal:** 28 September 2026
- **Author:** unhypedrip

## Essential Networking CLI
- **Listening Sockets:** `ss -tulpn`
- **HTTP Verification:** `curl -I <URL>`
- **DNS Inspection:** `dig <domain> +short`
- **Process Monitoring:** `ps aux`, `top`, `htop`, `systemctl status <service>`

## Hands-On Script
Jalankan skrip pemeriksaan konektivitas jaringan:
```bash
./02-networking/net_checker.sh github.com 443
```
